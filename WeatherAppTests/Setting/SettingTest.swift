//
//  SettingTest.swift
//  WeatherAppTests
//
//  Created by Manish Tamta on 25/05/2022.
//

import XCTest
import Combine
@testable import WeatherApp

class SettingTestXCTest: XCTestCase {
    
    private var cancellables: Set<AnyCancellable>!
    
    override func setUp() {
        cancellables = []
    }
    
    override func tearDown() {
        cancellables = nil
    }
    
    //MARK:- Test the datasource before request to server
    func testEmptyValueInDataSourceWhenOpeningData() throws {
        
        let sut = try makeSUT()
        let collectionView = sut.collectionView
        // expected one section
        sut.createSnapshot()
        XCTAssertEqual(collectionView?.numberOfSections, 2, "Expected two section in collection view")
        
        // expected zero cells
        XCTAssertEqual(collectionView?.numberOfItems(inSection: SettingsSection.celcius.rawValue), 1)
        
        // expected one cells
        XCTAssertEqual(collectionView?.numberOfItems(inSection: SettingsSection.fahrenheit.rawValue), 1)
    }
    
    func testObservers() throws {
        let sut = try makeSUT()
        
        let viewModel = sut.viewModel!
        
        let expectation = XCTestExpectation(description: "load Selected Unit")
        
        viewModel.selectedUnit
            .sink (receiveValue: { value in
                XCTAssertNotNil(value)
                expectation.fulfill()
            })
            .store(in: &cancellables)
    }
    
    
    private func makeSUT() throws -> SettingsViewController  {
        
        let coordinator = SettingsViewCoordinator()
        
        let sut = try XCTUnwrap(coordinator.makeModule() as? SettingsViewController)
        let viewModel = DefaultSettingsViewModel(coordinator: coordinator)
        sut.viewModel = viewModel
        _ = sut.view
        return sut
    }
    
}
