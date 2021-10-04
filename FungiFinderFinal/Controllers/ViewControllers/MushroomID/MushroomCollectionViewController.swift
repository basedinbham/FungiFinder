//
//  MushroomCollectionViewController.swift
//  FungiFinderFinal
//
//  Created by Kyle Warren on 9/10/21.
//

import UIKit

class MushroomCollectionViewController: UICollectionViewController, UICollectionViewDelegateFlowLayout {
    
    //MARK: - LIFECYCLES
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.isHidden = false
 
    }
    
    // MARK: UICollectionViewDataSource
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return MushroomController.mushrooms.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "mushroomCell", for: indexPath) as? MushroomCollectionViewCell else { return UICollectionViewCell() }
        cell.contentView.layer.borderWidth = 1
        cell.contentView.layer.borderColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        
        cell.contentView.layer.cornerRadius = 8.0
        cell.contentView.clipsToBounds = true
        
        let mushroom = MushroomController.mushrooms[indexPath.row]
        
        cell.displayImageFor(mushroom: mushroom)
        cell.displayNameFor(mushroom: mushroom)
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let height = collectionView.frame.height * 0.225
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
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let destinationVC = storyboard?.instantiateViewController(withIdentifier: "MushroomDetailViewController") as? MushroomDetailViewController
        destinationVC?.mushroom = MushroomController.mushrooms[indexPath.row]
        //let mushroomToSend = MushroomController.mushrooms[indexPath.row]
        self.navigationController?.pushViewController(destinationVC!, animated: true)

    }
} // End of Class
