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

@testable import Repositories;














final class UsersLocalStorageProtocolMock: UsersLocalStorageProtocol {

    //MARK: - persist

    var persistUsersCallsCount = 0
    var persistUsersCalled: Bool {
        return persistUsersCallsCount > 0
    }
    var persistUsersReceivedUsers: [UserDataEntity]?
    var persistUsersReceivedInvocations: [[UserDataEntity]] = []
    var persistUsersClosure: (([UserDataEntity]) -> Void)?

    func persist(users: [UserDataEntity]) async {
        persistUsersCallsCount += 1
        persistUsersReceivedUsers = users
        persistUsersReceivedInvocations.append(users)
        persistUsersClosure?(users)
    }

    //MARK: - removeAllUsers

    var removeAllUsersCallsCount = 0
    var removeAllUsersCalled: Bool {
        return removeAllUsersCallsCount > 0
    }
    var removeAllUsersClosure: (() -> Void)?

    func removeAllUsers() async {
        removeAllUsersCallsCount += 1
        removeAllUsersClosure?()
    }

    //MARK: - retriveUsers

    var retriveUsersCallsCount = 0
    var retriveUsersCalled: Bool {
        return retriveUsersCallsCount > 0
    }
    var retriveUsersReturnValue: [UserDataEntity]!
    var retriveUsersClosure: (() -> [UserDataEntity])?

    func retriveUsers() async -> [UserDataEntity] {
        retriveUsersCallsCount += 1
        return retriveUsersClosure.map({ $0() }) ?? retriveUsersReturnValue
    }

}
final class UsersRemoteStorageProtocolMock: UsersRemoteStorageProtocol {

    //MARK: - isAvailable

    var isAvailableCallsCount = 0
    var isAvailableCalled: Bool {
        return isAvailableCallsCount > 0
    }
    var isAvailableReturnValue: Bool!
    var isAvailableClosure: (() -> Bool)?

    func isAvailable() async -> Bool {
        isAvailableCallsCount += 1
        return isAvailableClosure.map({ $0() }) ?? isAvailableReturnValue
    }

    //MARK: - users

    var usersOnPageThrowableError: Error?
    var usersOnPageCallsCount = 0
    var usersOnPageCalled: Bool {
        return usersOnPageCallsCount > 0
    }
    var usersOnPageReceivedOnPage: Int?
    var usersOnPageReceivedInvocations: [Int] = []
    var usersOnPageReturnValue: [UserDataEntity]!
    var usersOnPageClosure: ((Int) throws -> [UserDataEntity])?

    func users(onPage: Int) async throws -> [UserDataEntity] {
        if let error = usersOnPageThrowableError {
            throw error
        }
        usersOnPageCallsCount += 1
        usersOnPageReceivedOnPage = onPage
        usersOnPageReceivedInvocations.append(onPage)
        return try usersOnPageClosure.map({ try $0(onPage) }) ?? usersOnPageReturnValue
    }

}
