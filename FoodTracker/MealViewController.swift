//
//  ViewController.swift
//  FoodTracker
//
//  Created by JOSEPH KERR on 3/1/16.
//  Copyright © 2016 JOSEPH KERR. All rights reserved.
//

import UIKit

// Question
// Is there any difference between subclass UIViewController and conforming to protocol

class MealViewController: UIViewController, UITextFieldDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    // MARK: Properties
    
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var photoImageView: UIImageView!
    @IBOutlet weak var ratingControl: RatingControl!
    @IBOutlet weak var saveButton: UIBarButtonItem!
    
    /*
    This value is either passed by `MealTableViewController` in `prepareForSegue(_:sender:)`
    or constructed as part of adding a new meal.
    */
    var meal: Meal?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // handle text field
        nameTextField.delegate = self
        
        if let meal = meal {
            navigationItem.title = meal.name
            nameTextField.text = meal.name
            photoImageView.image = meal.photo
            ratingControl.rating = meal.rating
        }
        
        // enable save only when name nameField has valid name
        checkValidMealName()
    }

    
    // MARK: UITextFieldDelegate
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func textFieldDidBeginEditing(textField: UITextField) {
        saveButton.enabled = false
    }

    func textFieldDidEndEditing(textField: UITextField) {
        checkValidMealName()
        navigationItem.title = textField.text
    }

    func checkValidMealName(){
        // disable the Svae button if the textfield is empty
        let text = nameTextField.text ?? ""
        saveButton.enabled = !text.isEmpty
    }
    
    
    // MARK: UIImagePickerControllerDelegate
    
    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        dismissViewControllerAnimated(true, completion: nil)
//        dismissViewControllerAnimated(<#T##flag: Bool##Bool#>, completion: <#T##(() -> Void)?##(() -> Void)?##() -> Void#>)
    }
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        
        // the info dictionary contains multiple representations of the image and this uses the original
        let selectedImage = info[UIImagePickerControllerOriginalImage] as! UIImage
        
        photoImageView.image = selectedImage
        
        dismissViewControllerAnimated(true, completion: nil)
        //        dismissViewControllerAnimated(<#T##flag: Bool##Bool#>, completion: <#T##(() -> Void)?##(() -> Void)?##() -> Void#>)

    }
    
    
    // MARK: Navigation
    
    @IBAction func cancel(sender: UIBarButtonItem) {
        
        // depending on style presented
        
        let isPresentingInAddMode = presentingViewController is UINavigationController
        if isPresentingInAddMode {
            dismissViewControllerAnimated(true, completion: nil )
            
        } else {
            navigationController?.popViewControllerAnimated(true)
        }
    }
    
    // method to ocnfigure a viewController before it is presented
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if saveButton === sender {
            let name = nameTextField.text ?? ""
            let photo = photoImageView.image
            let rating = ratingControl.rating
            
            // set the meal on MealViewController after the unwind segue
            meal = Meal(name: name, photo: photo, rating: rating)
            
        }
    }
    
    
    // MARK: Actions
    
    @IBAction func selectImageFromPhotoLibrary(sender: UITapGestureRecognizer) {

        nameTextField.resignFirstResponder()
        
        let imagePickerController = UIImagePickerController()
        
        // only allow photos, not taken
        imagePickerController.sourceType = .PhotoLibrary
        
        imagePickerController.delegate = self
        
        presentViewController(imagePickerController, animated: true, completion: nil)
//        presentViewController(<#T##viewControllerToPresent: UIViewController##UIViewController#>, animated: <#T##Bool#>, completion: <#T##(() -> Void)?##(() -> Void)?##() -> Void#>)
        
    }
    
    
}

