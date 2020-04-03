//
//  Observable+ResponseData.swift
//  Fast Foodz
//
//  Created by Yoseob Lee on 4/1/20.
//

import Foundation
import RxSwift

extension Observable where Element == (HTTPURLResponse, Data) {
    /// On successful response (status code falls within acceptable range) attempts to decode the data into the specified 'Model' type.
    ///
    /// - Parameter type: Object conforming to the 'Decodable' protocol.
    /// - Returns: ObservableTypedAPIResult<Model>
    func decode<Model: Decodable>(_ type: Model.Type) -> ObservableTypedAPIResult<Model> {
        return map { (response, data) -> TypedAPIResult<Model> in
            switch response.statusCode {
            case 200...300:
                do {
                    let model = try JSONDecoder().decode(type, from: data)
                    return .success(model)
                } catch {
                    return .failure(.error(.init(internalError: error,
                                                 statusCode: response.statusCode,
                                                 payloadData: data)))
                }
            default:
                return .failure(.generic)
            }
        }
    }
}
