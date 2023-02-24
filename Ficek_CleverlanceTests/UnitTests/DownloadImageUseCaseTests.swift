//
//  DownloadImageUseCaseTests.swift
//  Ficek_CleverlanceTests
//
//  Created by Martin Ficek on 22.02.2023.
//

import Foundation
import XCTest
@testable import Ficek_Cleverlance
import Dependencies
import SwiftUI

final class DownloadImageUseCaseTests: XCTestCase {
    
    func testDownloadImage() async throws {
        
        let sut = withDependencies { _ in
        } operation: {
            DownloadImageUseCaseClient.liveValue
        }
        
        let image = try sut.downloadImage(
            DownloadImageUseCaseClient.Input(
                imageString: "iVBORw0KGgoAAAANSUhEUgAAAAEAAAABCAQAAAC1HAwCAAAAC0lEQVR42mNk+A8AAQUBAScY42YAAAAASUVORK5CYII="
            )
        )
        
        XCTAssertNotNil(image)
        XCTAssertNotEqual(image, Image(systemName: ""))
    }
    
    func testDownloadImageFail() async throws {
        
        let sut = withDependencies { _ in
        } operation: {
            DownloadImageUseCaseClient.liveValue
        }
        
        let image = try sut.downloadImage(
            DownloadImageUseCaseClient.Input(
                imageString: ""
            )
        )
        
        XCTAssertNotNil(image)
        XCTAssertEqual(image, Image(systemName: ""))
    }
}
