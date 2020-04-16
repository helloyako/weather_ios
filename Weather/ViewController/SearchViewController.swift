//
//  SearchViewController.swift
//  Weather
//
//  Created by helloyako on 2020/04/15.
//  Copyright © 2020 helloyako. All rights reserved.
//

import UIKit
import MapKit

class SearchViewController: UIViewController {
    
    private let searchCompleter = MKLocalSearchCompleter()
    private var searchResults = [MKLocalSearchCompletion]()
    var completion: (((lat: Double, lon: Double)) -> ())? = nil

    @IBOutlet weak var tableView: UITableView! {
        didSet {
            tableView.dataSource = self
            tableView.delegate = self
        }
    }
    @IBOutlet weak var textField: UITextField! {
        didSet {
            let image = UIImage(named: "search_icon")
            let iconView = UIImageView(frame: CGRect(x: 10, y: 5, width: 20, height: 20))
            iconView.image = image
            let iconContainerView: UIView = UIView(frame: CGRect(x: 20, y: 0, width: 30, height: 30))
            iconContainerView.addSubview(iconView)
            textField.leftView = iconContainerView
            textField.leftViewMode = .always
            textField.attributedPlaceholder = NSAttributedString(string:"Search", attributes:
                [NSAttributedString.Key.foregroundColor: #colorLiteral(red: 1, green: 1, blue: 1, alpha: 0.3)])
            
            textField.delegate = self
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .clear
        let blurEffect = UIBlurEffect(style: .regular)
        let blurView = UIVisualEffectView(effect: blurEffect)
        blurView.translatesAutoresizingMaskIntoConstraints = false
        view.insertSubview(blurView, at: 0)
        blurView.leadingAnchor.constraint(equalToSystemSpacingAfter: view.leadingAnchor, multiplier: 0).isActive = true
        blurView.trailingAnchor.constraint(equalToSystemSpacingAfter: view.trailingAnchor, multiplier: 0).isActive = true
        blurView.topAnchor.constraint(equalToSystemSpacingBelow: view.topAnchor, multiplier: 0).isActive = true
        blurView.bottomAnchor.constraint(equalToSystemSpacingBelow: view.bottomAnchor, multiplier: 0).isActive = true
        
        searchCompleter.delegate = self
        searchCompleter.filterType = .locationsOnly
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        textField.becomeFirstResponder()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        textField.resignFirstResponder()
    }
    
    @IBAction func editingChanged(_ sender: UITextField) {
        guard let text = textField.text, !text.isEmpty else {
            return
        }
        searchCompleter.queryFragment = text
    }
    
    @IBAction func cancelButtonAction(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    
}

extension SearchViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return searchResults.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "SearchCell") else {
            return UITableViewCell()
        }
        let bgColorView = UIView()
        bgColorView.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 0.1)
        cell.selectedBackgroundView = bgColorView
    
        cell.textLabel?.text = searchResults[indexPath.row].title
        if let att = cell.textLabel?.attributedText {
            let mut = NSMutableAttributedString(attributedString: att)
            mut.setColorForText(textField.text!, with: .white)
            cell.textLabel?.attributedText = mut
        }
        return cell
    }
}

extension SearchViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let selectedResult = searchResults[indexPath.row]
        let searchRequest = MKLocalSearch.Request(completion: selectedResult)
        let search = MKLocalSearch(request: searchRequest)
        search.start { response, error in
            guard error == nil else {
                return
            }
            
            guard let placeMark = response?.mapItems.first?.placemark else {
                return
            }
            
            let lat = placeMark.coordinate.latitude
            let lon = placeMark.coordinate.longitude
            
            DispatchQueue.main.async {        
                self.dismiss(animated: true) { [weak self]  in
                    self?.completion?((lat: lat, lon: lon))
                }
            }
        }
    }
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if textField.isFirstResponder {
            textField.resignFirstResponder()
        }
    }
}

extension SearchViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        guard let text = textField.text, !text.isEmpty else {
            return true
        }
        searchCompleter.queryFragment = text
        return true
    }
}

extension SearchViewController: MKLocalSearchCompleterDelegate {
    func completerDidUpdateResults(_ completer: MKLocalSearchCompleter) {
        searchResults = completer.results
        tableView.reloadData()
    }
    func completer(_ completer: MKLocalSearchCompleter, didFailWithError error: Error) {
        print(error)
    }
}
