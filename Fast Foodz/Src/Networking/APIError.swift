//
//  APIError.swift
//  Fast Foodz
//
//  Created by Yoseob Lee on 4/1/20.
//

import Foundation

enum APIError: LocalizedError {
    case generic
    case error(APIErrorData)
}

struct APIErrorData: LocalizedError {
    let internalError: Error
    let statusCode: Int
    let payloadData: Data?

    init(internalError: Error, statusCode: Int, payloadData: Data? = nil) {
        self.internalError = internalError
        self.statusCode = statusCode
        self.payloadData = payloadData
    }

    var errorDescription: String? {
        let payloadStr: String
        if let payloadData = payloadData, let dataStr = String(data: payloadData, encoding: .utf8) {
            payloadStr = dataStr
        } else {
            payloadStr = "\(String(describing: payloadData))"
        }

        return "APIError: internal:\(internalError) statusCode:\(statusCode) payloadData:\(payloadStr)"
    }
}
