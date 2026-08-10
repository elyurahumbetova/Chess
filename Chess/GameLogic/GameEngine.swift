//
//  GameEngine.swift
//  Chess
//
//  Created by Elyura on 08.08.26.
//

import SwiftUI

struct GameEngine{
    static func executeMove(from: Position, to: Position,state: inout GameState,promotedTo: PieceType? = nil ){
        guard let piece = state.board[from] else { return }
        
        var capturedPiece = state.board[to]
        
        let isCastling = piece is King && abs(to.rank.rawValue - from.rank.rawValue) == 2
        let isEnPassant = piece is Pawn && to == state.enPassantTarget && capturedPiece == nil
        let isPromotion = piece is Pawn && (to.row == .eight || to.row == .one)
        
        
        if isEnPassant {
            let capturedPawnRow: Row = piece.team == .white ? .five : .four
            let capturedPawnPosition = Position(rank: to.rank, row: capturedPawnRow)
            capturedPiece = state.board[capturedPawnPosition]
            state.board[capturedPawnPosition] = nil
        }
        
        state.board[from] = nil
        
        if isPromotion,let promotedTo = promotedTo{
            state.board[to] = makePromotedPiece(type: promotedTo, team: piece.team)
        }else{
            state.board[to] = piece
        }
        
        piece.markAsMoved()
        
        if isCastling {
            performCastlingRookMove(from: from, to: to, team: piece.team, board: &state.board)
        }
        
        state.enPassantTarget = enPassantTarget(from: from, to: to, piece: piece)
        updateCastlingRights(piece: piece, from: from, state: &state)
        
        let move = Move(
            from: from,
            to: to,
            piece: piece,
            capturedPiece: capturedPiece,
            isCastling: isCastling,
            isEnPassant: isEnPassant,
            isPromotion: isPromotion,
            promotedTo: promotedTo
        )
        state.moveHistory.append(move)
        
        if let captured = capturedPiece {
            state.capturedPieces.append(captured)
        }
        
        if piece is Pawn || capturedPiece != nil {
            state.halfMoveClock = 0
        } else {
            state.halfMoveClock += 1
        }
        
        if piece.team == .black {
            state.fullMoveNumber += 1
        }
        state.currentTurn = piece.team.opponent
        state.board.turn = state.currentTurn
        
        updateGameStatus(state: &state)
       
    }
    private static func performCastlingRookMove(from: Position, to: Position, team: Team, board: inout Board) {
        let row: Row = team == .white ? .one : .eight
        let isKingside = to.rank.rawValue > from.rank.rawValue
        
        let rookFrom = Position(rank: isKingside ? .H : .A, row: row)
        let rookTo = Position(rank: isKingside ? .F : .D, row: row)
        
        if let rook = board[rookFrom] {
            board[rookFrom] = nil
            board[rookTo] = rook
            rook.markAsMoved()
        }
    }
    
    private static func updateCastlingRights(piece: any Piece, from: Position,state: inout GameState){
        if piece is King {
            if piece.team == .white {
                state.whiteCanCastleKingside = false
                state.whiteCanCastleQueenside = false
            }else{
                state.blackCanCastleKingside = false
                state.blackCanCastleQueenside = false
            }
        }
        
        if piece is Rook {
            switch(piece.team, from.rank){
            case(.white, .A): state.whiteCanCastleQueenside = false
            case (.white, .H): state.whiteCanCastleKingside = false
            case (.black, .A): state.blackCanCastleQueenside = false
            case (.black, .H): state.blackCanCastleKingside = false
            default: break
            
            }
        }
    }
    
    private static func enPassantTarget(from: Position,to: Position, piece: any Piece) -> Position?{
        guard piece is Pawn else { return nil }
        let rowDiff = abs(to.row.rawValue - from.row.rawValue)
        guard rowDiff == 2 else { return nil}
        
        let middleRow = (from.row.rawValue + to.row.rawValue) / 2
        guard let row = Row(rawValue: middleRow) else { return nil }
                
        return Position(rank: from.rank, row: row)
    }
    
    private static func makePromotedPiece(type: PieceType, team: Team) -> any Piece {
          switch type {
          case .queen:  return Queen(team: team)
          case .rook:   return Rook(team: team)
          case .bishop: return Bishop(team: team)
          case .knight: return Knight(team: team)
          default:      return Queen(team: team)
          }
      }
    
    private static func updateGameStatus(state: inout GameState){
        let team = state.currentTurn
        
        state.isCheck = MoveValidator.isCheck(team: team, board: state.board)
        state.isCheckmate = MoveValidator.isCheckmate(team: team, board: state.board)
        state.isStalemate = MoveValidator.isStalement(team: team, board: state.board)
        
        
        if state.isCheckmate{
            state.winner = team.opponent
            
        }
        
        if state.isStalemate || state.halfMoveClock >= 100{
            state.isDraw = true
        }
    }
}
