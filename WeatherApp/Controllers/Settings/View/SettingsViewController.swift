//
//  SettingsViewController.swift
//  WeatherApp
//
//  Created by Manish Tamta on 23/05/2022.
//

import UIKit
import Combine

class SettingsViewController: UIViewController {
    
    var viewModel: DefaultSettingsViewModel!
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    private var dispose = Set<AnyCancellable>()
    private let scheduler: SchedulerContext = SchedulerContextProvider.provide()

    private lazy var datasource = DiffableDatasource<SettingsSection, SettingsItem>(collectionView: collectionView!, scheduler: scheduler)
    { [unowned self] (collectionView, indexPath, item) -> UICollectionViewCell? in
        switch item {
        case .tempUnit(let unitKey, let isSelected):
            let cell = collectionView.dequeueCell(SettingsCollectionViewCell.self, indexPath: indexPath)
            cell.unitKey = unitKey
            cell.isSelectedTemperature = isSelected
            return cell
        }
    } supplementaryViewProvider: {
        [unowned self] (collectionView, kind, indexPath, section) -> UICollectionReusableView? in
        return nil
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        setupNavigation()
        configureCollectionView()
        addViewModelObservers()
    }
    
    private func configureCollectionView() {
        collectionView.registerNibCell(ofType: SettingsCollectionViewCell.self)
        collectionView.delegate = self
    }

    private func addViewModelObservers() {
        viewModel.selectedUnit
            .receive(on: scheduler.ui)
            .sink { [weak self] _ in
                self?.createSnapshot()
            }
            .store(in: &dispose)
    }
    
    func createSnapshot() {
        var snapshot = datasource.snapshot()
        snapshot.deleteAllItems()
       
        snapshot.appendSections([.sections(.celcius)])
        let celciusUnitKey = UnitKey.celcius
        let celciusItem: ItemHolder<SettingsItem> = .items(.tempUnit(celciusUnitKey, viewModel.isSelectedUnit(unit: celciusUnitKey)))
        snapshot.appendItems([celciusItem], toSection: .sections(.celcius))
        
        snapshot.appendSections([.sections(.fahrenheit)])
        let fahrenheitUnitKey = UnitKey.fahrenheit
        let farenheittItem: ItemHolder<SettingsItem> = .items(.tempUnit(fahrenheitUnitKey, viewModel.isSelectedUnit(unit: fahrenheitUnitKey)))
        snapshot.appendItems([farenheittItem], toSection: .sections(.fahrenheit))
        
        datasource.apply(snapshot)
    }
    
    private func setupNavigation(){
        title = "Settings"
        
        let settingBtn = UIBarButtonItem(title: "Save", style: .done, target: self, action: #selector(saveButtonPressed))
        self.navigationItem.rightBarButtonItems = [settingBtn]
    }
    
    @objc private func saveButtonPressed() {
        viewModel.saveTempUnit()
        viewModel.dismissViewController()
    }
}

extension SettingsViewController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let cell = collectionView.cellForItem(at: indexPath) as? SettingsCollectionViewCell else {return}
        if let unitKey = cell.unitKey {
            self.viewModel.updateTempUnit(unitKey: unitKey)
        }
    }
}
