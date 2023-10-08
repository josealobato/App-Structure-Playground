// Generated using Sourcery 2.1.1 — https://github.com/krzysztofzablocki/Sourcery
// DO NOT EDIT

// swiftlint:disable line_length
// swiftlint:disable variable_name

import Foundation
#if os(iOS) || os(tvOS) || os(watchOS)
import UIKit
#elseif os(OSX)
import AppKit
#endif

@testable import UsersCollection; import Entities;














final class InteractorInputMock: InteractorInput {

    //MARK: - request

    var requestCallsCount = 0
    var requestCalled: Bool {
        return requestCallsCount > 0
    }
    var requestReceivedEvent: InteractorEvents.Input?
    var requestReceivedInvocations: [InteractorEvents.Input] = []
    var requestClosure: ((InteractorEvents.Input) -> Void)?

    func request(_ event: InteractorEvents.Input) async {
        requestCallsCount += 1
        requestReceivedEvent = event
        requestReceivedInvocations.append(event)
        requestClosure?(event)
    }

}
final class InteractorOutputMock: InteractorOutput {

    //MARK: - dispatch

    var dispatchCallsCount = 0
    var dispatchCalled: Bool {
        return dispatchCallsCount > 0
    }
    var dispatchReceivedEvent: InteractorEvents.Output?
    var dispatchReceivedInvocations: [InteractorEvents.Output] = []
    var dispatchClosure: ((InteractorEvents.Output) -> Void)?

    func dispatch(_ event: InteractorEvents.Output) {
        dispatchCallsCount += 1
        dispatchReceivedEvent = event
        dispatchReceivedInvocations.append(event)
        dispatchClosure?(event)
    }

}
final class UsersCollectionServiceInterfaceMock: UsersCollectionServiceInterface {

    //MARK: - usersFirstPage

    var usersFirstPageThrowableError: Error?
    var usersFirstPageCallsCount = 0
    var usersFirstPageCalled: Bool {
        return usersFirstPageCallsCount > 0
    }
    var usersFirstPageReturnValue: [User]!
    var usersFirstPageClosure: (() throws -> [User])?

    func usersFirstPage() async throws -> [User] {
        if let error = usersFirstPageThrowableError {
            throw error
        }
        usersFirstPageCallsCount += 1
        return try usersFirstPageClosure.map({ try $0() }) ?? usersFirstPageReturnValue
    }

    //MARK: - usersNextPage

    var usersNextPageThrowableError: Error?
    var usersNextPageCallsCount = 0
    var usersNextPageCalled: Bool {
        return usersNextPageCallsCount > 0
    }
    var usersNextPageReturnValue: [User]!
    var usersNextPageClosure: (() throws -> [User])?

    func usersNextPage() async throws -> [User] {
        if let error = usersNextPageThrowableError {
            throw error
        }
        usersNextPageCallsCount += 1
        return try usersNextPageClosure.map({ try $0() }) ?? usersNextPageReturnValue
    }

}
