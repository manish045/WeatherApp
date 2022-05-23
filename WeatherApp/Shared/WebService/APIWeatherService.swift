//
//  APIService.swift
//  WeatherApp
//
//  Created by Manish Tamta on 23/05/2022.
//

import Foundation
import Alamofire
import UIKit

enum APIResult<T, APIError> {
    case success(T)
    case error(APIError)
}

protocol PerformRequest {
    func performRequest<T: BaseModel>(endPoint: EndPoints,
                                      parameters: [String : Any],
                                      completion: @escaping (APIResult<T, APIError>) -> Void)
}

class APIWeatherService: SessionManager, PerformRequest {
    
    static let shared = APIWeatherService()
    var network: Network

    init(network: Network = Network()) {
        self.network = network
        super.init()
        session.configuration.httpAdditionalHeaders?.updateValue(["application/json", "text/html", "image/png", "image/jpeg"], forKey: "Content-Type")
    }
    
    struct ErrorObject: Decodable {
        let message: String
    }
    
    fileprivate func validateAF<T: BaseModel>(response: DataResponse<T>) -> (successModel: T?, error: APIError?) {
        
        switch response.result {
        case .success(let parsedModel):
            return (parsedModel, nil)
        case .failure(let error):
            print(error)
            // incase of logout we will check only status code
            if let data = response.data {
                do {
                    let json = try JSONDecoder().decode(ErrorObject.self, from: data)
                    return (nil, .serverError(json.message))
                } catch {
                    return (nil, .parsingFailed)
                }
            }
            return (nil, .serverError(error.localizedDescription))
        }
    }
    
    func performRequest<T: BaseModel>(endPoint: EndPoints,
                                      parameters: [String : Any],
                                      completion: @escaping (APIResult<T, APIError>) -> Void) {
        guard isNetwork() else {
            completion(.error(APIError.noNetwork))
            return
        }
        
        let url = APIWeatherService.URL(endPoint)
        guard let finalUrl = MSUtils.buildServiceRequestUrl(baseUrl: url) else{
            return
        }
        request(finalUrl,method: endPoint.httpMethod, parameters: parameters).validate().debugLog().responseDecodable { [weak self] (response: DataResponse<T>) in
            let parsedResponse = self?.validateAF(response: response)
            guard let object = parsedResponse?.successModel else {
                completion(.error(parsedResponse?.error ?? .parsingFailed))
                return
            }
            completion(.success(object))
        }
    }
}

extension Request {
    public func debugLog() -> Self {
        #if DEBUG
        debugPrint(self)
        #endif
        return self
    }
}


