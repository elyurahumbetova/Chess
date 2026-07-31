//
//  Extensions.swift
//  Chess
//
//  Created by Elyura on 30.07.26.
//

import SwiftUI
extension Team {
    var displayName: LocalizedStringKey {
        switch self {
        case .white:
            return "White"
        case .black:
            return "Black"
        }
    }
}

extension Player: CustomStringConvertible {
    var description: String {
        switch self {
        case .human:
            return "human"
        case .ai(let ai):
            return "\(ai.name) player"
        }
    }
}
extension PieceType {
    var displayName: LocalizedStringKey {
        switch self {
        case .pawn:   return "Pawn"
        case .knight: return "Knight"
        case .bishop: return "Bishop"
        case .rook:   return "Rook"
        case .queen:  return "Queen"
        case .king:   return "King"
        }
    }
}
extension Piece{
    func canMove(from position: Position,board: Board) -> Bool{
        !possibleMovements(from: position, board: board).isEmpty
    }
    
    func markAsMoved(){
        hasMoved = true
    }
}
extension Position {
  
    func offset(rowBy rowDelta: Int, rankBy rankDelta: Int) -> Position? {
        let newRow = row.rawValue + rowDelta
        let newRank = rank.rawValue + rankDelta
        
        guard let row = Row(rawValue: newRow),
              let rank = Rank(rawValue: newRank) else {
            return nil
        }
        
        return Position(rank: rank, row: row)
    }
}
