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

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
    }
    */

    // MARK: UICollectionViewDataSource

    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return MushroomController.mushrooms.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "mushroomCell", for: indexPath) as? MushroomCollectionViewCell else { return UICollectionViewCell() }
        
        let mushroom = MushroomController.mushrooms[indexPath.row]
        
        cell.displayImageFor(mushroom: mushroom)
        cell.displayNameFor(mushroom: mushroom)
        
        return cell
    }
}

//MARK: - COLLECTION VIEW FLOW LAYOUT DELEGATE METHODS


//MARK: - NAVIGATION
