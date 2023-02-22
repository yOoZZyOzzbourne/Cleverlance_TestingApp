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
        sut.loginButtonDidTappedAsync()
       
        
        XCTAssertEqual(sut.progressViewOpacity, 100)
      //  XCTAssertEqual(sut.isLogged, true)
        
    }
}
