//
//  WeatherDetailViewController.swift
//  Weather
//
//  Created by helloyako on 2020/04/14.
//  Copyright © 2020 helloyako. All rights reserved.
//

import UIKit

class WeatherDetailViewController: UIViewController, OpenWeather {
    private var displayModels: [DisplayModel] = [] {
        didSet {
            oneCallResponses = [OneCallResponse?](repeating: nil, count: displayModels.count)
        }
    }
    private var oneCallResponses: [OneCallResponse?] = []
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var pageControl: UIPageControl!
    
    private let loadingQueue = OperationQueue()
    private var loadingOperations: [IndexPath: OneCallLoadOperation] = [:]
    
    weak var rootViewController: WeatherRootViewController?
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView.dataSource = self
        collectionView.delegate = self
    }
    
    func updateModel(displayModels: [DisplayModel]) {
        self.displayModels = displayModels
        if displayModels.count > 1 {
            pageControl.numberOfPages = displayModels.count
            pageControl.isHidden = false
        } else {
            pageControl.isHidden = true
        }
        collectionView.reloadData()
    }
    
    func scrollToItem(at index: Int) {
        let indexPath = IndexPath(item: index, section: 0)
        collectionView.scrollToItem(at: indexPath, at: .right, animated: false)
        pageControl.currentPage = index
    }
    
    func reloadData() {
        collectionView.reloadData()
    }
    
    @IBAction func openWeatherButtonAction(_ sender: UIButton) {
        showOpenWeatherSafari()
    }
    
    @IBAction func listButtonAction(_ sender: UIButton) {
        rootViewController?.showListView()
    }
    
}

extension WeatherDetailViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return displayModels.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "DetailCollectionViewCell", for: indexPath)
        if let detailCell = cell as? DetailCollectionViewCell {
            let displayModel = displayModels[indexPath.item]
            detailCell.bind(model: displayModel, isCelsius: rootViewController?.isCelsius ?? true)
    
        }
        return cell
        
    }
}

extension WeatherDetailViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return collectionView.frame.size
    }
    
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        let page = Int(targetContentOffset.pointee.x / scrollView.frame.width)
        pageControl.currentPage = page
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        guard let cell = cell as? DetailCollectionViewCell else {
            return
        }
        
        if let oneCallResponse = oneCallResponses[indexPath.item] {
            cell.updateExtraData(model: oneCallResponse)
            return
        }
        
        let updateCellClosure: (OneCallResponse?) -> () = { [weak self] oneCallResponse in
            guard let self = self, let oneCallResponse = oneCallResponse else {
                return
            }
            self.oneCallResponses[indexPath.item] = oneCallResponse
            cell.updateExtraData(model: oneCallResponse)
            self.loadingOperations.removeValue(forKey: indexPath)
        }
        
        if let dataLoader = loadingOperations[indexPath] {
            if let oneCallResponse = dataLoader.oneCallResponse {
                oneCallResponses[indexPath.item] = oneCallResponse
                cell.updateExtraData(model: oneCallResponse)
                loadingOperations.removeValue(forKey: indexPath)
            } else {
                dataLoader.loadingCompleteHandler = updateCellClosure
            }
        } else {
    
            let coord = displayModels[indexPath.item].coord
            let dataLoader = OneCallLoadOperation(lat: coord.lat, lon: coord.lon)
            dataLoader.loadingCompleteHandler = updateCellClosure
            loadingQueue.addOperation(dataLoader)
            loadingOperations[indexPath] = dataLoader
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, didEndDisplaying cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if let dataLoader = loadingOperations[indexPath] {
            dataLoader.cancel()
            loadingOperations.removeValue(forKey: indexPath)
        }
    }
}

extension WeatherDetailViewController: UICollectionViewDataSourcePrefetching {
    func collectionView(_ collectionView: UICollectionView, prefetchItemsAt indexPaths: [IndexPath]) {
        for indexPath in indexPaths {
            if let _ = loadingOperations[indexPath] {
                continue
            }
            if let _ = oneCallResponses[indexPath.row] {
                continue
            }
            let coord = displayModels[indexPath.item].coord
            let dataLoader = OneCallLoadOperation(lat: coord.lat, lon: coord.lon)
            loadingQueue.addOperation(dataLoader)
            loadingOperations[indexPath] = dataLoader
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cancelPrefetchingForItemsAt indexPaths: [IndexPath]) {
        for indexPath in indexPaths {
            if let dataLoader = loadingOperations[indexPath] {
                dataLoader.cancel()
                loadingOperations.removeValue(forKey: indexPath)
            }
        }
    }
}
