//
//  MushroomCollectionViewController.swift
//  FungiFinderFinal
//
//  Created by Kyle Warren on 9/10/21.
//

import UIKit

class MushroomCollectionViewController: UIViewController, UICollectionViewDelegateFlowLayout, UICollectionViewDelegate, UICollectionViewDataSource {
    
    //MARK: - OUTLETS
    @IBOutlet weak var mushroomCollectionView: UICollectionView!
    @IBOutlet weak var searchBar: UISearchBar!
    
    
    //MARK: - PROPERTIES
    var resultsArray: [SearchableRecord] = []
    var isSearching: Bool = false
    var dataSource: [SearchableRecord] {
        return isSearching ? resultsArray : MushroomController.mushrooms
    }
    
    //MARK: - LIFECYCLES
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.isHidden = true
        mushroomCollectionView.delegate = self
        mushroomCollectionView.dataSource = self
        resultsArray = MushroomController.mushrooms
        hideKeyboardWhenTappedAround()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        resultsArray = MushroomController.mushrooms
        mushroomCollectionView.reloadData()
    }
    
    // MARK: UICollectionViewDataSource
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dataSource.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "mushroomCell", for: indexPath) as? MushroomCollectionViewCell else { return UICollectionViewCell() }
        cell.contentView.layer.borderWidth = 1
        cell.contentView.layer.borderColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        
        cell.contentView.layer.cornerRadius = 8.0
        cell.contentView.clipsToBounds = true
        
        guard let mushroom = resultsArray[indexPath.row] as? Mushroom else { return UICollectionViewCell() }
        
        cell.displayImageFor(mushroom: mushroom)
        cell.displayNameFor(mushroom: mushroom)
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let height = collectionView.frame.height * 0.3
        let width  = collectionView.frame.width * 0.45
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
        let destinationVC = storyboard?.instantiateViewController(withIdentifier: "MushroomDetailViewController") as? MushroomDetailViewController
        destinationVC?.mushroom = resultsArray[indexPath.row] as? Mushroom
        //let mushroomToSend = MushroomController.mushrooms[indexPath.row]
        self.navigationController?.pushViewController(destinationVC!, animated: true)

    }
} // End of Class

extension MushroomCollectionViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if !searchText.isEmpty {
            resultsArray = MushroomController.mushrooms.filter { $0.matches(searchTerm: searchText) }
            mushroomCollectionView.reloadData()
        } else {
            resultsArray = MushroomController.mushrooms
            mushroomCollectionView.reloadData()
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
    
} // End of Extension
