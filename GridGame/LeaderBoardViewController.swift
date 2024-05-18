//
//  LeaderBoardViewController.swift
//  GridGame
//
//  Created by Kuru on 2024-05-17.
//

import UIKit
import Realm
import RealmSwift

class LeaderBoardViewController: UIViewController {
    
    // MARK: - PROPERTIES
    var data: Results<DataModel>!
    @IBOutlet var stackView1: UIStackView!
    @IBOutlet var view1GridSize: UILabel!
    @IBOutlet var view1Moves: UILabel!
    @IBOutlet var viewOneTime: UILabel!
    @IBOutlet var stackView2: UIStackView!
    @IBOutlet var view2GridSize: UILabel!
    @IBOutlet var view2Moves: UILabel!
    @IBOutlet var view2Time: UILabel!
    @IBOutlet var stackView3: UIStackView!
    @IBOutlet var view3Gridsize: UILabel!
    @IBOutlet var view3Moves: UILabel!
    @IBOutlet var view3Time: UILabel!
    @IBOutlet var stackView4: UIStackView!
    @IBOutlet var view4Gridsize: UILabel!
    @IBOutlet var view4Moves: UILabel!
    @IBOutlet var view4Time: UILabel!
    @IBOutlet var stackView5: UIStackView!
    @IBOutlet var view5Gridsize: UILabel!
    @IBOutlet var view5Moves: UILabel!
    @IBOutlet var view5Time: UILabel!
    @IBOutlet var view1Height: NSLayoutConstraint!
    @IBOutlet var view2Height: NSLayoutConstraint!
    @IBOutlet var view3Height: NSLayoutConstraint!
    @IBOutlet var view4Height: NSLayoutConstraint!
    @IBOutlet var view5Height: NSLayoutConstraint!
    @IBOutlet var textContainerViewHeight: NSLayoutConstraint!
    @IBOutlet var textView: UITextView!
    var gameModels: [GameModel] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        displayData()
        stackView1.tag = 1
        addTapGesture(to: stackView1)
        stackView2.tag = 2
        addTapGesture(to: stackView2)
        stackView3.tag = 3
        addTapGesture(to: stackView3)
        stackView4.tag = 4
        addTapGesture(to: stackView4)
        stackView5.tag = 5
        addTapGesture(to: stackView5)
    }
    
    func setupView() {
        stackView1.layer.borderColor = UIColor.black.cgColor
        stackView1.layer.borderWidth = 1
        stackView2.layer.borderColor = UIColor.black.cgColor
        stackView2.layer.borderWidth = 1
        stackView3.layer.borderColor = UIColor.black.cgColor
        stackView3.layer.borderWidth = 1
        stackView4.layer.borderColor = UIColor.black.cgColor
        stackView4.layer.borderWidth = 1
        stackView5.layer.borderColor = UIColor.black.cgColor
        stackView5.layer.borderWidth = 1
        
    }
    
    func addTapGesture(to view: UIView) {
            let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTapgestureData(_:)))
            view.addGestureRecognizer(tapGesture)
    }
    
    func displayData() {
        data = DataManager.shared.fetchData()
        
        self.visibleView()
        
        gameModels.removeAll()
        
        if (data.count > 5) {
            for i in data.count-5..<data.count {
                let gameModel = GameModel(cells: data[i].cells, moves: data[i].moves, timeDifference: data[i].timeDifference, endTime: data[i].endTime)
                gameModels.append(gameModel)
            }
        }else {
            for i in 0..<data.count {
                let gameModel = GameModel(cells: data[i].cells, moves: data[i].moves, timeDifference: data[i].timeDifference, endTime: data[i].endTime)
                gameModels.append(gameModel)
            }
        }
        
        gameModels.sort { $0.weightedScore < $1.weightedScore }
        
        for i in 0..<gameModels.count {
            updateView(forIndex: i, withModel: gameModels[i])
        }
    }

    func updateView(forIndex index: Int, withModel model: GameModel) {
        let cellsText = String(model.cells)
        let movesText = String(model.moves)
        let seconds = Int(model.timeDifference) % 60
        let minutes = (Int(model.timeDifference) / 60) % 60
        let timeText = "\(String(minutes)) : \(String(seconds))"
        
        switch index {
        case 0:
            view1GridSize.text = cellsText
            view1Moves.text = movesText
            viewOneTime.text = timeText
        case 1:
            view2GridSize.text = cellsText
            view2Moves.text = movesText
            view2Time.text = timeText
        case 2:
            view3Gridsize.text = cellsText
            view3Moves.text = movesText
            view3Time.text = timeText
        case 3:
            view4Gridsize.text = cellsText
            view4Moves.text = movesText
            view4Time.text = timeText
        case 4:
            view5Gridsize.text = cellsText
            view5Moves.text = movesText
            view5Time.text = timeText
        default:
            break
        }
    }
    
    func visibleView() {
        if (data.count == 1) {
            view1Height.constant = 40
        }else if (data.count == 2) {
            view1Height.constant = 40
            view2Height.constant = 40
        }else if (data.count == 3) {
            view1Height.constant = 40
            view2Height.constant = 40
            view3Height.constant = 40
        }else if (data.count == 4) {
            view1Height.constant = 40
            view2Height.constant = 40
            view3Height.constant = 40
            view4Height.constant = 40
        }else if (data.count >= 5) {
            view1Height.constant = 40
            view2Height.constant = 40
            view3Height.constant = 40
            view4Height.constant = 40
            view5Height.constant = 40
        }
    }
    
    @objc func handleTapgestureData(_ sender: UITapGestureRecognizer) {
        if let tappedView = sender.view {
            let viewTag = tappedView.tag
            if (viewTag == 1) {
                self.generateData(for: 0)
            }else if (viewTag == 2) {
                self.generateData(for: 1)
            }else if (viewTag == 3) {
                self.generateData(for: 2)
            }else if (viewTag == 4) {
                self.generateData(for: 3)
            }else {
                self.generateData(for: 4)
            }
        }
    }
    
    func generateData(for index: Int) {
        let date = self.gameModels[index].endTime
        var data = String()
        for _ in 0..<self.gameModels[index].cells {
            data += "This round was completed at \(date)."
        }
        self.textView.text = data
    }
    
    @IBAction func newGameButtonTapped(_ sender: Any) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        if let viewcontroller = storyboard.instantiateViewController(withIdentifier: "ViewController") as? ViewController {
            viewcontroller.modalPresentationStyle = .fullScreen
            self.present(viewcontroller, animated: true, completion: nil)
        }
    }
    
}
