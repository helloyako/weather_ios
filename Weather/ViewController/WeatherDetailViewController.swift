//
//  WeatherDetailViewController.swift
//  Weather
//
//  Created by helloyako on 2020/04/14.
//  Copyright © 2020 helloyako. All rights reserved.
//

import UIKit

class WeatherDetailViewController: UIViewController {
    private var displayModels: [DisplayModel] = []
    @IBOutlet weak var collectionView: UICollectionView!
    weak var rootViewController: WeatherRootViewController?
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView.dataSource = self
        collectionView.delegate = self
    }
    
    func updateModel(displayModels: [DisplayModel]) {
        self.displayModels = displayModels
        collectionView.reloadData()
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
}
