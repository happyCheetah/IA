//
//  SignUpViewController.swift
//  LoginDemo
//
//  Created by Matthew Guo on 19/12/2020.
//

import UIKit
import FirebaseAuth
import Firebase

class SignUpViewController: UIViewController {

    //*** IB OUTLETS ***//
    @IBOutlet weak var firstNameTextField: UITextField!
    @IBOutlet weak var lastNameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var signUpButton: UIButton!
    @IBOutlet weak var errorLabel: UILabel!
    @IBOutlet weak var IDNumberTextField: UITextField!
    @IBOutlet weak var studentOrTeacherSegmentedControl: UISegmentedControl!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUpElements()
    }
    
    //*** FUNCTIONS ***//
    
    /* style buttons and text fields accordingly  */
    func setUpElements() {
        errorLabel.alpha = 0
        
//        Utilities.styleTextField(firstNameTextField)
//        Utilities.styleTextField(lastNameTextField)
//        Utilities.styleTextField(emailTextField)
//        Utilities.styleTextField(passwordTextField)
        Utilities.styleFilledButton(signUpButton)
    }

    /* fields validated (check if meet requirements) used. part of signupbuttontapped call stack */
    func validateFields() -> String? {
        
        // check that all fields are filled in
        if firstNameTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" || lastNameTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" || emailTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" || passwordTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" || IDNumberTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" {
            return "Please fill in all fields."
        }
        
        //check if password is secure
        let cleanedPassword = passwordTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        
        if Utilities.isPasswordValid(cleanedPassword) == false {
            return "Please make sure your password is at least 8 char, 1 special char, and 1 number"
        }
        return nil
    }
    
    //*** IB ACTION ***//
    @IBAction func signUpTapped(_ sender: Any) {
        
        //validate fields
        let error = validateFields()
        
        if error != nil {
            showError(error!)
        }
        
        else {
            // cleaned data
            let firstName = firstNameTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            let lastName = lastNameTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            let email = emailTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            let password = passwordTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            let status = studentOrTeacherSegmentedControl.selectedSegmentIndex
            
            // create user
            Auth.auth().createUser(withEmail: email, password: password) { (result, err) in
                
                if err != nil {
                    self.showError("Error creating user with Firebase")
                }
                else {
                    //this is a firestore database object that we will perform operations on
                    let db = Firestore.firestore()
                    // given successful creation of user, store first name, last name and other data
                    db.collection("users").document(result!.user.uid).setData(["firstname": firstName, "lastname": lastName, "uid": result!.user.uid, "status": status]){ (error) in
                        
                        if error != nil {
                            //first and last name could not be stored, despite user being created
                            self.showError("User data ")
                        }
                    }
                    self.transitionToHome()
                }
            }
        }
    }
    
    func showError (_ message:String) {
        errorLabel.text = message
        errorLabel.alpha = 1
    }
    
    
    func transitionToHome () {
        /* Transition from SignUpViewController to HomeViewController */
        
        // Create an instance of HomeViewController
        let homeViewController = storyboard?.instantiateViewController(identifier: Constants.Storyboard.homeViewController) as? HomeViewController
        
        // Set homeViewController as the root view controller and show it
        view.window?.rootViewController = homeViewController
        view.window?.makeKeyAndVisible()
    }
}
