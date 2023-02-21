//
//  LoginViewModel.swift
//  Ficek_Cleverlance
//
//  Created by Martin Ficek on 17.02.2023.
//

import Foundation
import Combine
import SwiftUI
import Dependencies

protocol LoginViewModelType: ObservableObject {
    var username: String { get set }
    var password: String { get set }
    var isLogged: Bool { get set }
    var wrongData: String { get set }
    var imageString: String { get set }
    var progressViewOpacity: Double { get set }
    
    func loginButtonDidTappedAsync()
}

final class LoginViewModel: LoginViewModelType {
    @Dependency(\.fetchImageUseCaseClient) var fetchImageUseCaseClient
    
    @Published var username: String
    @Published var password: String
    @Published var isLogged: Bool
    @Published var wrongData: String = ""
    @Published var imageString: String
    @Published var progressViewOpacity: Double
    private var cancellables = Set<AnyCancellable>()
    
    init(isLogged: Bool = false, username: String = "", password: String = "", imageString: String = "", progressViewOpacity: Double = 0) {
        self.isLogged = isLogged
        self.username = username
        self.password = password
        self.imageString = imageString
        self.progressViewOpacity = progressViewOpacity
    }
    
    func loginButtonDidTappedAsync() {
        progressViewOpacity = 100
        Task {
            @MainActor in
            
            do {
                let imageResponse = try await fetchImageUseCaseClient.fetchImage(FetchImageUseCaseClient.Input(username: self.username, password: self.password))
                
                self.isLogged = true
                self.wrongData = ""
                self.progressViewOpacity = 0
                self.imageString = imageResponse.image
            }
            catch {
                self.isLogged = false
                self.wrongData = "Wrong username or password"
                self.progressViewOpacity = 0
                print("Request failed")
            }
        }
    }
}

extension LoginViewModelType where Self == LoginViewModel {
    static var live: Self { Self() }
}

