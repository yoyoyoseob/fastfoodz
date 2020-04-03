//
//  NetworkService.swift
//  Fast Foodz
//
//  Created by Yoseob Lee on 4/1/20.
//

import Alamofire
import Foundation
import RxAlamofire
import RxSwift

typealias TypedAPIResult<Model> = Swift.Result<Model, APIError>
typealias ObservableTypedAPIResult<Model> = Observable<TypedAPIResult<Model>>

protocol NetworkService {
    func makeRequest<ResponseType: Decodable>(method: HTTPMethod,
                                              url: URL,
                                              params: [String: Any]?,
                                              encoding: ParameterEncoding,
                                              forType type: ResponseType.Type) -> ObservableTypedAPIResult<ResponseType>
}

extension NetworkService {
    func makeRequest<ResponseType: Decodable>(method: HTTPMethod,
                                              url: URL,
                                              params: [String: Any]?,
                                              encoding: ParameterEncoding,
                                              forType type: ResponseType.Type) -> ObservableTypedAPIResult<ResponseType> {
        let headers = ["Authorization": "Bearer " + yelpAPIKey]

        return SessionManager.default.rx
            .request(method,
                     url,
                     parameters: params,
                     encoding: encoding,
                     headers: headers)
            .validate(statusCode: 200...300)
            .responseData()
            .observeOn(ConcurrentDispatchQueueScheduler(qos: .userInitiated))
            .decode(type.self)
            .observeOn(MainScheduler.instance)
    }
}
