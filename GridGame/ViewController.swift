//
//  ViewController.swift
//  GridGame
//
//  Created by Kuru on 2024-05-16.
//

import UIKit

class ViewController: UIViewController {

    // MARK: - PROPERTIES
    
    @IBOutlet var generateButton: UIButton!
    @IBOutlet var gridDescLabel: UILabel!
    @IBOutlet var rowMinusButton: UIButton!
    @IBOutlet var rowPlusButton: UIButton!
    @IBOutlet var columnMinusButton: UIButton!
    @IBOutlet var columnPlusButton: UIButton!
    @IBOutlet var rowValueLabel: UILabel!
    @IBOutlet var columValueLabel: UILabel!
    @IBOutlet var hintLabel: UILabel!
    @IBOutlet var continueButton: UIButton!
    @IBOutlet var successMsgLabel: UILabel!
    var rowRandomNumber: Int = 0
    var columnRandomNumber: Int = 0
    var startingTime: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }
    
    // MARK: - Basic Setup
    
    func setupView() {
        gridDescLabel.isHidden = true
        hintLabel.isHidden = true
        continueButton.backgroundColor = .lightGray
        continueButton.isUserInteractionEnabled = false
        successMsgLabel.isHidden = true
        rowPlusButton.isUserInteractionEnabled = false
        rowMinusButton.isUserInteractionEnabled = false
        columnPlusButton.isUserInteractionEnabled = false
        columnMinusButton.isUserInteractionEnabled = false
    }

    // MARK: - Button Actions
    
    @IBAction func generateGridButtonTapped(_ sender: Any) {
        rowPlusButton.isUserInteractionEnabled = true
        rowMinusButton.isUserInteractionEnabled = true
        columnPlusButton.isUserInteractionEnabled = true
        columnMinusButton.isUserInteractionEnabled = true
        gridDescLabel.isHidden = false
        generateButton.isHidden = true
        hintLabel.isHidden = false
        let minNumber = 4
        let maxNumber = 6
        rowRandomNumber = Int.random(in: minNumber...maxNumber)
        columnRandomNumber = Int.random(in: minNumber...maxNumber)
        setupHintLabelValue()
        getStartingTime()
    }
    
    @IBAction func rowMinusButtonTapped(_ sender: Any) {
        rowPlusButton.isUserInteractionEnabled = true
        var rowLabelValue = Int(rowValueLabel.text!)
        rowLabelValue! -= 1
        if (rowLabelValue! <= 3) {
            rowValueLabel.text = String(3)
            rowMinusButton.isUserInteractionEnabled = false
        }else {
            rowValueLabel.text = String(rowLabelValue!)
        }
        checkGridValues()
    }
    
    @IBAction func rowPlusButtonTapped(_ sender: Any) {
        rowMinusButton.isUserInteractionEnabled = true
        var rowLabelValue = Int(rowValueLabel.text!)
        rowLabelValue! += 1
        if (rowLabelValue! >= 6) {
            rowValueLabel.text = String(6)
            rowPlusButton.isUserInteractionEnabled = false
        }else {
            rowValueLabel.text = String(rowLabelValue!)
        }
        checkGridValues()
    }
    
    @IBAction func columMinusButtonTapped(_ sender: Any) {
        columnPlusButton.isUserInteractionEnabled = true
        var columLabelValue = Int(columValueLabel.text!)
        columLabelValue! -= 1
        if (columLabelValue! <= 3) {
            columValueLabel.text = String(3)
            columnMinusButton.isUserInteractionEnabled = false
        }else {
            columValueLabel.text = String(columLabelValue!)
        }
        checkGridValues()
    }
    
    
    @IBAction func columPlusButtonTapped(_ sender: Any) {
        columnMinusButton.isUserInteractionEnabled = true
        var columLabelValue = Int(columValueLabel.text!)
        columLabelValue! += 1
        if (columLabelValue! >= 6) {
            columValueLabel.text = String(6)
            columnPlusButton.isUserInteractionEnabled = false
        }else {
            columValueLabel.text = String(columLabelValue!)
        }
        checkGridValues()
    }
    
    @IBAction func continueButtonTapped(_ sender: Any) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        if let secondViewController = storyboard.instantiateViewController(withIdentifier: "SecondViewController") as? SecondViewController {
            secondViewController.rows = CGFloat(rowRandomNumber)
            secondViewController.columns = CGFloat(columnRandomNumber)
            secondViewController.startingTime = self.startingTime
            secondViewController.modalPresentationStyle = .fullScreen
            self.present(secondViewController, animated: true, completion: nil)
        }
    }
    
    // MARK: - Hint Label Setup
    
    func setupHintLabelValue() {
        hintLabel.text = ("Total Number of cells are \(rowRandomNumber * columnRandomNumber)")
    }
    
    // MARK: - Check Grid Eligible
    
    func checkGridValues() {
        let rowLabelValue = Int(rowValueLabel.text!)
        let columnLabelValue = Int(columValueLabel.text!)
        if (rowLabelValue == rowRandomNumber && columnLabelValue == columnRandomNumber) {
            continueButton.isUserInteractionEnabled = true
            continueButton.backgroundColor = .green
            successMsgLabel.isHidden = false
            rowPlusButton.isUserInteractionEnabled = false
            rowMinusButton.isUserInteractionEnabled = false
            columnPlusButton.isUserInteractionEnabled = false
            columnMinusButton.isUserInteractionEnabled = false
        }
    }
    
    // MARK: - get Starting Time
    
    func getStartingTime() {
        let currentDate = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        dateFormatter.timeZone = TimeZone.current
        dateFormatter.locale = Locale.current
        let currentDateString = dateFormatter.string(from: currentDate)
        if let currentDate = dateFormatter.date(from: currentDateString) {
            let timeFormatter = DateFormatter()
            timeFormatter.dateFormat = "HH:mm:ss"
            self.startingTime = timeFormatter.string(from: currentDate)
            print("Current time: \(self.startingTime)")
        } else {
            print("Error: Unable to parse date string.")
        }
    }
    
}

