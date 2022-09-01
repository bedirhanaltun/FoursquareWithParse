//
//  OptionsViewController.swift
//  FoursquareClone
//
//  Created by Bedirhan Altun on 31.08.2022.
//

import UIKit

class OptionsViewController: UIViewController,UIImagePickerControllerDelegate,UINavigationControllerDelegate {

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var placeAtmosphereTextField: UITextField!
    @IBOutlet weak var placeTypeTextField: UITextField!
    @IBOutlet weak var placeNameTextField: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        imageView.isUserInteractionEnabled = true
        let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(selectImage))
        imageView.addGestureRecognizer(gestureRecognizer)
        
        
        
    }
    @objc private func selectImage(){
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.sourceType = .photoLibrary
        present(picker, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        imageView.image = info[.originalImage] as? UIImage
        dismiss(animated: true,completion: nil)
    }

    @IBAction func nextButtonClicked(_ sender: Any) {
        
        if placeNameTextField.text != "" && placeTypeTextField.text != "" && placeAtmosphereTextField.text != "" {
            if let selectedImage = imageView.image{
                let places = Places.instance
                places.placeName = placeNameTextField.text ?? ""
                places.placeType = placeTypeTextField.text ?? ""
                places.placeDescription = placeAtmosphereTextField.text ?? ""
                places.placeImage = selectedImage
            }
            
            performSegue(withIdentifier: "toMapViewController", sender: nil)
        }
        else{
            showError(title: "Error", message: "Error")
        }
        
        
        
    }
}
