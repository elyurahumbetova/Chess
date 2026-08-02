//
//  ChessTests.swift
//  ChessTests
//
//  Created by Elyura on 02.08.26.
//

import Testing
@testable import Chess

@MainActor
struct PawnTests {

    @Test func whitePawnFirstMoveCanMoveTwoSquares() async throws {
        var board = Board()
        let pawn = Pawn(team: .white)
        let position = Position(rank: .E, row: .two)
        board[position] = pawn
        
        let moves = pawn.possibleMovements(from: position, board: board)
        
        #expect(moves.contains(Position(rank: .E, row: .three)))
        #expect(moves.contains(Position(rank: .E, row: .four)))
    }

    @Test func whitePawnAfterFirstMoveCanMoveOneSquare() async throws {
        var board = Board()
        
        let pawn = Pawn(team: .white)
        pawn.hasMoved = true
        let position = Position(rank: .E, row: .three)
        board[position] = pawn
        let moves = pawn.possibleMovements(from: position, board: board)
        #expect(moves.contains(Position(rank: .E, row: .four)))

        #expect(!moves.contains(Position(rank: .E, row: .five)))
        
    }
    
    @Test func pawnCanCaptureDiagonally() async throws{
        var board = Board()
        let pawn = Pawn(team: .white)
        let enemyPawn = Pawn(team: .black)
        let position = Position(rank: .E, row: .three)
        board[position] = pawn
        let enemyPosition = Position(rank: .D, row: .four)
        board[enemyPosition] = enemyPawn
        let moves = pawn.possibleMovements(from: position, board: board)
        #expect(moves.contains(enemyPosition))
    }
    
    @Test func pawnCanNotCaptureOwnTeam() async throws{
        var board = Board()
        let pawn = Pawn(team: .white)
        let position = Position(rank: .A, row: .four)
        board[position] = pawn
        
        let anotherPawn = Pawn(team: .white)
        let otherPawnPosition = Position(rank: .B, row: .five)
        board[otherPawnPosition] = anotherPawn
        
        let moves = pawn.possibleMovements(from: position, board: board)
        #expect(!moves.contains(otherPawnPosition))
        #expect(moves.contains(Position(rank: .A, row: .five)))
    }
    
    @Test func pawnBlockedByPieceInFrontCannotMoveForward() async throws {
        var board = Board()
        let pawn = Pawn(team: .white)
        let position = Position(rank: .C, row: .three)
        board[position] = pawn
        
        let anotherPawn = Pawn(team: .white)
        let blockedPosition = Position(rank: .C, row: .four)
        board[blockedPosition] = anotherPawn
        let moves = pawn.possibleMovements(from: position, board: board).isEmpty
        #expect(moves)
        
    }
}
@MainActor
struct RookTests{
    @Test func rookOnEmptyBoardCaMoveAllFourDirections() async throws{
        var board = Board()
        let rook = Rook(team: .white)
        let position = Position(rank: .D, row: .four)
        board[position] = rook
        
        let moves = rook.possibleMovements(from: position, board: board)
        
        #expect(moves.contains(Position(rank: .D, row: .one)))
        #expect(moves.contains(Position(rank: .E, row: .four)))
        #expect(moves.contains(Position(rank: .A, row: .four)))
        #expect(moves.contains(Position(rank: .D, row: .five)))
        #expect(moves.contains(Position(rank: .D, row: .eight)))


    }
    @Test func rookStopsBeforeOwnPiece() async throws {
        var board = Board()
        let rook = Rook(team: .white)
        let position = Position(rank: .D, row: .four)
        board[position] = rook
        
        let otherPiece = Pawn(team: .white)
        let otherPosition = Position(rank: .D, row: .six)
        board[otherPosition] = otherPiece
        
        let moves = rook.possibleMovements(from: position, board: board)
        #expect(!moves.contains(Position(rank: .D, row: .eight)))
        #expect(!moves.contains(Position(rank: .D, row: .seven)))
        #expect(moves.contains(Position(rank: .D, row: .three)))
    }
    
    @Test func rookCanCaptureEnemyPieceButNotBeyond() async throws {
           var board = Board()
           let rook = Rook(team: .white)
           let position = Position(rank: .D, row: .four)
           board[position] = rook
           
           let enemyPawn = Pawn(team: .black)
           let enemyPosition = Position(rank: .D, row: .six)
           board[enemyPosition] = enemyPawn
           
           let moves = rook.possibleMovements(from: position, board: board)
           
           #expect(moves.contains(Position(rank: .D, row: .five)))
           #expect(moves.contains(enemyPosition))
           #expect(!moves.contains(Position(rank: .D, row: .seven)))  
       }
}
