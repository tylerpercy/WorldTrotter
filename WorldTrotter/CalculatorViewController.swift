//
//  CalculatorViewController.swift
//  WorldTrotter
//
//  Created by Tyler Percy and Logan Mayo on 2/26/19.
//  Copyright © 2019 Tyler Percy. All rights reserved.
//

import UIKit

class CalculatorViewController : UIViewController {
    @IBOutlet var num1Label: UILabel!
    @IBOutlet var num2Label: UILabel!
    @IBOutlet var symbolLabel: UILabel!
    @IBOutlet var scoreLabel: UILabel!
    @IBOutlet var questionLabel: UILabel!
    @IBOutlet var answerField: UITextField!
    
    var questionNumber = 0
    var scoreNumber = 0
    var answerChecked: Bool!
    
    func generateRandomNumber(min: Int, max: Int) -> Int {
        let result = Int(arc4random_uniform(UInt32(max - min + 1))) + min
        return result
    }
    
    func insertRandomNumbers() {
        let rand1 = generateRandomNumber(min: -10, max: 20)
        num1Label.text = String(rand1)
        
        let rand2 = generateRandomNumber(min: -10, max: 20)
        num2Label.text = String(rand2)
        
        if rand1 == 0 || rand2 == 0 {
            insertRandomNumbers()
        }
    }
    
    func insertSymbol() {
        let symbolArray = ["+", "-", "*", "÷"]
        let randomIndex = Int(arc4random_uniform(UInt32(symbolArray.count)))
        symbolLabel.text = symbolArray[randomIndex]
    }
    
    func calculateAnswer() -> Int {
        var answer: Int?
        if symbolLabel.text == "+" {
            answer = doMath(Int(num1Label.text!)!, Int(num2Label.text!)!, "+")
        }
        else if symbolLabel.text == "-" {
            answer = doMath(Int(num1Label.text!)!, Int(num2Label.text!)!, "-")
        }
        else if symbolLabel.text == "*" {
            answer = doMath(Int(num1Label.text!)!, Int(num2Label.text!)!, "*")
        }
        else if symbolLabel.text == "÷" {
           answer = doMath(Int(num1Label.text!)!, Int(num2Label.text!)!, "/")
        }
        print (answer!)
        return answer!
    }
 
    
    func add(_ a: Int, _ b: Int) -> Int {
        return a+b
    }
    func sub(_ a: Int, _ b: Int) -> Int {
        return a-b
    }
    func mul(_ a: Int, _ b: Int) -> Int {
        return a*b
    }
    func div(_ a: Int, _ b: Int) -> Int {
        if b != 0 {
            return a/b
        } else {
            return 0
        }
    }
    
    func doMath(_ a: Int, _ b: Int, _ op: String) -> Int {
        typealias binOp = (Int, Int) -> Int
        var ops: [String: binOp] = ["+": add, "-": sub, "*": mul, "/": div]
        let opFunc = ops[op]
        return opFunc!(a,b)
    }
    
    @IBAction func checkAnswer(_ sender: UIButton) {
        guard questionNumber > 9 else {
            if answerField.text == String(calculateAnswer()) {
                scoreNumber += 1
                scoreLabel.text = String(scoreNumber)
                showAlertTrue()
            } else {
                showAlertFalse()
            }
            
            questionNumber += 1
            questionLabel.text = String(questionNumber)
            answerChecked = true
            
            return
        }
    }
    
    @IBAction func nextQuestion(_ sender: UIButton) {
        guard answerChecked != true else {
            if questionNumber < 10 {
                insertRandomNumbers()
                insertSymbol()
                answerField.text = nil
            } else {
                num1Label.text = "Final Grade - \(((Double(scoreNumber) / Double(questionNumber)) * 100))"
                num2Label.text = nil
                symbolLabel.text = "Quiz over. Please hit new quiz to begin again."
            }
            answerChecked = false
            return
        }
    }
    
    @IBAction func newQuiz(_ sender: UIButton) {
        viewDidLoad()
        questionNumber = 0
    }
    
    var popup = UILabel(frame: CGRect(x: 175, y: 190, width: 200, height: 200))
    
    func showAlertTrue() {
        popup.text = "Correct"
        popup.textColor = UIColor.green
        self.view.addSubview(popup)
        Timer.scheduledTimer(timeInterval: 3.0, target: self, selector: #selector(self.dismissAlert), userInfo: nil, repeats: false)
    }
    
    func showAlertFalse() {
        popup.text = "Incorrect - answer is \(calculateAnswer())"
        popup.textColor = UIColor.red
        self.view.addSubview(popup)
        Timer.scheduledTimer(timeInterval: 3.0, target: self, selector: #selector(self.dismissAlert), userInfo: nil, repeats: false)
    }
    
    @objc func dismissAlert() {
        popup.removeFromSuperview()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        insertRandomNumbers()
        insertSymbol()
        scoreLabel.text = "0"
        scoreNumber = 0
        questionLabel.text = "0"
        questionNumber = 0
        answerField.text = nil
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

