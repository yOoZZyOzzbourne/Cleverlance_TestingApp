//
//  LoginViewUITests.swift
//  Ficek_CleverlanceTests
//
//  Created by Martin Ficek on 22.02.2023.
//

import Foundation
@testable import Ficek_Cleverlance
import SwiftUI
import XCTest

@MainActor
class SendMessageViewModelTests: XCTestCase {
    private var viewModel: LoginViewModel!

    @MainActor override func setUp() {
        super.setUp()
        viewModel = LoginViewModel()
    }

    func testSendingDisabledWhileMessageIsEmpty() {
        XCTAssertTrue(viewModel.isSendingDisabled)
        viewModel.username = "Message"
        XCTAssertTrue(viewModel.isSendingDisabled)
        viewModel.password = "Message"
        XCTAssertFalse(viewModel.isSendingDisabled)
    }
}
