//
//  JoinClassViewController.swift
//  LoginDemo
//
//  Created by Matthew Guo on 15/01/2021.
//

import UIKit
import Firebase

class EnrollinClassViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {

    //*** IB OUTLET ***//
    @IBOutlet weak var classPicker: UIPickerView!
    
    //*** VARS ***//
    var uid: String?
    var pickerData: [String] = [String]()
    var classIDs: [String] = [String]()

    override func viewDidLoad() {
        super.viewDidLoad()

        self.classPicker.delegate = self
        self.classPicker.dataSource = self
        getClassNames()
    }
    
    //*** IB OUTLETS ***///
    @IBAction func joinClassTapped(_ sender: Any) {
        //get current selection from pickerview
        let selected = classPicker.selectedRow(inComponent: 0)
        let classID = classIDs[selected]

        //check if student has already joined by querying students array
        Firestore.firestore().collection("classes").document(classID).getDocument { (document, error) in
            let data = document?.data()
            let studentArray = data!["students"] as! NSArray
            if studentArray.contains(self.uid!) {
                //Display alert
                let alreadyEnrolledDialogMessage = UIAlertController(title: "Already Enrolled!", message: "You are already enrolled in this class!", preferredStyle: .alert)
                let ok = UIAlertAction(title: "Got it!", style: .default, handler: nil)
                alreadyEnrolledDialogMessage.addAction(ok)
                self.present(alreadyEnrolledDialogMessage, animated: true, completion: nil)
                return
            }
            else {
                //Add student to chosen class's student list
                Firestore.firestore().collection("classes").document(classID).updateData(["students": FieldValue.arrayUnion([self.uid!])])
                //Display alert acknowledging enrollement
                let enrolledDialogMessage = UIAlertController(title: "Enrolled!", message: "Please go back to My Classes and Reload.", preferredStyle: .alert)
                let ok = UIAlertAction(title: "Got it!", style: .default, handler: nil)
                enrolledDialogMessage.addAction(ok)
                self.present(enrolledDialogMessage, animated: true, completion: nil)
            }
        }
    }
    
    
    //*** FUNCTIONS ***//
    func getClassNames() {
        // query firebase for all documents in classes collection
        Firestore.firestore().collection("classes").getDocuments { (querySnapshot, error) in
            //iterate through each class document in 
            if error == nil && querySnapshot != nil {
                for document in querySnapshot!.documents {
                
                    self.pickerData.append(document["className"] as! String)
                    self.classIDs.append(document.documentID)
                }
            }
            self.classPicker.reloadAllComponents()
        } 
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return pickerData.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return pickerData[row]
    }
}


