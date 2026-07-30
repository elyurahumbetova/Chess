//
//  Utils.swift
//  Chess
//
//  Created by Elyura on 29.07.26.
//

import SwiftUI


enum Team: Equatable {
    case white, black

    var opponent: Team {
        self == .white ? .black : .white
    }

    var pieceColor: Color {
        switch self {
        case .white:
            return .white
        case .black:
            return .black
        }
    }
}

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

extension Team: CustomStringConvertible {
    var description: String {
        switch self {
        case .white:
            return "white"
        case .black:
            return "black"
        }
    }
}


protocol ArtificialIntelligence {
    var name: String { get }
    func selectMove(for board: Board, team: Team) -> Move?
}

enum GameMode {
    case offline
    case online
}

enum Player {
    case human
    case ai(ArtificialIntelligence)
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


enum Rank: Int, CaseIterable {
    case A = 1, B, C, D, E, F, G, H

    var letter: String {
        String(describing: self)
    }
}

enum Row: Int, CaseIterable {
    case one = 1, two, three, four, five, six, seven, eight
}


struct Position: Equatable, Hashable {
    let rank: Rank
    let row: Row

    var algebraic: String {
        "\(rank.letter)\(row.rawValue)"
    }

    var arrayIndex: (row: Int, col: Int) {
        (row: row.rawValue - 1, col: rank.rawValue - 1)
    }
}

enum PieceType: CaseIterable {
    case pawn, knight, bishop, rook, queen, king

    var symbol: String {
        switch self {
        case .pawn:   return "♟"
        case .knight: return "♞"
        case .bishop: return "♝"
        case .rook:   return "♜"
        case .queen:  return "♛"
        case .king:   return "♚"
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


protocol Piece: Identifiable {
    var id: UUID { get }
    var team: Team { get }
    
    func canMove() -> Bool
    func move()
    func possibleMovements(board: Board) -> [Position]
}

class Pawn : Piece {
    var id: UUID
    var team: Team
    
    init(team: Team) {
        self.id = UUID()
        self.team = team
    }
    
    func canMove() -> Bool {
        <#code#>
    }
    
    func move() {
        <#code#>
    }
    
    func possibleMovements(board: Board) -> [Position] {
        <#code#>
    }
    
    
}


struct Move {
    let from: Position
    let to: Position
    let piece: Piece
    let capturedPiece: Piece?
    var isCastling: Bool = false
    var isEnPassant: Bool = false
    var isPromotion: Bool = false
    var promotedTo: PieceType? = nil
    let timestamp: Date = Date()
}


struct Board {
    var squares: [[Piece?]] = Array(
        repeating: Array(repeating: nil, count: 8),
        count: 8
    )
    
    var turn = Team.white

    subscript(position: Position) -> Piece? {
        get {
            let index = position.arrayIndex
            return squares[index.row][index.col]
        }
        set {
            let index = position.arrayIndex
            squares[index.row][index.col] = newValue
        }
    }
}


struct GameState {
    var board: Board = Board()
    var currentTurn: Team = .white
    var moveHistory: [Move] = []
    var capturedPieces: [Piece] = []

    var whiteCanCastleKingside: Bool = true
    var whiteCanCastleQueenside: Bool = true
    var blackCanCastleKingside: Bool = true
    var blackCanCastleQueenside: Bool = true

    var enPassantTarget: Position? = nil

    var isCheck: Bool = false
    var isCheckmate: Bool = false
    var isStalemate: Bool = false
    var isDraw: Bool = false
    var winner: Team? = nil

    var halfMoveClock: Int = 0
    var fullMoveNumber: Int = 1
}
