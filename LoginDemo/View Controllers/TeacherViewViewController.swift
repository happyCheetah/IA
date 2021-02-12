//
//  TeacherViewViewController.swift
//  LoginDemo
//
//  Created by Matthew Guo on 12/01/2021.
//

import UIKit
import FirebaseFirestore

class TeacherViewViewController: UIViewController {

    @IBOutlet weak var averageSlider: UISlider!
    @IBOutlet weak var sliderAverageLabel: UILabel!
    @IBOutlet weak var thumbsUpLabel: UILabel!
    @IBOutlet weak var thumbsDownLabel: UILabel!
    
    //https://www.youtube.com/watch?v=oeXgHKhXxdQ&feature=emb_title&ab_channel=JohnGallaugher firestore listener
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addSnapShotListener()
        averageSlider.isEnabled = false
    }
    
    func addSnapShotListener() {
        Firestore.firestore().collection("classes").document("5AMKh8fCIFpWTCxnNCYW").addSnapshotListener { (documentSnapshot, error) in
            guard let document = documentSnapshot else {
                print("Error: \(error!)")
                return
            }
            guard let data = document.data() else {
                print("Document empty")
                return
            }
            print(data)
            
            //unpack data
            let session = data["session"] as! NSDictionary
            var sliderValueArray:[String] = []
            var emojiArray:[String] = []
            
            for (key, value) in session {
                //compile all the tings of index 0
                let studentID = session[key] as! NSArray
                let zeroth = studentID[0] as! String
                let first = studentID[1] as! String
                
                if zeroth != "nil" {
                    //meaninful content is slider
                    //convert string to double
                    if zeroth == "👍" || zeroth == "👎" { emojiArray.append(zeroth) }
                    else { sliderValueArray.append(zeroth) }
                    
                }
                else {
                    //meaningful content is text
                    if first == "👍" || first == "👎" { emojiArray.append(first) }
                    else { sliderValueArray.append(first) }
                }
            }
            
            //compute slider
            var numbers:[Float] = []
            if sliderValueArray.count != 0 {
                for i in sliderValueArray {
                    print("I is : \(i)")
                    numbers.append(Float(i)!)
                }
                
                var average = Float(0)
                
                for x in numbers {
                    average = average + x
                }
                let length = Float(numbers.count)
                average = average / (length)
                self.sliderAverageLabel.text = "\(average)"
                self.averageSlider.setValue(average, animated: true)
                
            }
            
            
            //compute emoji
            var thumbsUpCount = 0
            var thumbsDownCount = 0
            
            for emoji in emojiArray {
                if emoji == "👍" {
                    thumbsUpCount = thumbsUpCount + 1
                }
                else
                {
                    thumbsDownCount = thumbsDownCount + 1
                }
            }
            self.thumbsUpLabel.text = "# 👍 is \(thumbsUpCount)"
            self.thumbsDownLabel.text = "# 👎 is \(thumbsDownCount)"
        }
    }
}
