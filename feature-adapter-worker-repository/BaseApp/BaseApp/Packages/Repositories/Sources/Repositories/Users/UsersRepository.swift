import Foundation

/// The internal repositories implements the public repositories protocol.
///
/// It is also the place to have a smart implementation and decide if the data comes
/// from internal on device cache or from the remote services. That way it abstracts
/// the handling of data from the rest of the application.
///

/// Read about the Offline Strategy on this package `README.md` file.
///
/// ** KNOWN ISSUE **
///
/// When fetching data from local storage, the order might to match the one comming
/// from the pages, that makes a glitch on the inteface. You will see this when
/// pull load on cold start with no connection. The order of the users will be different than
/// the one on comming from the remote.
///
/// This could be solved making the local cache aware of the pages and save and recover
/// pages as well from the cache as we do from the remote.
///

private let artificialPageLimit = 10

final class UsersRepository: UsersRepositoryProtocol {
    
    private let remoteStorage: UsersRemoteStorageProtocol
    private let localStorage: UsersLocalStorageProtocol
    
    /// Pagination is manage by the repository. The `page` variable keeps
    /// the state of the last page requested.
    var page = 0
    
    /// In this repo we keep the total user requested.
    /// That could be unnecesary depending on the strategy implemented on the
    /// repository. Here the local storage is only used when the remote storage is
    /// not available but we could return always the local storage and feed it with
    /// the remote storage and then we wont need this variable.
    var usersCollection: [UserDataEntity] = []
    
    init(remoteStorage: UsersRemoteStorageProtocol,
         localStorage: UsersLocalStorageProtocol) {
        
        self.remoteStorage = remoteStorage
        self.localStorage = localStorage
    }
    
    /// Fetch the users.
    ///
    /// It will fetch one page on every call and return all user that has been fetch until
    /// that moment. It will restart from page zero when requested (with `fromScratch`).
    ///
    /// When there is no connection it will return what we had fetch before and `fromScratch`
    /// will be ignored.
    ///
    /// - Parameter fromScratch: Restart from page. It will only work if there is connection
    /// - Returns: All entities fetched up to the moment.
    private func users(fromScratch: Bool = false) async throws -> [UserDataEntity] {
        
        /// As the simplest strategy possible, when there is no connectivity we just
        /// return the data we have on local storage at that moment. (see `README.md`)
        let isRemoteAvailable = await remoteStorage.isAvailable()
        if !isRemoteAvailable {
            
            // if the collection is empty it will mean cold start and then we will use the cache.
            if usersCollection.isEmpty {
                return await localStorage.retriveUsers()
            } else {
                // Otherwise using the current collection might suffice.
                return usersCollection
            }
        }
        
        // When requested we will clean up and start over.
        if (fromScratch) {
            
            page = 0
            usersCollection.removeAll()
            await localStorage.removeAllUsers()
            
        } else {
            
            page += 1
        }
        
        do {
            
            /// We will get the data from the remote storage, and
            let users = try await remoteStorage.users(onPage: page)
            /// persist it in local storage for later use.
            await localStorage.persist(users: users)
            /// and in the internal collection.
            usersCollection.append(contentsOf: users)
            
            return usersCollection
        } catch {
            
            throw RepositoryError.build(error: error)
        }
    }
    
    // MARK: - Public interface with UsersRepositoryProtocol
    
    func usersNextPage() async throws -> [UserDataEntity] {
       
        // This is an artificial limit to test last page.
        guard page < artificialPageLimit else {
            
            return usersCollection
        }
        
        let users = try await users()
                
        return users
    }
    
    func usersFirstPage() async throws -> [UserDataEntity] {
                
        let users = try await users(fromScratch: true)
        
        return users
    }
    
    // Strategy 2:
    
    private func increasePage() -> Int { page += 1; return page }
    private func resetPage() { page = 0 }
    
    func usersFirstPage() -> AsyncStream<[UserDataEntity]> {
        
        let stream = AsyncStream { [resetPage, localStorage, remoteStorage] continuation in
            
            Task {
                
                // 1. Since we are starting from scratch, if we nave remote available
                // we clean the local storage.
                let isRemoteAvailable = await remoteStorage.isAvailable()
                if isRemoteAvailable {
                    
                    await localStorage.removeAllUsers()
                } else {
                    // 1.1. When remote is not available we send back the local storage values,
                    //      entering the offline mode.
                    let storedResults = await localStorage.retriveUsers()
                    continuation.yield(storedResults)
                    // 1.2. we finish the stream since there is no connection.
                    continuation.finish()
                    return
                }
                
                // 2. Retrive the results from the remote storage and yield it.
                resetPage()
                let remoteResults = try await remoteStorage.users(onPage: 0)
                continuation.yield(remoteResults)
                
                // 3. Save the latest data received to the local storage.
                await localStorage.persist(users: remoteResults)
                
                // 4. Terminate the connecton.
                continuation.finish()
            }
        }
        
        return stream
    }
    
    func usersNextPage() -> AsyncStream<[UserDataEntity]> {
        
        let stream = AsyncStream { [increasePage, localStorage, remoteStorage] continuation in
            
            Task {
                                
                // 1. Retrieving the result from the local storage and yield it if any.
                let storedResults = await localStorage.retriveUsers()
                if !storedResults.isEmpty {
                    continuation.yield(storedResults)
                }
                
                // 2. Retrive the results from the remote storage and yield them together
                //    with the local sorage results.
                let nextPage = increasePage()
                let remoteResults = try await remoteStorage.users(onPage: nextPage)
                continuation.yield(storedResults + remoteResults)
                
                // 3. Save the latest storage status on the local cache.
                await localStorage.persist(users: remoteResults)
                
                // 4. Terminate the connecton.
                continuation.finish()
            }
        }
        
        return stream
    }
}
