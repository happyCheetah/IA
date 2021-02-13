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
        Firestore.firestore().collection("users").document(userID!).getDocument { (document, error) in
            if error != nil {
                print(error!)
                return
            }
            else {
                let dataDescription = document?.data()
                //identify if user is student or teacher
                let status = dataDescription!["status"] as? String ?? "0"
                if status == "0" {
                    print(">>>> UI FOR STUDENT")
                    self.isTeacher = false
                    self.addClassButton.isHidden = true
                }
                else {
                    print(">>>> UI FOR TEACHER")
                    self.isTeacher = true
                    self.joinClassButton.isHidden = true
                }
            }
        }
    }
    
    func loadClasses(){
        classes = []
        classIDArray = []
//        let user = Auth.auth().currentUser
//        let uid = user?.uid ?? "GpNGDPCK3ZN7hKlQJvzzkdgHPci1"
        Firestore.firestore().collection("classes").whereField("participants", arrayContains: userID!).getDocuments { (querySnapshot, error) in
            // http://www.swiftarchive.org/optional-binding-if-let-x-x-td409.html explanation of if let x = x
            if let error = error {
                print("Error was:  \(error)")
                return
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
                    self.className = classData["className"] as? String ?? "FIELDNOTPRESENT"

                    let currentClass = Class.init(teacherName: currentClassTeacherName, className: self.className!)
           
                    self.classes.append(currentClass)
                    self.classIDArray.append(classDocument.documentID)
                }
            }
            self.tableView.reloadData()
        }
    }
    
    
    
//    /* A function that sets up UI elements and retrieves classes associated with user from Firebase. Classes stored in 'classes: [Class]'  */
//    func loadMyClasses() {
//        // clear array that may have data from a previous call.
//        classes = []
//        let user = Auth.auth().currentUser
//        let uid = user?.uid ?? "GpNGDPCK3ZN7hKlQJvzzkdgHPci1"
//
//        //query for current user's document
//        Firestore.firestore().collection("users").document(uid).getDocument { (document, error) in
//            if error != nil {
//                print(error!)
//                return
//            }
//            else {
//                let dataDescription = document?.data()
//                //identify if user is student or teacher
//                let status = dataDescription!["status"] as? String ?? "0"
//                if status == "0" {
//                    self.isTeacher = false
//                }
//                else {
//                    self.isTeacher = true
//                }
//
//                // Asynchronous queries: https://firebase.googleblog.com/2018/07/swift-closures-and-firebase-handling.html
//                Firestore.firestore().collection("classes").whereField("students", arrayContains: uid).getDocuments { (querySnapshot, error) in
//                    // http://www.swiftarchive.org/optional-binding-if-let-x-x-td409.html explanation of if let x = x
//                    if let error = error {
//                        print("Error was:  \(error)")
//                        return
//                    }
//                    else {
//                        // Using optional binding to ensure that querySnapshot references something https://www.youtube.com/watch?v=bWqxRBxI51Q&ab_channel=totaltraining
//                        guard let snap = querySnapshot else {
//                            return
//                        }
//                        // snap.documents is an array containing multiple class documents. Each class is associated with the user. Data is extracted from each document and used to instantiate a Class object. The class object is appended to classes:[Class] array.
//                        for classDocument in snap.documents {
//                            let classData = classDocument.data()
//                            self.classID = classDocument.documentID
//                            //cast type 'any'. if we get nil, supplied "err" as default value
//                            let currentClassTeacherName = classData["teacherName"] as? String ?? "FIELDNOTPRESENT"
//                            self.className = classData["className"] as? String ?? "FIELDNOTPRESENT"
//
//                            let currentClass = Class.init(teacherName: currentClassTeacherName, className: self.className!)
//
//                            self.classes.append(currentClass)
//                            self.classIDArray.append(classDocument.documentID)
//                        }
//                    }
//                    self.tableView.reloadData()
//                }
//            }
//        }
//    }

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
            guard let teachVC = segue.destination as? TeacherViewViewController else {return}
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
