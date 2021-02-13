//
//  LoginViewController.swift
//  LoginDemo
//
//  Created by Matthew Guo on 19/12/2020.
//

import UIKit
import FirebaseAuth

class LoginViewController: UIViewController {

    //*** IB OUTLETS ***//
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var errorLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setUpElements()
    }
    
    //*** FUNCTIONS ***//
    func setUpElements() {
        errorLabel.alpha = 0
        Utilities.styleFilledButton(loginButton)
    }
    
    //*** IB ACTION ***//
    @IBAction func loginTapped(_ sender: Any) {
        if emailTextField.text == "" || passwordTextField.text == "" {
            errorLabel.text = "Please enter username and password"
            self.errorLabel.alpha = 1
            return
        }
        

        
        //process data such that whitespaces and new lines are removed
        let email = emailTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        let password = passwordTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        
        
        //using firebase auth, sign in user.
        Auth.auth().signIn(withEmail: email, password: password) { (result, error) in
            //this code block is executed when firebase returns a result
            
            //check for error
            if error != nil {
                self.errorLabel.text = error!.localizedDescription
                self.errorLabel.alpha = 1
            }
            else {
                //login successful, hence show next view controller
                let tabViewController = self.storyboard?.instantiateViewController(identifier: "tabVC") as? TabBarController
                
                //make homeViewController the root view controller
                self.view.window?.rootViewController = tabViewController
                self.view.window?.makeKeyAndVisible()
            }
        }
    }
}
