//
//  MockedLoginViewModel.swift
//  Ficek_Cleverlance
//
//  Created by Martin Ficek on 19.02.2023.
//

//import Foundation
//
//final class MockedLoginViewModel: LoginViewModelType {
//    @Published var progressViewOpacity: Double = 0
//    @Published var login: String = ""
//    @Published var password: String = ""
//    @Published var isLogged: Bool = false
//    @Published var wrongData: String = ""
//    @Published var imageString: String = ""
//    let imageRepository: ImageRepositoryType
//    
//    init(imageRepository: ImageRepositoryType) {
//        self.imageRepository = imageRepository
//    }
//    
//    func loginButtonDidTapped() {
//        progressViewOpacity = 100
//        if login.lowercased() == "login" && password.lowercased() == "password" {
//            isLogged = true
//            wrongData = ""
//            imageString = "iVBORw0KGgoAAAANSUhEUgAAAAEAAAABCAQAAAC1HAwCAAAAC0lEQVR42mNk+A8AAQUBAScY42YAAAAASUVORK5CYII="
//            progressViewOpacity = 0
//        }
//        else {
//            wrongData = "Wrong username or password"
//            progressViewOpacity = 0
//        }
//    }
//}
//
//extension LoginViewModelType where Self == MockedLoginViewModel {
//    static var mock: Self { Self(imageRepository: .live) }
//}
