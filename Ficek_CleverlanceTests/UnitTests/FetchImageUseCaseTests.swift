//
//  FetchImageUseCaseTests.swift
//  Ficek_Cleverlance
//
//  Created by Martin Ficek on 21.02.2023.
//

import Foundation
import XCTest
@testable import Ficek_Cleverlance
import Dependencies

@MainActor
final class FetchingImageUseCaseTests: XCTestCase {
    
    func testFetchingImage() async throws {
     
        let sut = withDependencies {
            $0.imageRepositoryClient = .mock()
        } operation: {
            FetchImageUseCaseClient.liveValue
        }
        
        let image = try await sut.fetchImage(FetchImageUseCaseClient.Input(username: "", password: ""))
        
        XCTAssertEqual(image.image, "iVBORw0KGgoAAAANSUhEUgAAAAEAAAABCAQAAAC1HAwCAAAAC0lEQVR42mNk+A8AAQUBAScY42YAAAAASUVORK5CYII=")
    }
}
