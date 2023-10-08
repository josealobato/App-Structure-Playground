import XCTest
@testable import Repositories

final class UserRepositoryStreamStrategyFirstPageTests: XCTestCase {
    
    var repository: UsersRepository!
    var remoteStorageMock: UsersRemoteStorageProtocolMock!
    var localStorageMock: UsersLocalStorageProtocolMock!
    
    override func setUp() {
        
        super.setUp()
        remoteStorageMock = UsersRemoteStorageProtocolMock()
        localStorageMock = UsersLocalStorageProtocolMock()
        repository = UsersRepository(remoteStorage: remoteStorageMock,
                                     localStorage: localStorageMock)
    }
    
    func testfirstPageWeGetTheRemoteData() async throws {
        
        // GIVEN that there is connectivity,
        remoteStorageMock.isAvailableReturnValue = true
        // there is remote data,
        remoteStorageMock.usersOnPageReturnValue = twoRemoteDataUsers
        // and we dont case about local data
        
        // WHEN request the first page
        var batches = 0
        for await users in repository.usersFirstPage() {
            // THEN we get the page from remote.
            XCTAssertEqual(users, twoRemoteDataUsers)
            batches += 1
        }
        
        // and only that
        XCTAssertEqual(batches, 1)
    }
    
    func testfirstPageRemoteDataIsStored() async throws {
        
        // GIVEN that there is connectivity,
        remoteStorageMock.isAvailableReturnValue = true
        // there is remote data,
        remoteStorageMock.usersOnPageReturnValue = twoRemoteDataUsers
        // and we dont case about local data.
        
        // WHEN request the first page
        for await _ in repository.usersFirstPage() { /* do nothing */ }
        
        // THEN the remote data is stored in the local storage.
        XCTAssertEqual(localStorageMock.persistUsersReceivedUsers,
                       twoRemoteDataUsers)
    }
    
    func testfirstPageWithNoConnection() async throws {
        
        // GIVEN that there is NO connectivity,
        remoteStorageMock.isAvailableReturnValue = false
        // and there is local data
        localStorageMock.retriveUsersReturnValue = twoLocalDataUsers
        
        // WHEN request the first page
        var batches = 0
        for await users in repository.usersFirstPage() {
            // THEN we get the page from local.
            XCTAssertEqual(users, twoLocalDataUsers)
            batches += 1
        }
        
        // and only that.
        XCTAssertEqual(batches, 1)
        // and remote is not queried.
        XCTAssertFalse(remoteStorageMock.usersOnPageCalled)
    }
    
    func testfirstPageWithNoConnectionAndNoData() async throws {
        
        // GIVEN that there is NO connectivity,
        remoteStorageMock.isAvailableReturnValue = false
        // and there is local data
        localStorageMock.retriveUsersReturnValue = []
        
        // WHEN request the first page
        var batches = 0
        for await users in repository.usersFirstPage() {
            // THEN we get the empty page
            XCTAssert(users.isEmpty)
            batches += 1
        }
        
        // and only that.
        XCTAssertEqual(batches, 1)
        // and remote is not queried.
        XCTAssertFalse(remoteStorageMock.usersOnPageCalled)
    }
    
    // MARK: - Test Data
    
    let twoRemoteDataUsers = [
        UserDataEntity(id: "1",
                       email: "one@me.com",
                       name: UserDataEntity.NameParts(title: "Ms",
                                                      first: "Jane",
                                                      last: "Logan")),
        UserDataEntity(id: "2",
                       email: "Two@me.com",
                       name: UserDataEntity.NameParts(title: "Mr",
                                                      first: "Paul",
                                                      last: "Smith"))
    ]
    
    let twoLocalDataUsers = [
        UserDataEntity(id: "111",
                       email: "one@me.com",
                       name: UserDataEntity.NameParts(title: "Ms",
                                                      first: "Jane",
                                                      last: "Logan")),
        UserDataEntity(id: "112",
                       email: "Two@me.com",
                       name: UserDataEntity.NameParts(title: "Mr",
                                                      first: "Paul",
                                                      last: "Smith"))
    ]
}
