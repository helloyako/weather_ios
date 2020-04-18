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
    private var lastContentOffset: CGFloat = 0
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var pageControl: UIPageControl!
    @IBOutlet weak var currentImageView: UIImageView!
    @IBOutlet weak var leftImageView: UIImageView! {
        didSet {
            leftImageView.alpha = 0
        }
    }
    @IBOutlet weak var rightImageView: UIImageView! {
        didSet {
            rightImageView.alpha = 0
        }
    }
    
    private let loadingQueue = OperationQueue()
    private var loadingOperations: [IndexPath: OneCallLoadOperation] = [:]
    
    weak var rootViewController: WeatherRootViewController?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView.dataSource = self
        collectionView.delegate = self
    }
    
    private func getBackgroundImage(index: Int) -> UIImage? {
        guard index >= 0 && index < displayModels.count else {
            return .none
        }
        if let iconName = displayModels[index].weather.first?.icon {
            return UIImage(named: iconName) ?? .none
        } else {
            return .none
        }
    }
    
    func updateModel(displayModels: [DisplayModel]) {
        self.displayModels = displayModels
        if displayModels.count > 1 {
            pageControl.numberOfPages = displayModels.count
            pageControl.isHidden = false
        } else {
            pageControl.isHidden = true
        }
        
        if let image = getBackgroundImage(index: 0) {
            currentImageView.image = image
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
    var startedScroll = false
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
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if !startedScroll {
            return
        }
        
        if (scrollView.contentOffset.x + scrollView.frame.width) > scrollView.contentSize.width {
            return
        }
        
        if scrollView.contentOffset.x < 0 {
            return
        }
        
        var nextIamgeView = leftImageView
        if lastContentOffset > scrollView.contentOffset.x {
            nextIamgeView = leftImageView
        } else if lastContentOffset < scrollView.contentOffset.x {
            nextIamgeView = rightImageView
        }

        lastContentOffset = scrollView.contentOffset.x
        
        let mod = scrollView.contentOffset.x.truncatingRemainder(dividingBy: scrollView.bounds.size.width)

        let difference = abs((2 * mod / (scrollView.bounds.size.width)) - 1)

        let factor = (difference * 0.5) + 0.5
        currentImageView.alpha = factor
        nextIamgeView?.alpha = 1 - factor
    }
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        startedScroll = true
    }
    
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        startedScroll = false
        let page = Int(targetContentOffset.pointee.x / scrollView.frame.width)
        pageControl.currentPage = page
        let leftIndex = page - 1
        let rightIndex = page + 1
        currentImageView.alpha = 100
        leftImageView.alpha = 0
        rightImageView.alpha = 0
        currentImageView.image = getBackgroundImage(index: page)
        leftImageView.image = getBackgroundImage(index: leftIndex)
        rightImageView.image = getBackgroundImage(index: rightIndex)
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
