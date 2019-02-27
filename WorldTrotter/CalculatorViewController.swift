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
    // function: generateRandomNumber
    // Precondition: the function is given 2 ints that represent
    //    the minimum and maximum number for the random number generator
    // Postcondition: an int between the maximum and minimum numbers is returned
    func generateRandomNumber(min: Int, max: Int) -> Int {
        let result = Int(arc4random_uniform(UInt32(max - min + 1))) + min
        return result
    }
    // function: insertRandomNumbers
    // Precondition:
    // Postcondition: this function will set the labels in the storyboard to the random generated numbers
    func insertRandomNumbers() {
        let rand1 = generateRandomNumber(min: -10, max: 20)
        num1Label.text = String(rand1)
        
        let rand2 = generateRandomNumber(min: -10, max: 20)
        num2Label.text = String(rand2)
        
        if rand1 == 0 || rand2 == 0 {
            insertRandomNumbers()
        }
    }
    // function: insertSymbol
    // Precondition:
    // Postcondition: this function will insert a random symbol from the symbolArray into the symbolLabel in
    //    the storyboard
    func insertSymbol() {
        let symbolArray = ["+", "-", "*", "÷"]
        let randomIndex = Int(arc4random_uniform(UInt32(symbolArray.count)))
        symbolLabel.text = symbolArray[randomIndex]
    }
    // function: calculateAnswer
    // Precondition: The labels must be set by the previous functions
    // Postcondition: The labels will be casted to ints and the symbol that was randomly chosen
    //   will be used to calculate the answer, then it will be returned
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
    // function: doMath
    // Precondition: This function takes in 2 ints and an operator
    // Postcondition: this function uses the 2 ints and the operator and
    //    performs math on them, then returns the answer
    func doMath(_ a: Int, _ b: Int, _ op: String) -> Int {
        typealias binOp = (Int, Int) -> Int
        var ops: [String: binOp] = ["+": add, "-": sub, "*": mul, "/": div]
        let opFunc = ops[op]
        return opFunc!(a,b)
    }
    // function: checkAnswer
    // Precondition: The check answer button must be pushed on the storyboard
    // Postcondition: This function will take the user input and check it against the answer returned
    //   from the calculateAnswer function. It will then display an alert whether the user got it right or wrong
    //   then it will allow the user to press the next answer button
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
    // function: nextQuestion
    // Precondition: the button must be pressed in the storyboard and the function check answer must be
    //   pressed first
    // Postcondition: this function will get new random numbers and a random symbol and display them
    //   If there have been 10 attempts, the final grade will be displayed.
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
    // function: showAlertTrue
    // Precondition: the user must have gotten the answer correct answer in the checkAnswer function
    // Postcondition: A timed popup is displayed to the screen saying "correct"
    func showAlertTrue() {
        popup.text = "Correct"
        popup.textColor = UIColor.green
        self.view.addSubview(popup)
        Timer.scheduledTimer(timeInterval: 3.0, target: self, selector: #selector(self.dismissAlert), userInfo: nil, repeats: false)
    }
    // function: showAlertFalse
    // Precondition: the user must have gotten the answer incorrect answer in the checkAnswer function
    // Postcondition: A timed popup is displayed to the screen saying "incorrect"
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

