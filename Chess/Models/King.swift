//
//  King.swift
//  Chess
//
//  Created by Elyura on 05.08.26.
//

import SwiftUI

class King: Piece{
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
            (1,-1),
            (1,1),
            (-1,1),
            (-1,-1),
            (1,0),
            (-1,0),
            (0,1),
            (0,-1)
        ]
        
        for direction in directions {
            if let targetPosition = position.offset(rowBy: direction.0, rankBy: direction.1){
                if let targetPiece = board[targetPosition]{
                    if targetPiece.team != team{
                        moves.append(targetPosition)
                    }
                }
                else{
                    moves.append(targetPosition)
                }
            }
            
            
        }
        return moves

        
    }
}
