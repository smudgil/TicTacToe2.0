//ॐ
//  ViewController.swift
//  TicTacToe
//
//  Created by Sumrin Mudgil on 1/19/19.
//  Copyright © 2019 Sumrin Mudgil. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    enum State {
        case empty
        case first
        case second
    }
    
    enum PlayerTurn {
        case p1
        case p2
    }
    
    enum WinStatus {
        case tie
        case player1
        case player2
        case rep
        case none
    }

  
    @IBOutlet weak var newGameButton: UIButton!
    @IBOutlet weak var board: UICollectionView!
    @IBOutlet weak var currentPlayerImage: UIImageView!
    var boardWidth = 0.0
    var padding = 0.00
    var game: TicTacToe!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        board.register(UINib.init(nibName: "SimpleCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "simpleCell") //just a simple collection view cell
        
        initBoardStyle()
        game = TicTacToe()

        
        board.delegate = self
        board.dataSource = self
        board.reloadData()

        currentPlayerImage.image = #imageLiteral(resourceName: "happy")
    }

    override func viewDidAppear(_ animated: Bool) {
        presentWelcomeMessage()
        game.newGameClicked()
    }
    
    //Initializes the buttons and board style
    func initBoardStyle() {
        newGameButton.layer.cornerRadius = newGameButton.bounds.height / 2 //gives button rounded corners
        newGameButton.layer.borderColor = UIColor(red: 250/255, green: 120/255, blue: 56/255, alpha: 1).cgColor
        newGameButton.layer.borderWidth = 1
        boardWidth = Double(board.bounds.width)
        padding = (boardWidth / 5) / 4
    }
    
    //Presents welcome message
    func presentWelcomeMessage() {
        let alert = UIAlertController(title: "Welcome to 4x4 TicTacToe!", message: "To win, you must get 4 in row (vertical/horizontal/diagonal), all 4 corners, a 2x2 box. Player 1 (☺️) starts, and player 2 (😜) follows.", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "START", style: .cancel, handler: nil))
        self.present(alert, animated: true,completion: nil)
    }
    
    //Restarts the game
    @IBAction func newGameClicked(_ sender: Any) {
        currentPlayerImage.image = #imageLiteral(resourceName: "happy")
        game.newGameClicked()
        updateDisplay()
    }
    
    //Updates the Display
    func updateDisplay() {
        if game.getCurrPlayer() == .p1 {
            currentPlayerImage.image = #imageLiteral(resourceName: "happy")
        } else {
            currentPlayerImage.image = #imageLiteral(resourceName: "wink")
        }
        board.reloadData()
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 16
    }
    
    //Sets size of elements
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize
    {
        let width = board.bounds.width/5
        let height = width
        
        return CGSize(width: width, height: height)
    }
    
    //Sets board padding
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: CGFloat(padding), left: CGFloat(padding), bottom: CGFloat(padding), right: CGFloat(padding))
    }
    
    //Determines image (or lack there of) at that cell
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "simpleCell", for: indexPath) as! SimpleCollectionViewCell
        let state = game.getPlayerAtIndex(boardIndex: indexPath.row)
        if state == .second {
            cell.imageView.image = #imageLiteral(resourceName: "wink")
        } else if state == .first {
            cell.imageView.image = #imageLiteral(resourceName: "happy")
        } else {
            cell.imageView.image = nil

        }
        return cell
    }
    
    //Determines action when user selects a cell
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let status = game.updateBoard(boardIndex: indexPath.row)
        if status == .tie {
            printTieMessage()
        } else if status == .player1 {
            printWinnerMessage(winner: "1")
        } else if status == .player2 {
            printWinnerMessage(winner: "2")
        } else if status == .rep {
            printChooseDiffMessage()
        }
        updateDisplay()
        
    }
    
    //Presents an alert that tells us who is the winner.
    func printWinnerMessage(winner: String) {
        let message = "Player " + winner + " has won!"
        let alert = UIAlertController(title: "Looks like we have a winner...", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: { action in
            self.newGameClicked(self)
        }))
        self.present(alert, animated: true,completion: nil)
    }
    
    //Presents an alert that tells us there's a tie.
    func printTieMessage() {
        let alert = UIAlertController(title: "And the winner is...", message: "BOTH of you! It's a tie!", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: { action in
            self.newGameClicked(self)
        }))
        self.present(alert, animated: true,completion: nil)
    }
    
    //Presents an alert that tells us that the cell is already taken.
    func printChooseDiffMessage() {
        let alert = UIAlertController(title: "Looks like that spot is taken.", message: "Please choose a different square", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
        self.present(alert, animated: true,completion: nil)
    }
    
}

