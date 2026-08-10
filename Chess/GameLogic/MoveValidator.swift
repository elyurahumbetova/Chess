//
//  MoveValidator.swift
//  Chess
//
//  Created by Elyura on 08.08.26.
//

import SwiftUI

struct MoveValidator{
    static func legalMoves(for position: Position,board: Board) ->[Position]{
        guard let piece = board[position] else { return []}
        
        let rawMoves = piece.possibleMovements(from: position, board: board)
        return rawMoves.filter{ targetPosition in
            
            var simulatedBoard = board
            simulatedBoard[targetPosition] = piece
            simulatedBoard[position] = nil
            
            return !isCheck(team: piece.team, board: simulatedBoard)
            
        }
        
        
    }
    
    static func isCheck(team: Team, board: Board)-> Bool{
        guard let kingPosition = findKingPosition(team: team,board: board)else{
            return false
        }
        
        return isSquareAttacked(kingPosition, by: team.opponent, board: board)
    }
    
    static func findKingPosition(team: Team,board: Board) -> Position? {
        for rank in Rank.allCases{
            for row in Row.allCases{
                let position = Position(rank: rank, row: row)
                if let piece = board[position], piece is King, piece.team == team {
                    return position
                }
            }
        }
        return nil
        
    }
    
    
    private static func isSquareAttacked(_ position: Position, by attackerTeam: Team, board: Board) -> Bool {
        
        for rank in Rank.allCases{
            for row in Row.allCases{
                let attackerPosition = Position(rank: rank, row: row)
                guard let piece = board[attackerPosition],piece.team == attackerTeam else { continue}
                let attackMoves = piece.possibleMovements(from: attackerPosition, board: board)
                if attackMoves.contains(position){
                    return true
                }
            }
        }
        return false
    }
    
    static func isCheckmate(team: Team,board: Board) -> Bool {
        guard  isCheck(team: team, board: board) else { return false  }
        
        return !hasAnyLegalMove( team: team,board: board)
    }
    
    static func isStalement(team: Team,board: Board) -> Bool {
        guard !isCheck(team: team, board: board) else { return false }
        return !hasAnyLegalMove(team: team, board: board)
    }
    private static func hasAnyLegalMove(team: Team,board: Board) -> Bool {
        for rank in Rank.allCases{
            for row in Row.allCases{
                let position = Position(rank: rank, row: row)
                guard let piece = board[position], piece.team == team else { continue }
                if !legalMoves(for: position, board: board).isEmpty{
                    return true
                }
            }
        }
        return false
    }
}
