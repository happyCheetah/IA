//
//  HomeViewController.swift
//  LoginDemo
//
//  Created by Matthew Guo on 19/12/2020.
//

import UIKit
import Firebase

class HomeViewController: UIViewController {
    
    //*** IB OUTLET ***//
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var reloadButton: UIButton!
    @IBOutlet weak var enrollButton: UIButton!
    @IBOutlet weak var addClassButton: UIButton!
    
    //*** VARS ***//
    var classes: [Class] = []
    var isTeacher: Bool?
    var lastName: String?
    var userID: String?
    var className : String?
    // classID is the name of a class's document - assigned automatically by Firestore
    var classID : String?
    var classIDArray: [String] = []
    
    //*** View Functions ***//
    override func viewDidLoad() {
        super.viewDidLoad()
        userID = Auth.auth().currentUser?.uid
        loadStatus()
        loadClasses()
    }
    
    override func viewDidAppear(_ animated: Bool) {
    }
    
    //*** IB ACTION ***//
    @IBAction func reloadTapped(_ sender: Any) {
        loadStatus()
        loadClasses()
    }
    
    //*** FUNCTIONS ***//

    
    /* A setter function for the classID variable. */
    public func setClassID(newClassID : String) -> Void {
        self.classID = newClassID
    }
    
    func loadStatus() {
        //Query Firestore for user's document
        Firestore.firestore().collection("users").document(userID!).getDocument { (document, error) in
            //If Firestore returns an error.
            if error != nil {
                print(error!)
                return
            }
            else {
                let dataDescription = document?.data()
                //Identify if user is student or teacher
                let status = dataDescription!["status"] as? String ?? "0"
                if status == "0" {
                    self.isTeacher = false
                    self.addClassButton.isHidden = true
                }
                else {
                    self.isTeacher = true
                    self.enrollButton.isHidden = true
                }
            }
        }
    }
    
    func loadClasses(){
        // Clear variables of data from previous call of loadClasses()
        classes = []
        classIDArray = []
        
        // Query Firestore for class documents that are associated with current user
        Firestore.firestore().collection("classes").whereField("participants", arrayContains: userID!).getDocuments { (querySnapshot, error) in
            if let error = error {
                print("Error was:  \(error)")
                return
            }
            else {
                guard let snap = querySnapshot else {
                    return
                }
                // snap.documents is an array containing multiple class documents that we know to be associated with the current user. Data from each document is stored in variables, which are in turn used to instantiate a Class object. The class object is appended to classes:[Class] array, which will populate the table view.
                for classDocument in snap.documents {
                    let classData = classDocument.data()
                    self.classID = classDocument.documentID

                    let currentClassTeacherName = classData["teacherName"] as? String ?? "FIELDNOTPRESENT"
                    self.className = classData["className"] as? String ?? "FIELDNOTPRESENT"

                    let currentClass = Class.init(teacherName: currentClassTeacherName, className: self.className!)
           
                    self.classes.append(currentClass)
                    self.classIDArray.append(classDocument.documentID)
                }
            }
            self.tableView.reloadData()
        }
    }

    /* Function that sends data to next view controller with a segue */
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "homeToClass" {
            guard let classVC = segue.destination as? ClassViewController else { return }
            classVC.classID = self.classID
            classVC.title = className
        }
        
        if segue.identifier == "homeToCreate" {
            guard let createVC = segue.destination as? CreateClassViewController else { return }
            createVC.uid = self.userID
        }
        
        if segue.identifier == "homeToJoin" {
            guard let joinVC = segue.destination as? EnrollinClassViewController else { return }
            joinVC.uid = self.userID
        }
        
        if segue.identifier == "homeToTeach" {
            guard let teachVC = segue.destination as? TeacherViewViewController else { return }
            teachVC.classID = self.classID
            teachVC.title = className
        }
    }
}

extension HomeViewController: UITableViewDataSource, UITableViewDelegate {
    /* code below comes from video: https://www.youtube.com/watch?v=1HN7usMROt8&ab_channel=CodeWithChris */
    
    //the number of rows should be the number of classes the student is enrolled in
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return classes.count
    }
    
    //this is called everytime a new cell appears.
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //get the current class to be displayed. e.g. classes[0]
        let klass = classes[indexPath.row]
        
        //each cell is of type ClassCell
        let cell = tableView.dequeueReusableCell(withIdentifier: "ClassCell") as! ClassCell
        
        //populate labels and button in this cell
        cell.setCell(cell: klass)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        className = classes[indexPath.row].className
        classID = classIDArray[indexPath.row]
        
        if isTeacher == false {
            performSegue(withIdentifier: "homeToClass", sender: self)
        }
        else {
            performSegue(withIdentifier: "homeToTeach", sender: self)
        }
    }
}
