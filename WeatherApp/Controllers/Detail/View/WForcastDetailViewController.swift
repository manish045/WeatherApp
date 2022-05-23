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
    
    private var disposeBag = Set<AnyCancellable>()
    private let scheduler: SchedulerContext = SchedulerContextProvider.provide()
    
    private lazy var datasource = DiffableDatasource<WForcastDetailSection, WForcastDetailItem>(collectionView: collectionView!, scheduler: scheduler)
    { [unowned self] (collectionView, indexPath, item) -> UICollectionViewCell? in
        switch item {
        case .infoItem(let model):
            let cell = collectionView.dequeueCell(WForcastDetailInfoMainCollectionViewCell.self, indexPath: indexPath)
            return cell
        case .infoChunksItem(_):
            let cell = collectionView.dequeueCell(WForcastDetailCoFactorCollectionViewCell.self, indexPath: indexPath)
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
    }
    
    private func configureCollectionView() {
        collectionView.registerNibCell(ofType: WForcastDetailInfoMainCollectionViewCell.self)
        collectionView.registerHeader(ofType: WForcastDetailCoFactorCollectionViewCell.self)
    }
    
    
    func createSnapshot(weatherList: WeatherForecastModel) {
        var snapshot = datasource.snapshot()
        snapshot.deleteAllItems()
        snapshot.appendSections([.sections(.mainInfo)])
        
        let mainWeatherDetailItems: ItemHolder<WForcastDetailItem> = .items(.infoItem(weatherList))
        snapshot.appendItems([mainWeatherDetailItems], toSection: .sections(.mainInfo))
        
        let cofactorWeatherDetailItems: ItemHolder<WForcastDetailItem> = .items(.infoChunksItem(weatherList))
        snapshot.appendItems([cofactorWeatherDetailItems], toSection: .sections(.coFactors))
        
        datasource.apply(snapshot)
    }
    
}
