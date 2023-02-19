//
//  ApiResponse.swift
//  Ficek_Cleverlance
//
//  Created by Martin Ficek on 18.02.2023.
//

import Foundation

struct ApiResponse: Decodable {
    let image: String
}

enum ResponseError: Error {
    case inetrnalError
    case unauthorized
    case badUrl
}
