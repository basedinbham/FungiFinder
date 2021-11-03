//
//  MushroomCollectionViewController.swift
//  FungiFinderFinal
//
//  Created by Kyle Warren on 9/10/21.
//

import UIKit

class ObservationCollectionViewController: UIViewController, UICollectionViewDelegateFlowLayout, UICollectionViewDelegate, UICollectionViewDataSource  {
    
    //MARK: - OUTLETS
    @IBOutlet weak var observationCollectionView: UICollectionView!
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var searchButton: UIBarButtonItem!
    @IBOutlet weak var addButtonTapped: UIBarButtonItem!
    
    
    //MARK: - PROPERTIES
    var resultsArray: [SearchableRecord] = []
    var isSearching: Bool = false
    var dataSource: [SearchableRecord] {
        return isSearching ? resultsArray : ObservationController.shared.observations
    }
    
    //MARK: - LIFECYCLES
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.isHidden = false
        observationCollectionView.delegate = self
        observationCollectionView.dataSource = self
        resultsArray = ObservationController.shared.observations
        //        hideKeyboardWhenTappedAroundSearch()
        searchBar.delegate = self
        searchBar.isHidden = true
        searchBar.showsCancelButton = true
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        ObservationController.shared.fetchOBservations()
        observationCollectionView.reloadData()
        resultsArray = ObservationController.shared.observations
    }
    
    //MARK: - ACTIONS
    @IBAction func searchButtonTapped(_ sender: Any) {
        searchBar.isHidden = false
        navigationController?.navigationBar.isHidden = true
        searchBar.becomeFirstResponder()
    }
    
    @IBAction func addButtonTapped(_ sender: Any) {
        let destinationVC = storyboard?.instantiateViewController(withIdentifier: "ObservationDetailViewController") as? ObservationDetailViewController
        self.navigationController?.pushViewController(destinationVC!, animated: true)
    }
    
    
    // MARK: UICollectionViewDataSource
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dataSource.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "observationCell", for: indexPath) as? ObservationCollectionViewCell else { return UICollectionViewCell() }
        cell.contentView.layer.borderWidth = 1
        cell.contentView.layer.borderColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        
        cell.contentView.layer.cornerRadius = 8.0
        cell.contentView.clipsToBounds = true
        
        guard let observation = resultsArray[indexPath.row] as? Observation else { return UICollectionViewCell() }
        
        cell.displayImageFor(observation: observation)
        cell.displayNameFor(observation: observation)
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let height = collectionView.frame.height * 0.3
        let width = collectionView.frame.width * 0.45
        return CGSize(width: width, height: height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        
        let oneCellWidth = view.frame.width * 0.45
        let cellsTotalWidth = oneCellWidth * 2
        let leftoverWidth = view.frame.width - cellsTotalWidth
        let inset = leftoverWidth / 3
        
        return UIEdgeInsets(top: inset, left: inset, bottom: 0, right: inset)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let destinationVC = storyboard?.instantiateViewController(withIdentifier: "ObservationDetailViewController") as? ObservationDetailViewController
        destinationVC?.observation = resultsArray[indexPath.row] as? Observation
        self.navigationController?.pushViewController(destinationVC!, animated: true)
    }
} // End of Class

extension ObservationCollectionViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if !searchText.isEmpty {
            resultsArray = ObservationController.shared.observations.filter { $0.matches(searchTerm: searchText) }
            observationCollectionView.reloadData()
        } else {
            resultsArray = ObservationController.shared.observations
            observationCollectionView.reloadData()
        }
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        isSearching = true
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        searchBar.text = ""
        isSearching = false
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        view.endEditing(true)
        searchBar.isHidden = true
        navigationController?.navigationBar.isHidden = false
        resultsArray = ObservationController.shared.observations
        observationCollectionView.reloadData()
    }
    
} // End of Extension

