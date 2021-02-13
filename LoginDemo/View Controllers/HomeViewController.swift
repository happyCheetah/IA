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
    @IBOutlet weak var joinClassButton: UIButton!
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
        let user = Auth.auth().currentUser
        userID = user?.uid ?? "GpNGDPCK3ZN7hKlQJvzzkdgHPci1"
        
        loadLastName()
        loadClasses()
    }
    
    override func viewDidAppear(_ animated: Bool) {
    }
    
    //*** IB ACTION ***//
    @IBAction func reloadTapped(_ sender: Any) {
        loadClasses()
    }
    
    //*** FUNCTIONS ***//
    
    
    func loadLastName() {
        let user = Auth.auth().currentUser
        let uid = user?.uid ?? "GpNGDPCK3ZN7hKlQJvzzkdgHPci1"
        print("loadLastName(): uid: \(uid)")
        let userDocument = Firestore.firestore().collection("users").document(uid)
        userDocument.getDocument { (document, error) in
            let dataDescription = document?.data()
            
            self.lastName = dataDescription!["lastname"] as? String ?? "Guo"
        }
    }
    
    func loadClassView(className: String) {
        
    }
    
    /* A setter function for the classID variable. */
    public func setClassID(newClassID : String) -> Void {
        self.classID = newClassID
    }
    
    /* A function that sets up UI elements and retrieves classes associated with user from Firebase. Classes stored in 'classes: [Class]'  */
    func loadClasses() {
        // clear array that may have data from a previous call.
        // a default classID is provided
        // create a reference to the document in Firestore of user. Document name is the user ID.
        classes = []
        let user = Auth.auth().currentUser
        let uid = user?.uid ?? "GpNGDPCK3ZN7hKlQJvzzkdgHPci1"
    
        
        //query for current user's document
        Firestore.firestore().collection("users").document(uid).getDocument { (document, error) in
            if error != nil {
                print(error!)
            }
            else {
                let dataDescription = document?.data()
                
                //modify 'isTeacher' and 'status'
                let status = dataDescription!["status"] as? String ?? "0"
                
                if status == "0" {
                    self.isTeacher = false
                    self.addClassButton.isHidden = true
                }
                else {
                    self.isTeacher = true
                    self.joinClassButton.isHidden = true
                }
                
                // Asynchronous queries: https://firebase.googleblog.com/2018/07/swift-closures-and-firebase-handling.html
                Firestore.firestore().collection("classes").whereField("students", arrayContains: uid).getDocuments { (querySnapshot, error) in
                    // http://www.swiftarchive.org/optional-binding-if-let-x-x-td409.html explanation of if let x = x
                    if let error = error {
                        print("Error was:  \(error)")
                    }
                    else {
                        // Using optional binding to ensure that querySnapshot references something https://www.youtube.com/watch?v=bWqxRBxI51Q&ab_channel=totaltraining
                        guard let snap = querySnapshot else {
                            return
                        }
                        // snap.documents is an array containing multiple class documents. Each class is associated with the user. Data is extracted from each document and used to instantiate a Class object. The class object is appended to classes:[Class] array.
                        for classDocument in snap.documents {
                            let classData = classDocument.data()
                            self.classID = classDocument.documentID
                            //cast type 'any'. if we get nil, supplied "err" as default value
                            let currentClassTeacherName = classData["teacherName"] as? String ?? "FIELDNOTPRESENT"
//                            let currentClassName = classData["className"] as? String ?? "FIELDNOTPRESENT"
                            self.className = classData["className"] as? String ?? "FIELDNOTPRESENT"

                            let currentClass = Class.init(teacherName: currentClassTeacherName, className: self.className!, displayForTeacher: status)
                   
                            self.classes.append(currentClass)
                            self.classIDArray.append(classDocument.documentID)
                        }
                    }
                    self.tableView.reloadData()
                }
                /* async block end */
            }
        }
    }

    /* Function that sends data to next view controller with a segue */
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "homeToClass" {
            guard let classVC = segue.destination as? ClassViewController else { return }
            classVC.classID = self.classID
            classVC.title = className
            print("CLASSNAME >> \(className), CLASSID >> \(classID)")
        }
        
        if segue.identifier == "homeToCreate" {
            guard let createVC = segue.destination as? CreateClassViewController else { return }
            createVC.teacherName = self.lastName
            createVC.uid = self.userID
        }
        
        if segue.identifier == "homeToJoin" {
            guard let joinVC = segue.destination as? EnrollinClassViewController else { return }
            joinVC.uid = self.userID
        }
        
        if segue.identifier == "homeToTeach" {
            guard let teachVC = segue.destination as? TeacherViewViewController else {return}
            teachVC.classID = self.classID
            teachVC.title = className
            print("CLASSNAME >> \(className), CLASSID >> \(classID)")
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
