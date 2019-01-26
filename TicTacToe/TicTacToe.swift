//ॐ
//  TicTacToe.swift
//  TicTacToe
//
//  Created by Sumrin Mudgil on 1/26/19.
//  Copyright © 2019 Sumrin Mudgil. All rights reserved.
//


/* Hi Chris! I did some reserach on MVC. My understanding is that it is an architectural pattern that pares down an applicaton into  3 Parts: 1) Modal, which is essentially the "brain" of the app, handles any logic, and is independent of the user interface. 2) Controller, which communicates between the View and Modal. It sends the Modal info when the user interacts with the View. It also sends the View info when there is a change in the Modal part. 3) View, which is what the user interacts with. The MVP architectural style allows for code re-use. I think this TicTacToe class represents the "Modal" part of the MVC.  */

import Foundation

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


class TicTacToe {
    private var indicesUsed: Int
    private var boardState: [[State]]
    private var currTurn: PlayerTurn
    
    struct RowCol {
        var row = 0
        var col = 0
    }
    
    init() {
        indicesUsed = 0
        currTurn = PlayerTurn.p1
        boardState = [[State.empty, State.empty, State.empty, State.empty], [State.empty, State.empty, State.empty, State.empty], [State.empty, State.empty, State.empty, State.empty], [State.empty, State.empty, State.empty, State.empty]]
    }
    
    //Resets the game
    public func newGameClicked() {
        currTurn = PlayerTurn.p1
        indicesUsed = 0
        initBoard()
    }
    
    //Returns the current player
    public func getCurrPlayer() -> PlayerTurn {
        return currTurn
    }
    
    //Updates the board
    public func updateBoard(boardIndex: Int) -> WinStatus {
        let rowCol = getBoardIndices(boardIndex: boardIndex)
        if boardState[rowCol.row][rowCol.col] == .empty {
            if currTurn == .p1 {
                boardState[rowCol.row][rowCol.col] = .first
                if (checkIfWinner(toCheckState: .first, rowCol: rowCol)) {
                    return WinStatus.player1
                }
                currTurn = .p2
            } else {
                boardState[rowCol.row][rowCol.col] = .second
                if (checkIfWinner(toCheckState: .second, rowCol: rowCol)) {
                    return WinStatus.player2
                }
                currTurn = .p1
            }
            indicesUsed += 1
            if indicesUsed == 16 {
                return WinStatus.tie
            } else {
                return WinStatus.none
            }
        } else {
            return WinStatus.rep
        }

    }
    
    //Returns the player at the given row, col
    public func getPlayerAtIndex(boardIndex: Int) -> State {
        let rowCol = getBoardIndices(boardIndex: boardIndex)
        return boardState[rowCol.row][rowCol.col]
    }
  
    //Returns whether a winner exists
    private func checkIfWinner(toCheckState: State, rowCol: RowCol) -> Bool {
       return checkFourCorners(toCheckState: toCheckState) || checkFourInRow(toCheckState: toCheckState, i: rowCol.row, j: rowCol.col) || checkSquare(toCheckState: toCheckState, i: rowCol.row, j: rowCol.col)
    }
    
    //Returns row and col of board as struct
    private func getBoardIndices(boardIndex: Int) -> RowCol {
       return RowCol(row: boardIndex/4, col: boardIndex % 4)
    }
    
    
    //Resets the board so all indices are empty states
    private func initBoard() {
        for i in 0..<4 {
            for j in 0..<4 {
                boardState[i][j] = State.empty
            }
        }
    }
    
    //Checks if four outermost corners are filled
    private func checkFourCorners(toCheckState: State) -> Bool {
        return boardState[0][0] == toCheckState && boardState[0][3] == toCheckState && boardState[3][0] == toCheckState && boardState[3][3] == toCheckState
    }
    
    //checks if boardState index is in Bounds
    private func inBounds(i: Int, j: Int) -> Bool {
        return (i < 4 && i > -1 && j < 4 && j > -1)
    }
    
    //Checks if four in row--> diagonally, vertically, and horizontally
    private func checkFourInRow(toCheckState: State, i: Int, j: Int) -> Bool {
        return checkDiag(toCheckState: toCheckState) || checkVertical(toCheckState: toCheckState, j: j) || checkHorizontal(toCheckState: toCheckState, i: i)
    }
    
    //Checks if four in row horizontally
    private func checkHorizontal(toCheckState: State, i: Int) -> Bool {
        for col in 0..<4 {
            if boardState[i][col] != toCheckState {
                return false
            }
        }
        return true
    }
    
    //Checks if four in row vertically
    private func checkVertical(toCheckState: State, j: Int) -> Bool {
        for row in 0..<4 {
            if boardState[row][j] != toCheckState {
                return false
            }
        }
        return true
    }
    
    //Checks both diagonals if they are filled
    private func checkDiag(toCheckState: State) -> Bool {
        return (boardState[0][0] == toCheckState && boardState[1][1] == toCheckState && boardState[2][2] == toCheckState && boardState[3][3] == toCheckState) || (boardState[0][3] == toCheckState && boardState[1][2] == toCheckState && boardState[2][1] == toCheckState && boardState[3][0] == toCheckState)
    }
    
    //Checks if there's a square
    private func checkSquare(toCheckState: State, i: Int, j: Int) -> Bool {
        var squareExists = false
        
        //check top left
        if inBounds(i: i - 1, j: j - 1) && inBounds(i: i - 1, j: j) &&  inBounds(i: i, j: j - 1) && !squareExists {
            squareExists = boardState[i - 1][j - 1] == toCheckState && boardState[i - 1][j] == toCheckState && boardState[i][j - 1] == toCheckState
        }
        
        //check top right
        if inBounds(i: i - 1, j: j + 1) && inBounds(i: i - 1, j: j) && inBounds(i: i, j: j + 1) && !squareExists {
            squareExists = boardState[i - 1][j] == toCheckState && boardState[i][j + 1] == toCheckState && boardState[i - 1][j + 1] == toCheckState
        }
        
        // check bottom left
        if inBounds(i: i + 1, j: j - 1) && inBounds(i: i, j: j - 1)  && inBounds(i: i, j: j + 1) && !squareExists {
            squareExists = boardState[i + 1][j - 1] == toCheckState && boardState[i][j - 1] == toCheckState && boardState[i][j + 1] == toCheckState
        }
        
        //check bottom right
        if inBounds(i: i + 1, j: j + 1) && !squareExists {
            squareExists = boardState[i][j + 1] == toCheckState && boardState[i + 1][j + 1] == toCheckState && boardState[i + 1][j] == toCheckState
        }
        
        return squareExists
    }
    
}
