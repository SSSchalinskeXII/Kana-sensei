//
//  ViewController.swift
//  Kana-sensei
//
//  Created by Seth Schalinske on 4/8/18.
//  Copyright © 2018 Seth Schalinske. All rights reserved.
//

import UIKit

var script = "Hiragana"
var subset = "All"

class ViewController: UIViewController {
    
    var question = 0
    var answerPlacement:UInt32 = 0
    var r = 0
    var choices = [String]()
    var streakCount = 0
    var button:UIButton = UIButton()
    var delayInSeconds = 0.0
    var lower = 0
    var upper = 1
    
    let hiragana = ["ん",                                                                                    // 0
                    "あ", "か", "さ", "た", "な", "は", "ま", "や", "ら", "わ", "が", "ざ", "だ", "ば", "ぱ",      // 1-15
                    "い", "き", "し", "ち", "に", "ひ", "み", "り", "ゐ", "ぎ", "じ", "ぢ", "び", "ぴ",           // 16-29
                    "う", "く", "す", "つ", "ぬ", "ふ", "む", "ゆ", "る", "ぐ", "ず", "づ", "ぶ", "ぷ",           // 30-43
                    "え", "け", "せ", "て", "ね", "へ", "め", "れ", "ゑ", "げ", "ぜ", "で", "べ", "ぺ",           // 44-57
                    "お", "こ", "そ", "と", "の", "ほ", "も", "よ", "ろ", "を", "ご", "ぞ", "ど", "ぼ", "ぽ"]      // 58-72
    
    let katakana = ["ン",
                    "ア", "カ", "サ", "タ", "ナ", "ハ", "マ", "ヤ", "ラ", "ワ", "ガ", "ザ", "ダ", "バ", "パ",
                    "イ", "キ", "シ", "チ", "ニ", "ヒ", "イ", "リ", "ヰ", "ギ", "ジ", "ヂ", "ビ", "ピ",
                    "ウ", "ク", "ス", "ツ", "ヌ", "フ", "ム", "ユ", "ル", "グ", "ズ", "ヅ", "ブ", "プ",
                    "エ", "ケ", "セ", "テ", "ネ", "ヘ", "メ", "レ", "ヱ", "ゲ", "ゼ", "デ", "ベ", "ペ",
                    "オ", "コ", "ソ", "ト", "ノ", "ホ", "モ", "ヨ", "ロ", "ヲ", "ゴ", "ゾ", "ド", "ボ", "ポ"]
    
    var kana = [String]()
    let romaji = ["n",
                  "a", "ka",  "sa",  "ta", "na", "ha", "ma", "ya", "ra", "wa", "ga", "za", "da", "ba", "pa",
                  "i", "ki", "shi", "chi", "ni", "hi", "mi", "ri", "wi", "gi", "ji", "ji", "bi", "pi",
                  "u", "ku",  "su", "tsu", "nu", "fu", "mu", "yu", "ru", "gu", "zu", "zu", "bu", "pu",
                  "e", "ke",  "se",  "te", "ne", "he", "me", "re", "we", "ge", "ze", "de", "be", "pe",
                  "o", "ko",  "so",  "to", "no", "ho", "mo", "yo", "ro", "wo", "go", "zo", "do", "bo", "po"]
    
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
            self.view.backgroundColor = UIColor(red: 185/255, green: 245/255, blue: 255/255, alpha: 1)  // reset background color

            if (self.question < self.kana.count) {                                                      // if the random question is a valid index
                self.nextQuestion()                                                                     // call nextQuestion
            } else {                                                                                    // else
                self.question = 0                                                                       // default to question 0
                self.nextQuestion()                                                                     // and call next question
            }
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        kana.removeAll()                                                // Clear kana array
        questionSelector()                                              // Set Question bank in kana array
        
        nextQuestion()                                                  // Call next question
        
        button1.layer.cornerRadius = 10                                 // Set Border Radius
        button2.layer.cornerRadius = 10
        button3.layer.cornerRadius = 10
        button4.layer.cornerRadius = 10
    }
    
    func questionSelector() {
        
        switch(subset) {
        case "All":
            lower = 0
            upper = romaji.count
            if script == "Katakana" {
                kana = katakana                                         // Set kana to all katakana
            } else {
                kana = hiragana                                         // Set kana to all hiragana
            }
            break
        case "A":                                                       // Case A
            lower = 1
            upper = 15
            setKana()                                                   // Call scriptIndex to set kana to a subset of katakana or hiragana
            break
        case "I":                                                       // Case I
            lower = 16
            upper = 29
            setKana()                                                   // Call scriptIndex to set kana to a subset of katakana or hiragana
            break
        case "U":                                                       // Case U
            lower = 30
            upper = 43
            setKana()                                                   // Call scriptIndex to set kana to a subset of katakana or hiragana
            break
        case "E":                                                       // Case E
            lower = 44
            upper = 57
            setKana()                                                   // Call scriptIndex to set kana to a subset of katakana or hiragana
            break
        case "O":                                                       // Case O
            lower = 58
            upper = 72
            setKana()                                                   // Call scriptIndex to set kana to a subset of katakana or hiragana
            break
        default:
            lower = 0
            upper = romaji.count
            kana = hiragana                                             // Default to all hiragana
            break
        }
    }
    
    func setKana() {
        for scriptIndex in lower...upper {                              // For the given range
            if script == "Katakana" {
                kana.append(katakana[scriptIndex])                      // Set corresponding katakana
            } else {
                kana.append(hiragana[scriptIndex])                      // Set corresponding hiragana
            }
        }
    }
    
    func nextQuestion() {
        
        lbl.text = kana[question]                                                       // Set Label to Question with index question
        
        answerPlacement = arc4random_uniform(4)                                         // Pick Correct Answer Placement in Choices Array to be 0 - 3
        
        while choices.count < 4 {                                                       // while we have less than 4 numbers in our choices array
            if (choices.count == Int(answerPlacement)) {                                // If our choices array is at the correct answer position
                choices.append(romaji[question + lower])                                // Set the number at this position in the choices array to the index of the correct answer
            } else {
                r = Int(arc4random_uniform(UInt32(upper - lower))) + lower              // pick a random index from the romaji array within the given range
                let ra = romaji[r]
                if (!choices.contains(ra) && romaji[r] != romaji[question + lower]) {   // If that index has not already been added to the array
                    choices.append(romaji[r])                                           // Add the index to the choices array
                }
            }                                                                           // If we have not arrived at the right answer placement and chose an r that already exists in choices,
        }                                                                               // choices.count will not have increased. Thus the while loop will continue.
                                                                                        // At this point the choices array has been filled.
        for i in 1...4 {                                                                // Time to add the options to the buttons.
            button = view.viewWithTag(i) as! UIButton                                   // Create a button
            button.setTitle(choices[ i - 1 ], for: .normal)                             // Set the button title to the string in the romaji array with a value of choices[ i - 1 ]
        }
        choices.removeAll()                                                             // reset choices array
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

class MenuViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {
    let pickerViewChoices = ["All", "A", "I", "U", "E", "O"]                                                    // Define PickerView Choices
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return pickerViewChoices[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return pickerViewChoices.count
    }
    
    @IBOutlet weak var scriptPicker: UISegmentedControl!
    @IBAction func scriptPicker(_ sender: Any) {
        script = scriptPicker.titleForSegment(at: scriptPicker.selectedSegmentIndex)!       // Change script to segmentedControll selected string
    }
    
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        subset = pickerViewChoices[row]                                                     // Change subset to pickerView selected string
    }
}

