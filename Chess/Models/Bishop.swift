//
//  Bishop.swift
//  Chess
//
//  Created by Elyura on 01.08.26.
//

import SwiftUI

class Bishop: Piece{
    let id: UUID
    let team: Team
    var hasMoved: Bool
    
    init(team: Team) {
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
            (-1,-1)
        ]
        
        for direction in directions{
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
