//
//  MockedImageShowViewModel.swift
//  Ficek_Cleverlance
//
//  Created by Martin Ficek on 19.02.2023.
//

//import Foundation
//import SwiftUI
//
//final class MockedImageShowViewModel: ImageShowViewModelType {
//    
//    var imageString: String
//    @Published var imageBase64: Image
//    
//    init(imageString: String = "iVBORw0KGgoAAAANSUhEUgAAAAEAAAABCAQAAAC1HAwCAAAAC0lEQVR42mNk+A8AAQUBAScY42YAAAAASUVORK5CYII=",
//         imageBase64: Image = Image(systemName: "sun.fill")) {
//        self.imageString = imageString
//        self.imageBase64 = imageBase64
//    }
//    
//    func downloadButtonTapped() {
//        guard let stringData = Data(base64Encoded: imageString),
//              let uiImage = UIImage(data: stringData) else {
//            print("Error: couldn't create UIImage")
//            return }
//        
//        imageBase64 = Image(uiImage: uiImage)
//    }
//}
//
//extension ImageShowViewModelType where Self == MockedImageShowViewModel {
//    static var mock: Self { Self() }
//}
