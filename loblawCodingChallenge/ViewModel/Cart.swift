//
//  Cart.swift
//  loblawCodingChallenge
//
//  Created by tommytexter on 2021-02-06.
//

import Foundation
enum CartRequestError: Error, Equatable {
    case requestTimedOut
    case jsonSerializationError
    case apiError
    case invalidResponseError
    case unsuccessfulStatusCodeError(statusCode: Int)
}

struct Product: Codable {
    let code: String? //In documentation, this field is called id, but in the actual JSON you sent me in the email, this field is called code. Therefore I used code here.
    let name: String
    let image: String
    let price: String
    let type: String
}

struct Cart: Codable {
    var entries: [Product] = []
}
