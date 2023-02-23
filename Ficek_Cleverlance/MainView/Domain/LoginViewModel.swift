//
//  LoginViewModel.swift
//  Ficek_Cleverlance
//
//  Created by Martin Ficek on 17.02.2023.
//

import Foundation
import SwiftUI
import Dependencies

@MainActor
final class LoginViewModel: ObservableObject {
    @Dependency(\.fetchImageUseCaseClient) var fetchImageUseCaseClient
    
    @Published var username: String
    @Published var password: String
    @Published var isLogged: Bool
    @Published var wrongData: String = ""
    @Published var imageString: String
    @Published var progressViewOpacity: Double
    
    init(
        isLogged: Bool = false,
        username: String = "",
        password: String = "",
        imageString: String = "",
        progressViewOpacity: Double = 0
    ) {
        self.isLogged = isLogged
        self.username = username
        self.password = password
        self.imageString = imageString
        self.progressViewOpacity = progressViewOpacity
    }
    
    var isSendingDisabled: Bool { username.isEmpty || password.isEmpty }
    
    var buttonColor: Color { isSendingDisabled ? .gray : .green }
    
    func loginButtonDidTapped() async {
        do {
            self.progressViewOpacity = 1
            let imageResponse = try await fetchImageUseCaseClient.fetchImage(
                FetchImageUseCaseClient.Input(
                    username: self.username,
                    password: self.password)
            )
            
            self.isLogged = true
            self.wrongData = ""
            self.progressViewOpacity = 0
            self.imageString = imageResponse.image
        }
        catch {
            self.isLogged = false
            self.wrongData = "Wrong username or password"
            self.progressViewOpacity = 0
        }
    }
}
