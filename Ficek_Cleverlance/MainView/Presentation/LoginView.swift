//
//  LoginView.swift
//  Ficek_Cleverlance
//
//  Created by Martin Ficek on 17.02.2023.
//

import SwiftUI

struct LoginView<vm: LoginViewModelType>: View {
    @ObservedObject var viewModel: vm
    
    var body: some View {
        VStack {
            Group {
                TextField("Zadejte jméno", text: $viewModel.login)
                    .autocorrectionDisabled()
                SecureInputView("Zadejte heslo",text: $viewModel.password)
            }
            .textFieldStyle(.roundedBorder)
            
            Text(viewModel.wrongData)
            
            Button(
                action: {
                    viewModel.loginButtonDidTapped()
                },
                label: {
                    Text("Login")
                        .foregroundColor(.white)
                        .padding(10)
                        .background(Color.teal)
                        .cornerRadius(10)
                        .shadow(color: .black.opacity(0.2), radius: 10, x: 0, y: 10)
                }
            )
            .padding(.bottom, 20)
            
            ProgressView()
                .opacity(viewModel.progressViewOpacity)
                .scaleEffect(2)
        }
        .sheet(isPresented: $viewModel.isLogged) {
            NavigationStack {
                ImageShowView(viewModel: ImageShowViewModel(imageString: viewModel.imageString, downloadImageUseCase: .live))
            }
        }
        .padding()
    }
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView(viewModel: LoginViewModel(fetchImageUseCase: .mock))
    }
}
