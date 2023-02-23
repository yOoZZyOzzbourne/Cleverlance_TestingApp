//
//  ImageRepositoryTests.swift
//  Ficek_CleverlanceTests
//
//  Created by Martin Ficek on 23.02.2023.
//

import Foundation
import XCTest
@testable import Ficek_Cleverlance
import Dependencies
import Combine

@MainActor
final class ImageRepositoryTests: XCTestCase {
    
    let jsonMock = """
    {
        "image": "iVBORw0KGgoAAAANSUhEUgAAAAEAAAABCAQAAAC1HAwCAAAAC0lEQVR42mNk+A8AAQUBAScY42YAAAAASUVORK5CYII="
    }
    """

    let url = URL(string: "https://mobility.cleverlance.com/download/bootcamp/image.php")


    func testImageRepository() async throws {
        let data = jsonMock.data(using: .utf8)
        let mockResponse = HTTPURLResponse.init(url: url!, statusCode: 200, httpVersion: nil , headerFields: nil)

        
        let sut = withDependencies {
            $0.apiClient = APIClient(request: { _ in
                return (data!, mockResponse!)
            })
            
        } operation: {
            ImageRepositoryClient.liveValue
        }
        
        let response = try await sut.fetchImage(ImageRepositoryClient.Input(username: "", password: ""))
        
        XCTAssertEqual(response.image, "iVBORw0KGgoAAAANSUhEUgAAAAEAAAABCAQAAAC1HAwCAAAAC0lEQVR42mNk+A8AAQUBAScY42YAAAAASUVORK5CYII=" )
    }
    
    
}
