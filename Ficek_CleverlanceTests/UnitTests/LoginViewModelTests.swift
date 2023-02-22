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
    
    func testLogin() async throws {
        
        let sut = withDependencies {
            $0.fetchImageUseCaseClient = .mock()
        } operation: {
            LoginViewModel()
        }
        
        XCTAssertEqual(sut.progressViewOpacity, 0)
        XCTAssertEqual(sut.isLogged, false)
        await sut.loginButtonDidTappedAsync()
       
        
        XCTAssertEqual(sut.progressViewOpacity, 0)
        XCTAssertEqual(sut.isLogged, true)
        
    }
    
    func testFailedLohin() async throws {
        let sut = withDependencies {
            $0.fetchImageUseCaseClient = FetchImageUseCaseClient(fetchImage: { _ in
                throw ResponseError.internalError
            })
        } operation: {
            LoginViewModel()
        }
        
        await sut.loginButtonDidTappedAsync()
        
        XCTAssertEqual(sut.wrongData, "Wrong username or password")
        XCTAssertEqual(sut.isLogged, false)
        
    }
}
