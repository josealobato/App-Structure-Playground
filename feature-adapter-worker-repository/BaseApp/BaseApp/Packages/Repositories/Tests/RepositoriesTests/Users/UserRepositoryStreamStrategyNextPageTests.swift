import XCTest
@testable import Repositories

final class UserRepositoryStreamStrategyNextPageTests: XCTestCase {
    
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
    
    // MARK: - Testing Page Indexes
    
    func testPageIndexWhenMultipleNextPagesRequests() async throws {
        
        // GIVEN that there is connectivity,
        remoteStorageMock.isAvailableReturnValue = true
        // there is remote data,
        remoteStorageMock.usersOnPageReturnValue = twoRemoteDataUsers
        // and there is local data.
        localStorageMock.retriveUsersReturnValue = twoLocalDataUsers
        
        // WHEN request the next page several times
        // THEN the page requested increase monotonically.
        for await _ in repository.usersNextPage() { }
        XCTAssertEqual(remoteStorageMock.usersOnPageReceivedOnPage, 1)
        for await _ in repository.usersNextPage() { }
        XCTAssertEqual(remoteStorageMock.usersOnPageReceivedOnPage, 2)
        for await _ in repository.usersNextPage() { }
        XCTAssertEqual(remoteStorageMock.usersOnPageReceivedOnPage, 3)
    }
    
    func testPageIndexWhenNextPagesRequestsAfterFistPage() async throws {
        
        // GIVEN that there is connectivity,
        remoteStorageMock.isAvailableReturnValue = true
        // there is remote data,
        remoteStorageMock.usersOnPageReturnValue = twoRemoteDataUsers
        // and there is local data.
        localStorageMock.retriveUsersReturnValue = twoLocalDataUsers
        
        // WHEN serveral pages has been requested,
        for await _ in repository.usersFirstPage() { }
        XCTAssertEqual(remoteStorageMock.usersOnPageReceivedOnPage, 0)
        for await _ in repository.usersNextPage() { }
        XCTAssertEqual(remoteStorageMock.usersOnPageReceivedOnPage, 1)
        for await _ in repository.usersNextPage() { }
        XCTAssertEqual(remoteStorageMock.usersOnPageReceivedOnPage, 2)
        // and requesting first page again.
        for await _ in repository.usersFirstPage() { }
        // THEN next page start over at 1.
        XCTAssertEqual(remoteStorageMock.usersOnPageReceivedOnPage, 0)
        for await _ in repository.usersNextPage() { }
        XCTAssertEqual(remoteStorageMock.usersOnPageReceivedOnPage, 1)
    }
    
    // MARK: - Testing Next Page Data order
    
    func testNextPageWithLocalAndRemoteData() async throws {
        
        // GIVEN that there is connectivity,
        remoteStorageMock.isAvailableReturnValue = true
        // there is remote data,
        remoteStorageMock.usersOnPageReturnValue = twoRemoteDataUsers
        // and there is local data.
        localStorageMock.retriveUsersReturnValue = twoLocalDataUsers
        
        // WHEN request the next page
        var batches = 0
        for await users in repository.usersNextPage() {
            
            if batches == 0 {
                // THEN we get the page from local first
                XCTAssertEqual(users, twoLocalDataUsers)
            } else {
                // and later those plus the remote data.
                XCTAssertEqual(users, twoLocalDataUsers + twoRemoteDataUsers)
            }
            batches += 1
        }
        
        // and only that.
        XCTAssertEqual(batches, 2)
    }
    


    
//    func testfirstPageRemoteDataIsStored() async throws {
//
//        // GIVEN that there is connectivity,
//        remoteStorageMock.isAvailableReturnValue = true
//        // there is remote data,
//        remoteStorageMock.usersOnPageReturnValue = twoRemoteDataUsers
//        // and we dont case about local data.
//
//        // WHEN request the first page
//        for await _ in repository.usersFirstPage() { /* do nothing */ }
//
//        // THEN the remote data is stored in the local storage.
//        XCTAssertEqual(localStorageMock.persistUsersReceivedUsers,
//                       twoRemoteDataUsers)
//    }
    
//    func testfirstPageWithNoConnection() async throws {
//
//        // GIVEN that there is NO connectivity,
//        remoteStorageMock.isAvailableReturnValue = false
//        // and there is local data
//        localStorageMock.retriveUsersReturnValue = twoLocalDataUsers
//
//        // WHEN request the first page
//        var batches = 0
//        for await users in repository.usersFirstPage() {
//            // THEN we get the page from local.
//            XCTAssertEqual(users, twoLocalDataUsers)
//            batches += 1
//        }
//
//        // and only that.
//        XCTAssertEqual(batches, 1)
//        // and remote is not queried.
//        XCTAssertFalse(remoteStorageMock.usersOnPageCalled)
//    }
    
//    func testfirstPageWithNoConnectionAndNoData() async throws {
//
//        // GIVEN that there is NO connectivity,
//        remoteStorageMock.isAvailableReturnValue = false
//        // and there is local data
//        localStorageMock.retriveUsersReturnValue = []
//
//        // WHEN request the first page
//        var batches = 0
//        for await users in repository.usersFirstPage() {
//            // THEN we get the empty page
//            XCTAssert(users.isEmpty)
//            batches += 1
//        }
//
//        // and only that.
//        XCTAssertEqual(batches, 1)
//        // and remote is not queried.
//        XCTAssertFalse(remoteStorageMock.usersOnPageCalled)
//    }
    
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
