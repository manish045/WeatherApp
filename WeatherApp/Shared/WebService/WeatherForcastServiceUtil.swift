//
//  WeatherForcastServiceUtil.swift
//  WeatherApp
//
//  Created by Manish Tamta on 23/05/2022.
//

import Foundation
import CryptoKit


enum KeyString: String {
    case testingKey
}

class MSUtils {
    
    static func buildServiceRequestUrl (baseUrl: String, params: [String : String]? = nil) -> String? {
        if var urlComponents = URLComponents(string: baseUrl) {
            
            guard let testingKey = getAPIKeys()[KeyString.testingKey.rawValue] as? String else {return nil}
            
            
            //addd auth params
            var requestParams = params ?? [String : String]()
            requestParams["key"] = testingKey
            
            //build query string
            var queryItems = [URLQueryItem]()
            for (key, value) in requestParams {
                queryItems.append(URLQueryItem(name: key, value: value))
            }
            
            urlComponents.queryItems = queryItems
            
            if let urlAbsoluteString = urlComponents.url?.absoluteString {
                return urlAbsoluteString
            }
        }
        
        return nil
    }

    //MARK:- Get Keys from WeatherForcast Plist file
    static func getAPIKeys() -> [String: Any] {
        if let path = Bundle.main.path(forResource: "WeatherInfo", ofType: "plist") {
            let plist = NSDictionary(contentsOfFile: path) ?? ["":""]
            let testingKey = plist[KeyString.testingKey.rawValue] as! String
            let dict = [KeyString.testingKey.rawValue: testingKey]
            return dict
            
        }
        return ["": ""]
    }
    
    /*
     There are two steps:
     1. Create md5 data from a string
     2. Covert the md5 data to a hex string
     */
    static func MD5Hex(string: String) -> String {
        let digest = Insecure.MD5.hash(data: string.data(using: .utf8) ?? Data())
        return digest.map {
                String(format: "%02hhx", $0)
            }.joined()
    }
    
    static func get(url: String, onResult: @escaping (Data?) -> Void){
        guard let url = URL(string: url) else{
            onResult(nil)
            return
        }

        let task = URLSession.shared.dataTask(with: url) {(data, response, error) in
            if let response = data {
                onResult(response)
                
            }else{
                onResult(nil)
            }
        }
        task.resume()
    }
    
}
