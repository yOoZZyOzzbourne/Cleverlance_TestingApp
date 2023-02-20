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
        ZStack {
            VStack {
                Group {
                    TextField("Type your login", text: $viewModel.username)
                        .autocorrectionDisabled()
                    SecureInputView("Type your password",text: $viewModel.password)
                }
                .shadow(radius: 1)
                .textFieldStyle(.roundedBorder)
                
                Text(viewModel.wrongData)
                
                Button(
                    action: {
                        viewModel.loginButtonDidTappedAsync()
                    },
                    label: {
                        Text("Login")
                            .foregroundColor(.white)
                            .padding(10)
                            .background(Color.green)
                            .cornerRadius(10)
                            .shadow(color: .primary.opacity(0.2), radius: 10, x: 0, y: 10)
                    }
                )
                .padding(.bottom, 20)
                
                
            }
            .sheet(isPresented: $viewModel.isLogged) {
                NavigationStack {
                    ImageShowView(viewModel: ImageShowViewModel(imageString: viewModel.imageString, downloadImageUseCase: .live))
                }
            }
            .padding()
            
            ProgressView()
                .opacity(viewModel.progressViewOpacity)
                .scaleEffect(2)
        }
    }
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView(viewModel: LoginViewModel(fetchImageUseCase: .mock))
    }
}
