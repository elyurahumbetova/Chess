//
//  BoardSetUP.swift
//  Chess
//
//  Created by Elyura on 06.08.26.
//

import SwiftUI

struct BoardSetUp{
    
    static func initialBoard() -> Board{
        var board = Board()
        placeBackRow(team: .white, row: .one, board: &board)
        placePawns(team: .white , row: .two, board: &board)
        
        placeBackRow(team: .black, row: .eight, board: &board)
        placePawns(team: .black, row: .seven, board: &board)
        
        board.turn = .white
        
        return board
    }
    private static func placeBackRow(team:Team,row: Row,board: inout Board){
        let order: [Rank: PieceType] = [
            .A: .rook,
            .B: .knight,
            .C: .bishop,
            .D: .queen,
            .E: .king,
            .F: .bishop,
            .G: .knight,
            .H: .rook
        ]
        
        for rank in Rank.allCases{
            guard let pieceType = order[rank] else {
                continue
            }
            let position = Position(rank: rank, row: row)
            board[position] = makePiece(type: pieceType,team: team)
            
        }
    }
    
    private static func placePawns(team: Team, row: Row,board: inout Board){
        for rank in Rank.allCases{
            let position = Position(rank: rank, row: row)
            board[position] = Pawn(team: team)
            
        }
    }
    
    private static func makePiece(type: PieceType,team: Team) -> any Piece{
        
        switch type{
        case .rook: return Rook(team: team)
        case .knight: return Knight(team: team)
        case .bishop: return Bishop(team: team)
        case .king: return King(team: team)
        case .queen:return  Queen(team: team)
        case .pawn: return Pawn(team: team)
        }
        
    }
}
