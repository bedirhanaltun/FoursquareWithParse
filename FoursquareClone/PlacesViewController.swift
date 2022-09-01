//
//  PlacesViewController.swift
//  FoursquareClone
//
//  Created by Bedirhan Altun on 30.08.2022.
//

import UIKit
import Parse
class PlacesViewController: UIViewController,UITableViewDataSource,UITableViewDelegate {

    var placeNameArray = [String]()
    var  placeIdArray = [String]()
    var selectedPlaceId = ""
    @IBOutlet weak var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        getDataFromParse()

        tableView.delegate = self
        tableView.dataSource = self
        navigationController?.navigationBar.topItem?.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.add, target: self, action: #selector(addButtonClicked))
        
        navigationController?.navigationBar.topItem?.leftBarButtonItem = UIBarButtonItem(title: "Log Out", style: UIBarButtonItem.Style.plain, target: self, action: #selector(logOutButtonClicked))
    }
    
    func getDataFromParse(){
        let query = PFQuery(className: "Places")
        
        query.findObjectsInBackground { objects, error in
            if error != nil{
                self.showError(title: "Hata", message: error?.localizedDescription ?? "")
            }
            else{
                if objects != nil{
                    self.placeIdArray.removeAll(keepingCapacity: false)
                    self.placeNameArray.removeAll(keepingCapacity: false)
                    for object in objects!{
                        if let placeName = object.object(forKey: "name") as? String{
                            if let placeId = object.objectId{
                                self.placeNameArray.append(placeName)
                                self.placeIdArray.append(placeId)
                            }
                        }
                    }
                    self.tableView.reloadData()
                }
            }
        }
    }
    
    @objc func logOutButtonClicked(){
        PFUser.logOutInBackground { logOutError in
            if logOutError != nil{
                self.showError(title: "Error", message: "You didn't log out successfully.")
            }
            else{
                self.performSegue(withIdentifier: "toLoginScreen", sender: nil)
            }
        }
    }
 
    @objc func addButtonClicked(){
        performSegue(withIdentifier: "toOptionsViewController", sender: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toDetailsViewController"{
            let destination = segue.destination as? DetailsViewController
            destination?.chosenPlaceId = selectedPlaceId
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedPlaceId = placeIdArray[indexPath.row]
        performSegue(withIdentifier: "toDetailsViewController", sender: nil)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        cell.textLabel?.text = placeNameArray[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return placeNameArray.count
    }


}
