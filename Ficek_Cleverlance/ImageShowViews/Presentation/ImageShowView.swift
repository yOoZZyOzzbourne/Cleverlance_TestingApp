//
//  ImageShowView.swift
//  Ficek_Cleverlance
//
//  Created by Martin Ficek on 18.02.2023.
//

import SwiftUI

struct ImageShowView<vm: ImageShowViewModelType>: View {
    @ObservedObject var viewModel: vm
    
    var body: some View {
        VStack {
            viewModel.imageBase64
                .resizable()
                .scaledToFit()
                .padding(.top, 50)
            
            Spacer()
            
            Button(
                action: {
                    viewModel.downloadButtonTapped()
                },
                label: {
                    Text("Download Image")
                        .foregroundColor(.white)
                        .padding(10)
                        .background(Color.teal)
                        .cornerRadius(10)
                        .shadow(color: .black.opacity(0.2), radius: 10, x: 0, y: 10)
                }
            )
            .padding(.bottom, 20)
        }
    }
}

struct ImageShowView_Previews: PreviewProvider {
    static var previews: some View {
        ImageShowView(viewModel: ImageShowViewModel(downloadImageUseCase: .mock))
    }
}


