//
//  LoginView.swift
//  Ficek_Cleverlance
//
//  Created by Martin Ficek on 17.02.2023.
//

import SwiftUI

struct LoginView: View {
    @ObservedObject var viewModel: LoginViewModel

    var body: some View {
        ZStack {
            LinearGradient(
                gradient: Gradient(colors: [.orange, .gray , .black ]),
                startPoint: .top,
                endPoint: .bottom
            )
            .ignoresSafeArea()
            
            VStack {
                Group {
                    TextField("Type your login", text: $viewModel.username)
                        .autocorrectionDisabled()
                        
                    SecureInputView("Type your password",text: $viewModel.password)
                }
                .shadow(radius: 1)
                .textFieldStyle(.roundedBorder)
                .background(RoundedRectangle(cornerRadius: 5)
                    .foregroundColor(Color("BlackAndWhite")))
                
                Text(viewModel.wrongData)
                
                Button(
                    action: {
                        Task {
                           await  viewModel.loginButtonDidTapped()
                        }
                    },
                    label: {
                        Text("Login")
                            .foregroundColor(.white)
                            .padding(10)
                            .background(viewModel.buttonColor)
                            .cornerRadius(10)
                            .shadow(color: .primary.opacity(0.2), radius: 10, x: 0, y: 10)
                    }
                )
                .padding(.bottom, 20)
                .disabled(
                    viewModel.isSendingDisabled
                )
                
                
            }
            .sheet(isPresented: $viewModel.isLogged) {
                NavigationStack {
                    ImageShowView(viewModel: ImageShowViewModel(imageString: viewModel.imageString))
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
        LoginView(viewModel: LoginViewModel())
    }
}
