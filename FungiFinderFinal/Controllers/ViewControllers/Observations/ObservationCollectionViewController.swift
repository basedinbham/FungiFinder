//
//  MushroomCollectionViewController.swift
//  FungiFinderFinal
//
//  Created by Kyle Warren on 9/10/21.
//

import UIKit

class ObservationCollectionViewController: UICollectionViewController, UICollectionViewDelegateFlowLayout {
    
    //MARK: - LIFECYCLES
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.isHidden = false
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        ObservationController.shared.fetchOBservations()
        collectionView.reloadData()
    }
    
    //MARK: - ACTIONS
    @IBAction func deleteButtonTapped(_ sender: Any) {
    }
    
    // MARK: UICollectionViewDataSource
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return ObservationController.shared.observations.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "observationCell", for: indexPath) as? ObservationCollectionViewCell else { return UICollectionViewCell() }
        cell.contentView.layer.borderWidth = 1
        cell.contentView.layer.borderColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        
        cell.contentView.layer.cornerRadius = 8.0
        cell.contentView.clipsToBounds = true
        
        let observation = ObservationController.shared.observations.sorted(by: { $0.date ?? Date() > $1.date ?? Date() })[indexPath.row]
        
        cell.displayImageFor(observation: observation)
        cell.displayNameFor(observation: observation)
        
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
        let destinationVC = storyboard?.instantiateViewController(withIdentifier: "ObservationDetailViewController") as? ObservationDetailViewController
        destinationVC?.observation = ObservationController.shared.observations[indexPath.row]
        //guard let destinationVC = destinationVC else { return }
        self.navigationController?.pushViewController(destinationVC!, animated: true)
        
    }
} // End of Class
