//
//  ViewController.swift
//  FoursquareClone
//
//  Created by Bedirhan Altun on 30.08.2022.
//

import UIKit
import Parse

class LoginScreen: UIViewController {

    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var userNameTextField: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        /*
        //Parse Veri Kaydetmek.
        let parseObject = PFObject(className: "Fruits")
        parseObject["name"] = "Apple"
        parseObject["calories"] = 100
        parseObject["name"] = "Strawberry"
        parseObject["calories"] = 200
        parseObject.saveInBackground { success, error in
            if error != nil{
                print(error?.localizedDescription)
            }
            else{
                print(success)
            }
        }
        */
        
        /*
        //Parse'dan Veri Çekmek.
        
        let query = PFQuery(className: "Fruits")
        //query.whereKey("name", equalTo: "Strawberry")
        query.whereKey("calories", lessThan: 200)
        query.findObjectsInBackground { objects, error in
            if error != nil {
                print(error?.localizedDescription)
            }
            else{
                print(objects)
            }
        }
        */
    }
    @IBAction func signInButtonClicked(_ sender: Any) {
        
        if userNameTextField.text != "" && passwordTextField.text != ""{
            
            PFUser.logInWithUsername(inBackground: userNameTextField.text!, password: passwordTextField.text!) { user, loginError in
                if loginError != nil {
                    self.showError(title: "Error", message: loginError?.localizedDescription ?? "Hata")
                }
                else{
                    self.performSegue(withIdentifier: "toPlacesVC", sender: nil)
                }
            }
            
        }
        else{
            showError(title: "Error", message: "Password or username incorrect. Please try again ...")
        }
        
    }
    
    @IBAction func signUpButtonClicked(_ sender: Any) {
        if userNameTextField.text != "" && passwordTextField.text != ""{
            
            let user = PFUser()
            user.username = userNameTextField.text
            user.password = passwordTextField.text
            user.signUpInBackground { signUpSuccess, signUpError in
                if signUpError != nil{
                    self.showError(title: "Error", message: signUpError?.localizedDescription ?? "Hata")
                }
                else{
                    
                    self.showError(title: "Success", message: "You signed up successfully.")
                    self.performSegue(withIdentifier: "toPlacesVC", sender: nil)
                }
            }
            
        }
        else{
            showError(title: "Error", message: "Username or Password incorrect.")
        }
    }
    
   
    
}
extension UIViewController{
    func showError(title: String,message: String){
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
        let okButton = UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil)
        alert.addAction(okButton)
        present(alert, animated: true, completion: nil)
        
    }
}

