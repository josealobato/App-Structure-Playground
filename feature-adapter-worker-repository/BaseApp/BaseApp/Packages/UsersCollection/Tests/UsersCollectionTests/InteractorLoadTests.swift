import XCTest
import struct Entities.User
@testable import UsersCollection

@MainActor
class InteractorTests: XCTestCase {
    
    var interactor: Interactor!
    var servicesMock: UsersCollectionServiceInterfaceMock!
    var outputMock: InteractorOutputMock!

    override func setUp() {
        
        servicesMock = UsersCollectionServiceInterfaceMock()
        interactor = Interactor(services: servicesMock)
        
        outputMock = InteractorOutputMock()
        interactor.output = outputMock
    }
    
    func test_LoadData() async {
        
        // GIVEN there the module is created and
        // a service with users.
        servicesMock.usersFirstPageReturnValue = twoUsers()
        
        // WHEN there is a request to load the data
        await interactor.request(.loadInitialData)
        
        // THEN the services are queried for users and rendered.
        XCTAssert(outputMock.dispatchCalled)
        // Receiving two events
        // - one to inform the user that we are loading
        // - another with the data received.
        XCTAssertEqual(outputMock.dispatchReceivedInvocations,
                       [.startLoading, .refresh(twoUsers())])
        
    }
    
    // MARK: - Test Data.
    
    private func twoUsers() -> [User] {
        [
            User(id: "1", email: "anemail@mail.com", name: User.NameParts(title: "Mr", first: "John", last: "Lavine")),
            User(id: "2", email: "anemail@mail.com", name: User.NameParts(title: "Ms", first: "Jane", last: "McNamara"))
        ]
    }
}
