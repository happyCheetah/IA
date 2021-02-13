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
    
    var classID: String?
    var className: String?
    
    //https://www.youtube.com/watch?v=oeXgHKhXxdQ&feature=emb_title&ab_channel=JohnGallaugher firestore listener
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addSnapShotListener()
        averageSlider.isEnabled = false
    }
    
    func addSnapShotListener() {
        Firestore.firestore().collection("classes").document(classID!).addSnapshotListener { (documentSnapshot, error) in
            /* Code below will execute when any data in current document in changed */
            var sliderValueArray:[String] = []
            var emojiArray:[String] = []
            
            guard let document = documentSnapshot else {
                print("Error: \(error!)")
                return
            }
            guard let data = document.data() else {
                print("Document empty")
                return
            }

            let feedbackDictionary = data["feedback"] as! NSDictionary
            for (key, _) in feedbackDictionary {
                //compile all the tings of index 0
                let studentFedbackArray = feedbackDictionary[key] as! NSArray
                let feedbackAtZerothIndex = studentFedbackArray[0] as! String
                let feedbackAtFirstIndex = studentFedbackArray[1] as! String
                
                // When the class is first created, a feedback of array of ['nil','nil'] is used to instantiate the map, and should be ignored in this calculation
                if feedbackAtZerothIndex == "nil" && feedbackAtFirstIndex == "nil" {
                    continue
                }
                // Only one type of feedback per student is stored by the server. Of the two index array, we must find which index stores the feedback. Slider values are always written to the zeroth index, while emojis are written to the first index.
                // Case for value being slider value
                else if feedbackAtZerothIndex != "nil" {
                    sliderValueArray.append(feedbackAtZerothIndex)
                }
                // Case for value being emoji
                else if feedbackAtFirstIndex == "👍" || feedbackAtFirstIndex == "👎"  {
                    emojiArray.append(feedbackAtFirstIndex)
                }
            }
            self.computeSliderAverage(sliderValueArray: sliderValueArray)
            self.computeEmoji(emojiArray: emojiArray)
        }
    }
    
    func computeEmoji(emojiArray: [String]) {
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
    
    func computeSliderAverage(sliderValueArray: [String]) {
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
    }
    
}
