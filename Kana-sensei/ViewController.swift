//
//  ViewController.swift
//  Kana-sensei
//
//  Created by Seth Schalinske on 4/8/18.
//  Copyright © 2018 Seth Schalinske. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    var question = 0
    var answerPlacement:UInt32 = 0
    var r = 0
    var choices = [Int]()
    var streakCount = 0
    var button:UIButton = UIButton()
    var delayInSeconds = 0.0
    
    let kana = ["あ", "か", "さ", "た", "な", "は", "ま", "や", "ら", "わ"]
    let romaji = ["a", "ka", "sa", "ta", "na", "ha", "ma", "ya", "ra", "wa"]
    
    // Labels
    @IBOutlet weak var lbl: UILabel!
    @IBOutlet weak var streak: UILabel!
    
    // Buttons
    @IBOutlet weak var button1: UIButton!       // Button Outlets (so border radius can be applied)
    @IBOutlet weak var button2: UIButton!
    @IBOutlet weak var button3: UIButton!
    @IBOutlet weak var button4: UIButton!
    
    // action handler
    @IBAction func buttonTap(_ sender: UIButton) {
        
        if (sender.tag == answerPlacement + 1) {                                                        // If correct
            streakCount += 1                                                                            // Increment streak
            view.backgroundColor = UIColor(red: 165/255, green: 1, blue: 75/255, alpha: 1)              // Make background Green
            delayInSeconds = 0.5                                                                        // shorter delay in between questions
        } else {                                                                                        // else
            streakCount = 0                                                                             // reset streak
            view.backgroundColor = UIColor(red: 1, green: 65/255, blue: 65/255, alpha: 1)               // Make background Red
            button = view.viewWithTag(Int(answerPlacement) + 1) as! UIButton                            // Get right button
            button.backgroundColor = UIColor(red: 165/255, green: 1, blue: 75/255, alpha: 1)            // Highlight the right button

            delayInSeconds = 2.0                                                                        // Set delay to review wrong answer
        }
        
        streak.text = "Streak: " + String(streakCount)                                                  // Set the Streak label
        
        question = Int(arc4random_uniform(UInt32(kana.count)))                                          // Randomly pick a new question
        
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + delayInSeconds) {                  // Delay inside code
            
            self.button.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0)                  // change button background color back
            self.view.backgroundColor = UIColor(red: 185/255, green: 245/255, blue: 255/255, alpha: 1)   // reset background color

            if (self.question < self.kana.count) {                                                      // if the random question is a valid index
                self.nextQuestion()                                                                     // call nextQuestion
            } else {                                                                                    // else
                self.question = 0                                                                       // default to question 0
                self.nextQuestion()                                                                     // and call next question
            }
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        nextQuestion()
        
        button1.layer.cornerRadius = 10                                 // Set Border Radius
        button2.layer.cornerRadius = 10
        button3.layer.cornerRadius = 10
        button4.layer.cornerRadius = 10
    }
    
    
    func nextQuestion() {
        
        lbl.text = kana[question]                                       // Set Label to Question with index question
        
        answerPlacement = arc4random_uniform(4)                         // Pick Correct Answer Placement in Choices Array to be 0 - 3
        
        while choices.count < 4 {                                       // while we have less than 4 numbers in our choices array
            if (choices.count == Int(answerPlacement)) {                // If our choices array is at the correct answer position
                choices.append(question)                                // Set the number at this position in the choices array to the index of the correct answer
            } else {
                r = Int(arc4random_uniform(UInt32(romaji.count)))       // pick a random index from the romaji array
                if (!choices.contains(r) && r != question) {            // If that index has not already been added to the array
                    choices.append(r)                                   // Add the index to the choices array
                }
            }                                                           // If we have not arrived at the right answer placement and chose an r that already exists in choices,
        }                                                               // choices.count will not have increased. Thus the while loop will continue.
                                                                        // At this point the choices array has been filled.
        for i in 1...4 {                                                // Time to add the options to the buttons.
            button = view.viewWithTag(i) as! UIButton                   // Create a button
            button.setTitle(romaji[choices[ i - 1 ]], for: .normal)     // Set the button title to the string in the romaji array with a value of choices[ i - 1 ]
        }
        
        choices.removeAll()                                             // reset choices array
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

