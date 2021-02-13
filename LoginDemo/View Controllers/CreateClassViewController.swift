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
        loadLastName()
    }
    
    //*** FUNCTIONS ***//
    func loadLastName() {
        let userDocument = Firestore.firestore().collection("users").document(uid!)
        userDocument.getDocument { (document, error) in
            let dataDescription = document?.data()
            self.teacherName = dataDescription!["lastname"] as? String ?? "Smith"
        }
    }
    
    //*** IB ACTION ***//
    @IBAction func createClassTapped(_ sender: Any) {
        if classNameTextField.text == "" {
            let dialogMessage = UIAlertController(title: "Enter class name", message: "No class name entered. Please enter class name.", preferredStyle: .alert)
            
            let ok = UIAlertAction(title: "Got it!", style: .default, handler: { (action) in
                print("ok tapped")
            })
            
            dialogMessage.addAction(ok)
            self.present(dialogMessage, animated: true, completion: nil)
        }
        
        let className = classNameTextField.text
        //create a new class document
        Firestore.firestore().collection("classes").addDocument(data: ["className" : className!,"teacherName" : teacherName!, "participants": [uid], "feedback": [uid: ["nil", "nil"]]])
        
        let creationCompleteMessage = UIAlertController(title: "Your new class has been created!", message: "Please return to My Classes and reload.", preferredStyle: .alert)
        
        let ok = UIAlertAction(title: "Got it!", style: .default, handler: { (action) in
            print("ok tapped")
        })
        
        creationCompleteMessage.addAction(ok)
        self.present(creationCompleteMessage, animated: true, completion: nil)
    }
}
