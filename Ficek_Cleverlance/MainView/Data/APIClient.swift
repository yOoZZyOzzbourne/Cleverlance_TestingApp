//
//  APIClient.swift
//  Ficek_Cleverlance
//
//  Created by Martin Ficek on 24.02.2023.
//

import Foundation
import Dependencies
import XCTestDynamicOverlay

extension DependencyValues {
    var apiClient: APIClient {
        get { self[APIClient.self] }
        set { self[APIClient.self] = newValue }
    }
}

struct APIClient {
    let request: (URLRequest) async throws -> (Data, URLResponse)
}

extension APIClient: DependencyKey {
    static var liveValue: APIClient {
        return Self(
            request: { request in
                try await URLSession.shared.data(for: request)
            }
        )
    }
}
