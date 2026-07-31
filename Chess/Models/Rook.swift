//
//  Rook.swift
//  Chess
//
//  Created by Elyura on 31.07.26.
//

import SwiftUI

class Rook: Piece{
    let id: UUID
    let team: Team
    var hasMoved: Bool
    
    init(team: Team){
        self.id = UUID()
        self.team = team
        self.hasMoved = false
    }
    
    func possibleMovements(from position: Position, board: Board) -> [Position] {
        var moves: [Position] = []
        let directions = [
            (0, 1),
            (0, -1),
            (1, 0),
            (-1, 0)
        ]
        
        for direction in directions {
            var currentPosition = position
            while let nextPosition = currentPosition.offset(rowBy: direction.0, rankBy: direction.1){
                if let targetPiece = board[nextPosition]{
                    if targetPiece.team != team{
                        moves.append(nextPosition)
                    }
                    break
                }else{
                    moves.append(nextPosition)
                }
                currentPosition = nextPosition
            }
        }
        
        
        return moves

    }
    
}
