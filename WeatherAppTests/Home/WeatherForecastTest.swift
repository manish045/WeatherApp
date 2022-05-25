//
//  WeatherForecastTest.swift
//  WeatherAppUITests
//
//  Created by Manish Tamta on 25/05/2022.
//

import XCTest
import Combine
@testable import WeatherApp

class WeatherForecastTest: XCTestCase {
    
    private var weatherDataModel: WeatherDataModel!
    private var cancellables: Set<AnyCancellable>!
    
    override func setUp() {
        guard let pathString = Bundle(for: type(of: self)).path(forResource: "WeatherdataSample", ofType: "json") else {
            fatalError("json not found")
        }
        
        guard let json = try? String(contentsOfFile: pathString, encoding: .utf8) else {
            fatalError("unable to convert json into string")
        }
        
        let jsonData = json.data(using: .utf8)!
        weatherDataModel = try! JSONDecoder().decode(WeatherDataModel.self, from: jsonData)
        cancellables = []
    }
    
    override func tearDown() {
        weatherDataModel = nil
        cancellables = nil
    }
    
    //MARK:- Test the datasource before request to server
    func testEmptyValueInDataSourceWhenLoadingDataFromServer() throws {
        
        let sut = try makeSUT()
        let collectionView = sut.collectionView
        // expected one section
        XCTAssertEqual(collectionView?.numberOfSections, 2, "Expected two section in collection view")
        
        // expected zero cells
        XCTAssertEqual(collectionView?.numberOfItems(inSection: WeatherForcastSection.weatherForecast.rawValue), 0)
        
        // expected one cells
        XCTAssertEqual(collectionView?.numberOfItems(inSection: WeatherForcastSection.loader.rawValue), 1)
    }
    
    //MARK:- Test the datasource after successful request from server with Zero Data
    func testEmptyValueInDataSourceWhenFinishLoadingWithZerorResultFromServer() throws {
        
        let sut = try makeSUT()
        let collectionView = sut.collectionView
        
        sut.createSnapshot(weatherList: [], state: .completed)
        // expected one section
        XCTAssertEqual(collectionView?.numberOfSections, 1, "Expected one section in collection view")
        
        // expected zero cells
        XCTAssertEqual(collectionView?.numberOfItems(inSection: WeatherForcastSection.weatherForecast.rawValue), 0)
    }
    
    //MARK:- Test the datasource after failed request from server
    func testEmptyValueInDataSourceWhenFailedLoadingFromServer() throws {
        
        let sut = try makeSUT()
        let collectionView = sut.collectionView
        
        sut.createSnapshot(weatherList: [], state: .failed)

        // expected one section
        XCTAssertEqual(collectionView?.numberOfSections, 1, "Expected one section in collection view")
        
        // expected zero cells
        XCTAssertEqual(collectionView?.numberOfItems(inSection: WeatherForcastSection.weatherForecast.rawValue), 0)
    }
    
    //MARK:- Test the datasource after loading request from server with some Data
    func testSomeValueInDataSourceWhenLoadingMoreDataFromServer() throws {

        let sut = try makeSUT()
        let collectionView = sut.collectionView
        // expected one section
        
        let weatherList: WeatherForecastList = weatherDataModel.data!
        sut.createSnapshot(weatherList: weatherList, state: .completed)
        XCTAssertEqual(collectionView?.numberOfSections, 1, "Expected two section in collection view")

        // expected zero cells
        XCTAssertEqual(collectionView?.numberOfItems(inSection: WeatherForcastSection.weatherForecast.rawValue), 1)
    }
    
    func testObservers() throws {
        let sut = try makeSUT()
        
        let viewModel = sut.viewModel!
        
        let expectation = XCTestExpectation(description: "feedRecieved")
        let errorExpectation = XCTestExpectation(description: "Error Occured")
        let tempUnitExpectation = XCTestExpectation(description: "Unit is changed")
        
        viewModel.loadDataSource
            .sink (receiveValue: { value in
                XCTAssertEqual(value.count, 0)
                expectation.fulfill()
            })
            .store(in: &cancellables)
        
        viewModel.didGetError
            .sink { _ in
                errorExpectation.fulfill()
            }
            .store(in: &cancellables)
        
        TemperatureUnitManager.shared.changeInTempUnit
            .sink (receiveValue: { value in
                XCTAssertNotNil(value)
                tempUnitExpectation.fulfill()
            })
            .store(in: &cancellables)
    }
    
    private func makeSUT() throws -> WeatherForcastViewController  {
        let coordinator = WeatherForcastCoordinator()
        let sut = try XCTUnwrap(coordinator.makeModule() as? WeatherForcastViewController)
        let viewModel = DefaultWeatherForcastViewModel(coordinator: coordinator)
        sut.viewModel = viewModel
        _ = sut.view
        return sut
    }

}

class MockTestServiceAPI: WeatherAPIRepository {
    func fetchDetails(endPoint: EndPoints, parameters: [String : Any], completion: @escaping (APIResult<WeatherDataModel, APIError>) -> Void) {
        APIWeatherForcastService.shared.performRequest(endPoint: endPoint, parameters: parameters) { (result: APIResult<WeatherDataModel, APIError>) in
            switch result {
            case .success(let model):
                completion(.success(model))
            case .error(let apiError):
                completion(.error(apiError))
            }
        }
    }
}
