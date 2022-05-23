//
//  HomeViewController.swift
//  WeatherApp
//
//  Created by Manish Tamta on 23/05/2022.
//

import UIKit
import Combine

class WeatherForcastViewController: UIViewController {
    
    var viewModel: DefaultWeatherForcastViewModel!
    private var disposeBag = Set<AnyCancellable>()
    private var state: LoadingState = .loading

    @IBOutlet weak var collectionView: UICollectionView!
    private let scheduler: SchedulerContext = SchedulerContextProvider.provide()
    
    private lazy var datasource = DiffableDatasource<WeatherForcastSection, TemperatureItem>(collectionView: collectionView!, scheduler: scheduler)
    { [unowned self] (collectionView, indexPath, item) -> UICollectionViewCell? in
        switch item {
        case .resultItem(let model):
            let cell = collectionView.dequeueCell(WeeklyForecastCollectionViewCell.self, indexPath: indexPath)
            return cell
        case .loading(let loadingItem):
            let cell = collectionView.dequeueCell(LoadingCollectionCell.self, indexPath: indexPath)
            cell.configure(data: loadingItem)
            return cell
        }
    } supplementaryViewProvider: {
        [unowned self] (collectionView, kind, indexPath, section) -> UICollectionReusableView? in
        return nil
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Weather Forcast"
        configureCollectionView()
        createSnapshot(weatherList: [])
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.navigationBar.isHidden = false
    }
    
    private func configureCollectionView() {
        collectionView.registerNibCell(ofType: WeeklyForecastCollectionViewCell.self)
    }
    
    func createSnapshot(weatherList: [WeatherForecastModel]) {
        var snapshot = datasource.snapshot()
        snapshot.deleteAllItems()
        snapshot.appendSections([.sections(.characters)])
        let nowPlayingItems: [ItemHolder<TemperatureItem>] = weatherList.map{.items(.resultItem($0))}
        snapshot.appendItems(nowPlayingItems, toSection: .sections(.characters))
        
        if state == .default || state == .loading{
            snapshot.appendSections([.loading])
            let loadingItem = LoadingItem(state: state)
            snapshot.appendItems([.loading(loadingItem)], toSection: .loading)
        }
        datasource.apply(snapshot)
    }
}
