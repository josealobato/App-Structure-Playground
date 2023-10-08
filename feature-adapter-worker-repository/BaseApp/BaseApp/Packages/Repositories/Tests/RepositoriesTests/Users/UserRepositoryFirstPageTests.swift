import XCTest
@testable import Repositories

final class UserRepositoryFirstPageTests: XCTestCase {
    
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
    
    func testRequestingFirstPageWithConnectivityAndNoRemoteData() async throws {
        
        // GIVEN that there is connectivity,
        remoteStorageMock.isAvailableReturnValue = true
        // and no remote data,
        remoteStorageMock.usersOnPageReturnValue = []
        
        // WHEN request the first page,
        let users = try await repository.usersFirstPage()
        
        // THEN the remote is queried for page 0,
        XCTAssert(remoteStorageMock.usersOnPageCalled)
        XCTAssertEqual(remoteStorageMock.usersOnPageReceivedOnPage, 0)
        // and no value is returned.
        XCTAssertEqual(users.count, 0)
    }
    
    func testRequestingFirstPageWithConnectivityAndRemoteData() async throws {
        
        // GIVEN that there is connectivity,
        remoteStorageMock.isAvailableReturnValue = true
        // and some remote data,
        remoteStorageMock.usersOnPageReturnValue = twoDataUsers
        
        // WHEN request the first page,
        let users = try await repository.usersFirstPage()
        
        // THEN the remote is queried for page 0,
        XCTAssert(remoteStorageMock.usersOnPageCalled)
        XCTAssertEqual(remoteStorageMock.usersOnPageReceivedOnPage, 0)
        // and values are returned.
        XCTAssertEqual(users.count, 2)
        XCTAssertEqual(users, twoDataUsers)
    }
    
    func testRequestingFirstPageWithConnectivityAndRemoteDataSavedOnLocalStore() async throws {
        
        // GIVEN that there is connectivity,
        remoteStorageMock.isAvailableReturnValue = true
        // and some remote data,
        remoteStorageMock.usersOnPageReturnValue = twoDataUsers
        
        // WHEN request the first page,
        _ = try await repository.usersFirstPage()
        
        // THEN the data received from remote is stored in the local store
        XCTAssert(localStorageMock.persistUsersCalled)
        XCTAssertEqual(localStorageMock.persistUsersReceivedUsers!.count, 2)
        XCTAssertEqual(localStorageMock.persistUsersReceivedUsers!, twoDataUsers)
    }
    
    // MARK: - Test Data
    
    let twoDataUsers = [
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
    
}
