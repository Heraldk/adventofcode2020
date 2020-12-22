//
//  day.swift
//  AdventOfCode2020
//
//  Created by Morgan Kan on 29/11/2020.
//

import Foundation

class Day22 : AoCDay {
    
    func readInput( str: String ) -> ([Int],[Int]) {
        var result = [[Int]]()
        for row in str.components(separatedBy: "\n") {
            if row.hasPrefix("Player") {
                result.append([Int]())
            } else if let num = Int(row) {
                result[result.count-1].append(num)
            }
        }
        return (result[0],result[1])
    }
    
    func playGame( p1Deck : [Int], p2Deck : [Int] ) -> [Int] {
        var p1 = p1Deck
        var p2 = p2Deck
        while p1.count > 0 && p2.count > 0 {
            let p1Card = p1.removeFirst()
            let p2Card = p2.removeFirst()
            if( p1Card > p2Card ) {
                p1.append(p1Card)
                p1.append(p2Card)
            } else {
                p2.append(p2Card)
                p2.append(p1Card)
            }
        }
        
        return p1.count > 0 ? p1 : p2
    }
    
    func calcScore( deck: [Int] ) -> Int {
        var score = 0
        for (index, value) in deck.enumerated() {
            score += ((deck.count - index) * value)
        }
        return score
    }
    
    func playRecursiveGame( p1Deck: [Int], p2Deck : [Int] ) -> (Int, [Int]) {
        var p1 = p1Deck
        var p2 = p2Deck
        
        var seen = [Int : [Int : Bool]]()
        while( p1.count > 0 && p2.count > 0 ) {
            let p1Score = calcScore(deck: p1)
            let p2Score = calcScore(deck: p2)
            if let seen1 = seen[p1Score], let seen2 = seen1[p2Score] {
                return (1, p1Deck)
            }
            
            if seen[p1Score] == nil {
                seen[p1Score] = [Int:Bool]()
            }
            seen[p1Score]![p2Score] = true
            
            let p1Card = p1.removeFirst()
            let p2Card = p2.removeFirst()
            if( p1Card > p1.count || p2Card > p2.count ) {
                if( p1Card > p2Card ) {
                    p1.append(p1Card)
                    p1.append(p2Card)
                } else {
                    p2.append(p2Card)
                    p2.append(p1Card)
                }
            } else {
                var newP1Deck = [Int]()
                var newP2Deck = [Int]()
                for i in 0..<max(p1Card,p2Card) {
                    if( i<p1Card ) {
                        newP1Deck.append( p1[i] )
                    }
                    if( i<p2Card ) {
                        newP2Deck.append( p2[i] )
                    }
                }
                let (winner, _) = playRecursiveGame(p1Deck: newP1Deck, p2Deck: newP2Deck)
                if( winner == 1 ) {
                    p1.append(p1Card)
                    p1.append(p2Card)
                } else {
                    p2.append(p2Card)
                    p2.append(p1Card)
                }
            }
        }
        
        if( p1.count > 0 ) {
            return (1, p1)
        } else {
            return (2, p2)
        }
    }
    
    override func problem01() {
        let cards = readInput(str: input)
        let winningDeck = playGame( p1Deck:cards.0, p2Deck:cards.1)
        print( calcScore( deck: winningDeck ))
    }
    
    
    override func problem02() {
        let cards = readInput(str: input)
        let (winner,winningDeck) = playRecursiveGame(p1Deck: cards.0, p2Deck: cards.1)
        print( "\(winner): \(calcScore( deck: winningDeck ))")
    }
    
    let sampleInput = """
    Player 1:
    9
    2
    6
    3
    1

    Player 2:
    5
    8
    4
    7
    10
    """
    
    let sampleInput2 = """
    Player 1:
    43
    19

    Player 2:
    2
    29
    14
    """
    
    let input = """
    Player 1:
    50
    19
    40
    22
    7
    4
    3
    16
    34
    45
    46
    39
    44
    32
    20
    29
    15
    35
    41
    2
    21
    28
    6
    26
    48

    Player 2:
    14
    9
    37
    47
    38
    27
    30
    24
    36
    31
    43
    42
    11
    17
    18
    10
    12
    5
    33
    25
    8
    23
    1
    13
    49
    """
}
