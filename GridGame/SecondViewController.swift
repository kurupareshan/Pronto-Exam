//
//  SecondViewController.swift
//  GridGame
//
//  Created by Kuru on 2024-05-17.
//

import UIKit

enum Direction {
    case north, south, East, west
}

class SecondViewController: UIViewController {

    // MARK: - PROPERTIES
    
    @IBOutlet var gridCollectionView: UICollectionView!
    @IBOutlet var congratsView: UIView!
    var rows = CGFloat()
    var columns = CGFloat()
    var currentIndexPath: IndexPath = IndexPath(item: 0, section: 0)
    var destinationIndexPath: IndexPath = IndexPath(item: 0, section: 0)
    var numberOfMoves: Int = 0
    var startingTime: String = ""
    var endTime: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupCollectionView()
        setupCongratsView()
    }
    
    // MARK: - CollectionView Setup
    
    func setupCollectionView() {
        gridCollectionView.register(UINib(nibName: "GridCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "GridCollectionViewCell")
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        gridCollectionView.collectionViewLayout = layout
        gridCollectionView.dataSource = self
        gridCollectionView.delegate = self
        if let randomIndexPath = generateRandomIndexPath(totalItems: gridCollectionView.numberOfItems(inSection: 0)) {
            destinationIndexPath = randomIndexPath
        }
    }
    
    // MARK: - Setup CongratsView
    
    func setupCongratsView() {
        congratsView.isHidden = true
        congratsView.alpha = 0.0
    }
    
    
    // MARK: - Robot Moving Functions
    
    @IBAction func forwardButtonTapped(_ sender: Any) {
        moveImage(toIndexPath: currentIndexPath, direction: .north)
    }
    
    
    @IBAction func backwardButtonTapped(_ sender: Any) {
        moveImage(toIndexPath: currentIndexPath, direction: .south)
    }
    
    
    @IBAction func rightButtonTapped(_ sender: Any) {
        moveImage(toIndexPath: currentIndexPath, direction: .East)
    }
    
    
    @IBAction func leftButtonTapped(_ sender: Any) {
        moveImage(toIndexPath: currentIndexPath, direction: .west)
    }
    
    @IBAction func okButtonTapped(_ sender: Any) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        if let secondViewController = storyboard.instantiateViewController(withIdentifier: "LeaderBoardViewController") as? LeaderBoardViewController {
            secondViewController.modalPresentationStyle = .fullScreen
            self.present(secondViewController, animated: true, completion: nil)
        }
    }
    
    func moveImage(toIndexPath indexPath: IndexPath, direction: Direction) {
        guard indexPath.item >= 0, indexPath.item < gridCollectionView.numberOfItems(inSection: indexPath.section),
              indexPath.section >= 0, indexPath.section < gridCollectionView.numberOfSections else {
            return
        }
        
        guard let sourceCell = gridCollectionView.cellForItem(at: IndexPath(item: currentIndexPath.item, section: 0)) as? GridCollectionViewCell else {
            return
        }
        
        let newIndexpathRow: Int?
        switch direction {
        case .north:
            newIndexpathRow = currentIndexPath.item - Int(columns)
        case .south:
            newIndexpathRow = currentIndexPath.item + Int(columns)
        case .East:
            newIndexpathRow = currentIndexPath.item + 1
        case .west:
            newIndexpathRow = currentIndexPath.item - 1
        }
       
        guard let destinationCell = gridCollectionView.cellForItem(at: IndexPath(item: newIndexpathRow!, section: 0)) as? GridCollectionViewCell else {
            return
        }
        currentIndexPath = IndexPath(item: newIndexpathRow!, section: 0)
        numberOfMoves += 1
        checkDestination(currentIndexPath: currentIndexPath, destination: destinationIndexPath)
        destinationCell.icon.image = sourceCell.icon.image
        sourceCell.icon.image = nil
    }
    
    // MARK: - Check Destination
    
    func checkDestination(currentIndexPath: IndexPath, destination: IndexPath) {
        if (currentIndexPath == destination) {
            getEndTime()
            UIView.animate(withDuration: 2.0) {
                self.congratsView.isHidden = false
                self.congratsView.alpha = 1.0
            }
        }
    }
    
    // MARK: - End Time
    
    func getEndTime() {
        let currentDate = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        dateFormatter.timeZone = TimeZone.current
        dateFormatter.locale = Locale.current
        let currentDateString = dateFormatter.string(from: currentDate)
        self.endTime = currentDateString
        print("string is", currentDateString)
        if let currentDate = dateFormatter.date(from: currentDateString) {
            let timeFormatter = DateFormatter()
            timeFormatter.dateFormat = "HH:mm:ss"
            let currentTimeString = timeFormatter.string(from: currentDate)
            print("Current time: \(currentTimeString)")
            calculateTimeDifferent(startTime: self.startingTime, endTime: currentTimeString)
        } else {
            print("Error: Unable to parse date string.")
        }
    }
    
    // MARK: - Calculate Time Difference
    
    func calculateTimeDifferent(startTime: String, endTime: String) {
        let timeFormatter = DateFormatter()
        timeFormatter.dateFormat = "HH:mm:ss"
        if let endTime = timeFormatter.date(from: endTime),
            let startTime = timeFormatter.date(from: startTime) {
            let timeInterval = endTime.timeIntervalSince(startTime)
            self.saveData(cells: Int(rows * columns), moves: self.numberOfMoves, timeInterval: timeInterval)
        } else {
            print("Error: Unable to parse time strings.")
        }
    }
    
    // MARK: - Save Data

    func saveData(cells: Int, moves: Int, timeInterval: Double) {
        print("cells \(cells), moves \(moves), time \(timeInterval)")
        DataManager.shared.saveData(cells: cells, moves: moves, timeInterval: timeInterval, endTime: self.endTime)
    }
    
}

extension SecondViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return  Int(rows * columns)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "GridCollectionViewCell", for: indexPath) as! GridCollectionViewCell
        if (indexPath.section == 0 && indexPath.item == 0) {
            cell.icon.image = UIImage(named: "human-2")
        }
        if (indexPath == destinationIndexPath) {
            cell.icon.image = UIImage(named: "flag")
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let size1:CGFloat = (collectionView.frame.size.width - (10 * columns)) / columns
        let size2:CGFloat = (collectionView.frame.size.height - (10 * rows)) / rows
        return CGSize(width: size1, height: size2)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 10
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 10
    }

    func generateRandomIndexPath(totalItems: Int) -> IndexPath? {
        guard totalItems > 0 else { return nil }
        let totalitems = rows * columns
        let randomItem = Int.random(in: 1..<Int(totalitems))
        return IndexPath(item: randomItem, section: 0)
    }
    
}
