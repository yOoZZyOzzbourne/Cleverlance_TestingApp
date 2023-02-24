//
//  ImageShowView.swift
//  Ficek_Cleverlance
//
//  Created by Martin Ficek on 18.02.2023.
//

import SwiftUI

struct ImageShowView: View {
    @ObservedObject var viewModel: ImageShowViewModel
    
    var body: some View {
        ZStack {
            LinearGradient(
                gradient: Gradient(colors: [.orange, .gray , .black]),
                startPoint: .top,
                endPoint: .bottom
            )
            .ignoresSafeArea()
            
            VStack {
                Text("Image preview")
                    .font(.largeTitle)
                    .padding(.top,60)
                
                Spacer()
                
                viewModel.imageBase64
                    .resizable()
                    .scaledToFit()
                    .shadow(color: .secondary.opacity(0.2), radius: 5)
                    .padding()
                
                Spacer()
                
                Button(
                    action: {
                        Task {
                            await viewModel.downloadButtonTapped()
                        }
                    },
                    label: {
                        Text("Download Image")
                            .foregroundColor(.white)
                            .padding(10)
                            .background(Color.green)
                            .cornerRadius(10)
                            .shadow(color: .black.opacity(0.2), radius: 10, x: 0, y: 10)
                    }
                )
                .padding(.bottom, 20)
            }
        }
    }
}

struct ImageShowView_Previews: PreviewProvider {
    static var previews: some View {
        ImageShowView(viewModel: ImageShowViewModel())
    }
}


