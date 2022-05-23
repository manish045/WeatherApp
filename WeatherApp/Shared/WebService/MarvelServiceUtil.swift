//
//  MarvelServiceUtil.swift
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
            //addd auth params
                        
            guard let testingKey = getAPIKeys()[KeyString.testingKey.rawValue] as? String else {return nil}
            
            var requestParams = params ?? [String : String]()
            requestParams["apikey"] = testingKey
            
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

    //MARK:- Get Keys from Marvel Plist file
    static func getAPIKeys() -> [String: Any] {
        if let path = Bundle.main.path(forResource: "WeatherInfo", ofType: "plist") {
            let plist = NSDictionary(contentsOfFile: path) ?? ["":""]
            let testingKey = plist[KeyString.testingKey.rawValue] as! String
            let dict = [KeyString.testingKey.rawValue: testingKey]
            return dict
            
        }
        return ["": ""]
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
