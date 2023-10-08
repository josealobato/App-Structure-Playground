import XCTest
import struct Entities.Message
@testable import Feature

@MainActor
class InteractorTests: XCTestCase {
    
    var interactor: Interactor!
    var servicesMock: FeatureServiceInterfaceMock!
    var outputMock: InteractorOutputMock!

    override func setUp() {
        
        servicesMock = FeatureServiceInterfaceMock()
        interactor = Interactor(services: servicesMock)
        
        outputMock = InteractorOutputMock()
        interactor.output = outputMock
    }
    
    func test_LoadData() async {
        
        // GIVEN there the module is created and
        // a service with messages.
        servicesMock.messagesReturnValue = twoMessages()
        
        // WHEN there is a request to load the data
        await interactor.request(.loadInitialData)
        
        // THEN the services are queried for messages and rendered.
        XCTAssert(outputMock.dispatchCalled)
        // Receiving two events
        // - one to inform the user that we are loading
        // - another with the data received.
        XCTAssertEqual(outputMock.dispatchReceivedInvocations,
                       [.startLoading, .refresh(twoMessages())])
        
    }
    
    // MARK: - Test Data.
    
    private func twoMessages() -> [Message] {
        [
            Message(id: "1", title: "One", message: "This is message One"),
            Message(id: "2", title: "Two", message: "This is message Two")
        ]
    }
}
