//
//  ClassCell.swift
//  LoginDemo
//
//  Created by Matthew Guo on 27/12/2020.
//

import UIKit

class ClassCell: UITableViewCell {

    //*** IB OUTLETS ***//
    @IBOutlet weak var className: UILabel!
    @IBOutlet weak var teacherName: UILabel!
    @IBOutlet weak var startSessionButton: UIButton!
    @IBOutlet weak var joinSessionButton: UIButton!
    
    //*** FUNCTIONS ***//
    func setCell(cell: Class) {
        self.teacherName.text = cell.teacherName
        self.className.text = cell.className
        
        self.joinSessionButton.isHidden = true
        self.startSessionButton.isHidden = true
        
        if cell.displayForTeacher == "0" {
            //setup UI for student
//            self.joinSessionButton.isHidden = false
            
        }
        else {
            //setup UI for teacher
//            self.isUserInteractionEnabled = 
//            self.startSessionButton.isHidden = false
        }
    }
    
    @IBAction func joinSessionTapped(_ sender: Any) {
        print("className is >>> \(className.text)")
//        let classVC = ClassViewController.init(className: className.text!)
        

    }
    
}


