//
//  LoginViewModelTests.swift
//  Ficek_CleverlanceTests
//
//  Created by Martin Ficek on 21.02.2023.
//

import Foundation
import XCTest
@testable import Ficek_Cleverlance
import Dependencies
import Combine

@MainActor
final class LoginViewModelTests: XCTestCase {
    
    func testLogin() async {
        
        let sut = withDependencies {
            $0.fetchImageUseCaseClient = .mock()
        } operation: {
            LoginViewModel()
        }
        
        XCTAssertEqual(sut.progressViewOpacity, 0)
        XCTAssertEqual(sut.isLogged, false)
        
        await sut.loginButtonDidTapped()
       
        XCTAssertEqual(sut.progressViewOpacity, 0)
        XCTAssertEqual(sut.isLogged, true)
        
    }
    
    func testFailedLohin() async {
        let sut = withDependencies {
            $0.fetchImageUseCaseClient = FetchImageUseCase(
                fetchImage: { _ in
                    throw ResponseError.internalError
                }
            )
        } operation: {
            LoginViewModel()
        }
        
        await sut.loginButtonDidTapped()
        
        XCTAssertEqual(sut.wrongData, "Wrong username or password")
        XCTAssertEqual(sut.isLogged, false)
        
    }
    
    private var viewModel: LoginViewModel!

    override func setUp() {
        super.setUp()
        viewModel = LoginViewModel()
    }

    func testSendingDisabledWhileMessageIsEmpty() {
        XCTAssertTrue(viewModel.isSendingDisabled)
        XCTAssertEqual(viewModel.buttonColor, .gray)
        viewModel.username = "Message"
        XCTAssertTrue(viewModel.isSendingDisabled)
        viewModel.password = "Message"
        XCTAssertFalse(viewModel.isSendingDisabled)
        XCTAssertEqual(viewModel.buttonColor, .green)
    }
}
