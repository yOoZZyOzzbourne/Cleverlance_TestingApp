//
//  ApiResponse.swift
//  Ficek_Cleverlance
//
//  Created by Martin Ficek on 18.02.2023.
//

import Foundation

struct ApiResponse: Equatable, Decodable {
    let image: String
}

enum ResponseError: Error {
    case internalError
    case unauthorized
    case badUrl
}
