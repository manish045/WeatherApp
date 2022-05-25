//
//  WeatherForcastAPIServiceTest.swift
//  WeatherAppTests
//
//  Created by Manish Tamta on 25/05/2022.
//

import XCTest
import Alamofire
@testable import WeatherApp

class WeatherForcastAPIServiceTest: XCTestCase {
    
    var util: MSUtils!
    var apiService: WeatherAPIRepository!
    var viewModel: DefaultWeatherForcastViewModel!
    
    override func setUp() {
        util = MSUtils()
        apiService = APIMockTest()
        
        let coordinator = WeatherForcastCoordinator()
        viewModel = DefaultWeatherForcastViewModel(coordinator: coordinator)
    }
    
    //MARK:- Test the get WeatherForcastSection request with passing empty key params.
    func testKeyIsPresentInPlistORturnsError() {
        
        let getAPIKeys = MSUtils.getAPIKeys()
        
        let testingKey = getAPIKeys[KeyString.testingKey.rawValue]        
        XCTAssertNotNil(testingKey)
    }
    
    //MARK:- Test the get WeatherForcastSection request passing key params.
    func testCharacterListApiResourceWithEmptyStringRturnsError() {
       
        let url = APIWeatherForcastService.URL(.dailyForecast)
        let baseURL = MSUtils.buildServiceRequestUrl(baseUrl: url)
        XCTAssertNotNil(baseURL?.isEmpty)
    }
    
    
    //MARK:- Test the get WeatherForcastSection requeset
    func testCharacterListApiResourceWithParametersReturnsError() {
                
        let expectation = self.expectation(description: "testAPICall")
        let params = viewModel.createParametersToFetchForcast(latitude: 37.7873589, longitude: -122.408227)
        apiService.fetchDetails(endPoint: .dailyForecast, parameters: params) { (result: APIResult<WeatherDataModel, APIError>) in
            switch result {
            case .success(let model):
                XCTAssertNotNil(model)
                expectation.fulfill()
            default:
                break
            }
        }
        waitForExpectations(timeout: 5, handler: nil)
    }
    
    //MARK:- Test the get WeatherForcastSection request with passing empty params.
    func testCharacterListApiResourceWithEmptyParamsRturnsError() {
      
        let expectation = self.expectation(description: "PassingEmptyKeyParams")

        apiService.fetchDetails(endPoint: .dailyForecast, parameters: [:]) { (result: APIResult<WeatherDataModel, APIError>) in
            switch result {
            case .error(let error):
                XCTAssertNotNil(error)
                expectation.fulfill()
            default:
                break
            }
        }
        waitForExpectations(timeout: 5, handler: nil)
    }
    
    override func tearDown() {
        util = nil
        apiService = nil
        viewModel = nil
    }
}

class APIMockTest: SessionManager, WeatherAPIRepository {
    func fetchDetails(endPoint: EndPoints, parameters: [String : Any], completion: @escaping (APIResult<WeatherDataModel, APIError>) -> Void) {
        
        APIWeatherForcastService.shared.performRequest(endPoint: endPoint, parameters: parameters) { (result: APIResult<WeatherDataModel, APIError>) in
            switch result {
            case .error(let error):
                completion(.error(error))
            case .success(let model):
                completion(.success(model))
            }
        }
    }
}
