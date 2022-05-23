//
//  BaseModel.swift
//  WeatherApp
//
//  Created by Manish Tamta on 23/05/2022.
//


import Foundation

protocol BaseModel: Codable {
    
    typealias JSON = [String : Any]
    
    init?(json: JSON)
    init?(data: Data)
    init?(_ json: String, using encoding: String.Encoding)
    init?(fromURL url: String)
    init?(fromURL url: URL)
    
    func jsonData() throws -> Data
    func toDictionary() -> JSON?
    func jsonString(encoding: String.Encoding) throws -> String?
}

extension BaseModel {
    
    init?(json: JSON) {
        do {
            let data = try JSONSerialization.data(withJSONObject: json, options: [])
            let object = try JSONDecoder().decode(Self.self, from: data)
            self = object
        } catch  {
            return nil
        }
    }
    
    init?(data: Data) {
        guard let object = try? newJSONDecoder().decode(Self.self, from: data) else { return nil }
        self = object
    }
    
    init?(_ json: String, using encoding: String.Encoding = .utf8) {
        guard let data = json.data(using: encoding) else { return nil }
        self.init(data: data)
    }
    
    init?(fromURL url: String) {
        guard let url = URL(string: url) else { return nil }
        guard let data = try? Data(contentsOf: url) else { return nil }
        self.init(data: data)
    }
    
    init?(fromURL url: URL) {
        guard let data = try? Data(contentsOf: url) else { return nil }
        self.init(data: data)
    }
    
    // MARK: toDictionary
    /// Can use this for send model with post : Parameters is a Dictionary so `parameters: model.toDictionary()?`
    func toDictionary() -> JSON? {
        // Encode the data
        if let jsonData = try? JSONEncoder().encode(self),
            // Create a dictionary from the data
            let dict = try? JSONSerialization.jsonObject(with: jsonData, options: []) as? JSON {
            return dict
        }
        return nil
    }

    func jsonData() throws -> Data {
        return try newJSONEncoder().encode(self)
    }

    func jsonString(encoding: String.Encoding = .utf8) throws -> String? {
        return String(data: try self.jsonData(), encoding: encoding)
    }
}
