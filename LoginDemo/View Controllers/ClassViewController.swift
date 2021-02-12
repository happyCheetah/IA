//
//  ClassViewController.swift
//  LoginDemo
//
//  Created by Matthew Guo on 10/01/2021.
//

import UIKit
import FirebaseFirestore
import Firebase

class ClassViewController: UIViewController, UITextFieldDelegate {

    //*** IB OUTLET ***//
    @IBOutlet weak var sliderText: UILabel!
    @IBOutlet weak var slider: UISlider!
    @IBOutlet weak var sliderSendButton: UIButton!
    @IBOutlet weak var feedbackTextField: UITextField!
    @IBOutlet weak var feedbackSendButton: UIButton!
    @IBOutlet weak var thumbsSegmentedControl: UISegmentedControl!
    @IBOutlet weak var thumbsSendButton: UIButton!
    
    var uid : String?
    var classID: String?
    var className: String?
    
    init(classID: String) {
        self.classID = classID
        super.init(nibName: nil, bundle: nil)
    }
    
    init(className: String){
        self.className = className
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        feedbackSendButton.isEnabled = false
        
        uid = Auth.auth().currentUser?.uid
        

    }
    
    //*** FUNCTIONS ***//
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }
    
    //*** IB ACTION ***//
    @IBAction func sliderSlided(_ sender: Any) {
        var value = slider.value
        value = round(10*value)
        sliderText.text = "\(value)"
        
    }
    
    @IBAction func sliderSendTapped(_ sender: Any) {
        var value = slider.value
        value = round(10*value)
        
        let db = Firestore.firestore()
        print("passed")
        print(value)
//        db.collection("classes").document("5AMKh8fCIFpWTCxnNCYW").setData(["test": "test"])
        db.collection("classes").document(classID as! String).setData(["session": [uid : ["\(value)", "nil", "nil"]]], merge: true) { err in
            print("passed")
            if let err = err {
                    print("Error updating document: \(err)")
                } else {
                    print("Document successfully updated")
                }
        }
    }
    
    @IBAction func emojiSendTapped(_ sender: Any) {
        //which emoji is selected
        var emoji = "👍"
        
        switch thumbsSegmentedControl.selectedSegmentIndex {
        case 0:
            emoji = "👍"
        case 1:
            emoji = "👎"
        default: break
        }
        
        //send chosen emoji to firebase
        Firestore.firestore().collection("classes").document(classID as! String).setData(["session": [uid : ["nil", emoji, "nil"]]], merge: true ) { err in
            if let err = err {
                    print("Error updating document: \(err)")
                } else {
                    print("Document successfully updated")
                }
        } 
    }
}
