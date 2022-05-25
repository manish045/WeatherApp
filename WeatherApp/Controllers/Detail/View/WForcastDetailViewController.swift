//
//  WForcastDetailViewController.swift
//  WeatherApp
//
//  Created by Manish Tamta on 23/05/2022.
//

import UIKit
import Combine

class WForcastDetailViewController: UIViewController {

    var viewModel: DefaultWForcastDetailViewModel!
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    private let scheduler: SchedulerContext = SchedulerContextProvider.provide()
    
    private lazy var datasource = DiffableDatasource<WForcastDetailSection, WForcastDetailItem>(collectionView: collectionView!, scheduler: scheduler)
    { [unowned self] (collectionView, indexPath, item) -> UICollectionViewCell? in
        switch item {
        case .infoItem(let model):
            let cell = collectionView.dequeueCell(WForcastDetailInfoMainCollectionViewCell.self, indexPath: indexPath)
            cell.model = model
            return cell
        case .infoChunksItem(let model):
            let cell = collectionView.dequeueCell(WForcastDetailCoFactorCollectionViewCell.self, indexPath: indexPath)
            cell.model = model
            return cell
        }
    } supplementaryViewProvider: {
        [unowned self] (collectionView, kind, indexPath, section) -> UICollectionReusableView? in
        return nil
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        title = "Weather Detail"
        configureCollectionView()
        self.createSnapshot(weatherMainInfo: viewModel.subInfoModel, infoModel: viewModel.infoModel)
    }
    
    private func configureCollectionView() {
        collectionView.registerNibCell(ofType: WForcastDetailInfoMainCollectionViewCell.self)
        collectionView.registerNibCell(ofType: WForcastDetailCoFactorCollectionViewCell.self)
    }
    
    
    func createSnapshot(weatherMainInfo: WeatherDetailInfoModel, infoModel: [WeatherInfo]) {
        var snapshot = datasource.snapshot()
        snapshot.deleteAllItems()
        snapshot.appendSections([.sections(.mainInfo)])
        
        let mainWeatherDetailItems: ItemHolder<WForcastDetailItem> = .items(.infoItem(weatherMainInfo))
        snapshot.appendItems([mainWeatherDetailItems], toSection: .sections(.mainInfo))
        
        snapshot.appendSections([.sections(.coFactors)])
        let cofactorWeatherDetailItems: [ItemHolder<WForcastDetailItem>] = infoModel.map({.items(.infoChunksItem($0))})
        snapshot.appendItems(cofactorWeatherDetailItems, toSection: .sections(.coFactors))
        
        datasource.apply(snapshot)
    }
    
}
