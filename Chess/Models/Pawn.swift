//
//  Pawn.swift
//  Chess
//
//  Created by Elyura on 30.07.26.
//

import Foundation

class Pawn: Piece{
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
        let direction = team == .white ? 1 : -1
        
        if let oneForward = position.offset(rowBy: direction, rankBy: 0) {
            if board[oneForward] == nil {
                moves.append(oneForward)
                
                if !hasMoved,
                   let twoForward = position.offset(rowBy: 2 * direction, rankBy: 0) {
                    if board[twoForward] == nil {
                        moves.append(twoForward)
                    }
                }
            }
        }
                for rankOffset in [-1,1]{
                    if let diagonal = position.offset(rowBy: direction, rankBy: rankOffset),
                        let targetPiece = board[diagonal],
                            targetPiece.team != team {
                                moves.append(diagonal)
                            
                    }
                }
                return moves
            }
        }
 
