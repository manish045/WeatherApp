//
//  WeatherDetailXCTest.swift
//  WeatherAppTests
//
//  Created by Manish Tamta on 25/05/2022.
//

import XCTest
@testable import WeatherApp

class WeatherDetailXCTest: XCTestCase {
    
    private var weatherDataModel: WeatherDataModel!
    
    override func setUp() {
        guard let pathString = Bundle(for: type(of: self)).path(forResource: "WeatherdataSample", ofType: "json") else {
            fatalError("json not found")
        }
        
        guard let json = try? String(contentsOfFile: pathString, encoding: .utf8) else {
            fatalError("unable to convert json into string")
        }
        
        let jsonData = json.data(using: .utf8)!
        weatherDataModel = try! JSONDecoder().decode(WeatherDataModel.self, from: jsonData)
    }
    
    override func tearDown() {
        weatherDataModel = nil
    }
    
    //MARK:- Test the datasource before request to server
    func testEmptyValueInDataSourceWhenOpeningData() throws {
        
        let sut = try makeSUT()
        let collectionView = sut.collectionView
        let viewModel = sut.viewModel!
        // expected one section
        sut.createSnapshot(weatherMainInfo: viewModel.subInfoModel, infoModel: viewModel.infoModel)
        XCTAssertEqual(collectionView?.numberOfSections, 2, "Expected two section in collection view")
        
        // expected zero cells
        XCTAssertEqual(collectionView?.numberOfItems(inSection: WForcastDetailSection.mainInfo.rawValue), 1)
        
        // expected one cells
        XCTAssertEqual(collectionView?.numberOfItems(inSection: WForcastDetailSection.coFactors.rawValue), 1)
    }
    
    
    private func makeSUT() throws -> WForcastDetailViewController  {
        
        let coordinator = MForcastDetailCoordinator()
        
        var model = weatherDataModel.data![0]
        let mockModel = WeatherDetailInfoModel(dateTime: model.dateInString,
                                               cityName: weatherDataModel.cityName,
                                               temp: model.temp,
                                               lowTemp: model.lowTemp,
                                               highTemp: model.highTemp,
                                               weather: model.weather)
        
        let sut = try XCTUnwrap(coordinator.makeModule(model: model,
                                                       subInfoModel: mockModel) as? WForcastDetailViewController)
        let viewModel = DefaultWForcastDetailViewModel(weatherForecastModel: model, subInfoModel: mockModel)
        sut.viewModel = viewModel
        _ = sut.view
        return sut
    }
    
}
