//
//  LoginViewModel.swift
//  Ficek_Cleverlance
//
//  Created by Martin Ficek on 17.02.2023.
//

import Foundation
import Combine
import SwiftUI

protocol LoginViewModelType: ObservableObject {
    var login: String { get set }
    var password: String { get set }
    var isLogged: Bool { get set }
    var wrongData: String { get set }
    var imageString: String { get set }
    var progressViewOpacity: Double { get set }
    
    func loginButtonDidTapped()
}

final class LoginViewModel: LoginViewModelType {
    @Published var login: String
    @Published var password: String
    @Published var isLogged: Bool
    @Published var wrongData: String = ""
    @Published var imageString: String
    @Published var progressViewOpacity: Double
    let imageRepository: ImageRepositoryType
    private var cancellables = Set<AnyCancellable>()
    
    init(isLogged: Bool = false, login: String = "", password: String = "", imageRepository: ImageRepositoryType, imageString: String = "", progressViewOpacity: Double = 0) {
        self.isLogged = isLogged
        self.login = login
        self.password = password
        self.imageRepository = imageRepository
        self.imageString = imageString
        self.progressViewOpacity = progressViewOpacity
        
    }
    
    func loginButtonDidTapped() {
        progressViewOpacity = 100
        imageRepository.fetchImage(username: login, password: password)
            .receive(on: DispatchQueue.main)
            .sink(
                receiveCompletion: { [weak self] completion in
                    guard let self = self else { return }
                    switch completion {
                    case .finished:
                        self.isLogged = true
                        self.wrongData = ""
                        self.progressViewOpacity = 0
                        
                    case .failure:
                        self.isLogged = false
                        self.wrongData = "Wrong username or password"
                        self.progressViewOpacity = 0
                    }
                },
                receiveValue: { [weak self] image in
                    guard let self = self else { return }
                    self.imageString = image.image
                }
            )
            .store(in: &cancellables)
    }
}

extension LoginViewModelType where Self == LoginViewModel {
    static var live: Self { Self(imageRepository: .live) }
}

