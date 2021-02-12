//
//  JoinClassViewController.swift
//  LoginDemo
//
//  Created by Matthew Guo on 15/01/2021.
//

import UIKit
import Firebase

class JoinClassViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {

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
    
    //*** FUNCTIONS ***//
    func getClassNames() {
        
        // query firebase for all documents in classes collection
        let classes = Firestore.firestore().collection("classes").getDocuments { (querySnapshot, error) in
            
            //iterate for each document
            if error == nil && querySnapshot != nil {
                for document in querySnapshot!.documents {
                    let documentData = document.data()
                  
                    self.pickerData.append(document["className"] as! String)
                    self.classIDs.append(document.documentID)
                }
            }
            self.classPicker.reloadAllComponents()
            print(self.pickerData)
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
    
    @IBAction func joinClassTapped(_ sender: Any) {
        
        //get current selection from pickerview
        let selected = classPicker.selectedRow(inComponent: 0)
        let classID = classIDs[selected]
        
        Firestore.firestore().collection("classes").document(classID).updateData(["students": FieldValue.arrayUnion([uid as! String])])
    }
}


