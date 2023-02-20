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
    var username: String { get set }
    var password: String { get set }
    var isLogged: Bool { get set }
    var wrongData: String { get set }
    var imageString: String { get set }
    var progressViewOpacity: Double { get set }
    
    func loginButtonDidTappedCombine()
    func loginButtonDidTappedAsync()
}

final class LoginViewModel: LoginViewModelType {
    @Published var username: String
    @Published var password: String
    @Published var isLogged: Bool
    @Published var wrongData: String = ""
    @Published var imageString: String
    @Published var progressViewOpacity: Double
    let fetchImageUseCase: FetchImageUseCaseType
    private var cancellables = Set<AnyCancellable>()
    
    init(isLogged: Bool = false, username: String = "", password: String = "", imageString: String = "", progressViewOpacity: Double = 0, fetchImageUseCase: FetchImageUseCaseType) {
        self.isLogged = isLogged
        self.username = username
        self.password = password
        self.imageString = imageString
        self.progressViewOpacity = progressViewOpacity
        self.fetchImageUseCase = fetchImageUseCase
        
    }
    
    func loginButtonDidTappedCombine() {
        progressViewOpacity = 100
        fetchImageUseCase.fetchImageCombine(username: username, password: password)
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
    
    func loginButtonDidTappedAsync() {
        progressViewOpacity = 100
        Task {
            @MainActor in
            
            do {
                let imageResponse = try await fetchImageUseCase.fetchImageAsync(username: username, password: password)
                
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
    static var live: Self { Self(fetchImageUseCase: .live) }
}

