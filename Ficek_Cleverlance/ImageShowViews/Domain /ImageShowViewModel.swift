//
//  ImageShowViewModel.swift
//  Ficek_Cleverlance
//
//  Created by Martin Ficek on 18.02.2023.
//

import Foundation
import Combine
import SwiftUI

protocol ImageShowViewModelType: ObservableObject {
    var imageString: String { get set }
    var imageBase64: Image { get set}
    
    func downloadButtonTapped()
}

final class ImageShowViewModel: ImageShowViewModelType {
    
    var imageString: String
    @Published var imageBase64: Image
    
    init(imageString: String = "", imageBase64: Image = Image(systemName: "sun.fill")) {
        self.imageString = imageString
        self.imageBase64 = imageBase64
    }
    
    func downloadButtonTapped() {
        guard let stringData = Data(base64Encoded: imageString),
              let uiImage = UIImage(data: stringData) else {
            print("Error: couldn't create UIImage")
            return }
        
        imageBase64 = Image(uiImage: uiImage)
    }
}

extension ImageShowViewModelType where Self == ImageShowViewModel {
    static var live: Self { Self() }
}
