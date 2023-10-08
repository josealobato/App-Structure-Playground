import XCTest
@testable import Repositories

final class UserRepositoryNoRemoteTests: XCTestCase {
    
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
    
    /// Tests not developed see `UserRepositoryFirstPageTests` for an
    /// example of this kind of test.
}
