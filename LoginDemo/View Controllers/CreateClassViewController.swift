//
//  CreateClassViewController.swift
//  LoginDemo
//
//  Created by Matthew Guo on 14/01/2021.
//

import UIKit
import FirebaseFirestore

class CreateClassViewController: UIViewController {

    //*** IB OUTLET ***//
    @IBOutlet weak var createClassButton: UIButton!
    @IBOutlet weak var classNameTextField: UITextField!
    
    //*** VARS ***//
    var teacherName: String?
    var uid: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print(teacherName)
    }
    
    //*** IB ACTION ***//
    @IBAction func createClassTapped(_ sender: Any) {
        if classNameTextField.text == "" {
            var dialogMessage = UIAlertController(title: "Enter class name", message: "No class name entered. Please enter class name.", preferredStyle: .alert)
            
            let ok = UIAlertAction(title: "Got it!", style: .default, handler: { (action) in
                print("ok tapped")
            })
            
            dialogMessage.addAction(ok)
            self.present(dialogMessage, animated: true, completion: nil)
        }
        
        let className = classNameTextField.text
        //create a new class document
        Firestore.firestore().collection("classes").addDocument(data: ["className" : className,"teacherName" : teacherName, "students": [uid]])
    }
}
