//
//  MushroomTableViewController.swift
//  FungiFinderFinal
//
//  Created by Kyle Warren on 9/5/21.
//

import UIKit

class MushroomTableViewController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.isHidden = false
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return MushroomController.mushrooms.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "mushroomCell", for: indexPath)

        let mushroom = MushroomController.mushrooms[indexPath.row]
        cell.textLabel?.text = mushroom.name
        cell.detailTextLabel?.text = mushroom.nickname

        return cell
    }

    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toDetailVC" {
            guard let indexPath = tableView.indexPathForSelectedRow,
                  let destinationVC = segue.destination as? MushroomDetailViewController else { return }
            
            let mushroomToSend = MushroomController.mushrooms[indexPath.row]
            destinationVC.mushroom = mushroomToSend
        }
    }
} // End of Class
