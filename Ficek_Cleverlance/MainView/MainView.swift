//
//  MainView.swift
//  Ficek_Cleverlance
//
//  Created by Martin Ficek on 18.02.2023.
//

import SwiftUI

struct MainView: View {
    
    var body: some View {
        LoginView(viewModel: LoginViewModel())
    }
}

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView()
    }
}
