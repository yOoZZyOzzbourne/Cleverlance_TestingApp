//
//  SecurityClient.swift
//  Ficek_Cleverlance
//
//  Created by Martin Ficek on 24.02.2023.
//

import Foundation
import CryptoKit
import Dependencies
import XCTestDynamicOverlay

extension DependencyValues {
    var securityClient: SecurityClient {
        get { self[SecurityClient.self] }
        set { self[SecurityClient.self] = newValue }
    }
}

struct SecurityClient {
    enum SecurityError: Error {
        case dataAreNil
    }
    
    let sha1: (String) throws -> String
}

extension SecurityClient: DependencyKey {
    static let liveValue = SecurityClient(
        sha1: { input in
            guard let inputData = input.data(using: .utf8) else {
                throw SecurityError.dataAreNil
            }
            let hashed = Insecure.SHA1.hash(data: inputData)
            return hashed.compactMap { String (format: "%02x", $0) }.joined()
        }
    )
}
