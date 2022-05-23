//
//  APIService+URL.swift
//  WeatherApp
//
//  Created by Manish Tamta on 23/05/2022.
//

import Foundation
import Alamofire

enum APIEnvironment {
    case staging
    case development
    case production
    
    var baseURL: String {
        switch self {
        case .staging:
            return "https://api.weatherbit.io/v2.0/"
        case .development:
            return "https://api.weatherbit.io/v2.0/"
        case .production:
            return "https://api.weatherbit.io/v2.0/"
        }
    }
}

enum EndPoints {
    case dailyForecast
    
    var url: String {
        switch self {
        case .dailyForecast:
            return "forecast/daily"
        }
    }
    
    var httpMethod: HTTPMethod {
        switch self {
        default:
            return .get
        }
    }
}

extension APIWeatherForcastService {
    struct URLString {
        private static let environment = APIEnvironment.staging
        static var base: String { environment.baseURL }
    }
    
    static func URL(_ endPoint: EndPoints) -> String {
        return URLString.base + endPoint.url
    }
}

