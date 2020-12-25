//
//  day.swift
//  AdventOfCode2020
//
//  Created by Morgan Kan on 29/11/2020.
//

import Foundation

class Day25 : AoCDay {
    
    static let Divisor = 20201227
    
    func performLoop(val: Int, subjectNumber: Int, loopSize: Int) -> Int {
        var value = val
        for _ in 1...loopSize {
            value *= subjectNumber
            value %= Day25.Divisor
        }
        return value
    }
    
    func determineLoopSize(publicKey: Int) -> Int {
        var loopCount = 1
        var value = 1
        let subjectNumber = 7
        while( true ) {
            value = performLoop(val: value, subjectNumber: subjectNumber, loopSize: 1)
            if( value == publicKey ) {
                return loopCount
            }
            
            loopCount += 1
        }
    }
    
    override func problem01()
    {
        let publicKeyInput = input.components(separatedBy: "\n")
        let cardPublicKey = Int(publicKeyInput[0])!
        let doorPublicKey = Int(publicKeyInput[1])!
        
        let cardLoopSize = determineLoopSize(publicKey: cardPublicKey)
        let doorLoopSize = determineLoopSize(publicKey: doorPublicKey)
        print( cardLoopSize )
        print( doorLoopSize )
        
        print( performLoop(val: 1, subjectNumber: cardPublicKey, loopSize: doorLoopSize))
        print( performLoop(val: 1, subjectNumber: doorPublicKey, loopSize: cardLoopSize))
    }
    
//    override func problem02()
//    {   
//    }
    
    let sampleInput = """
    5764801
    17807724
    """
    
    let input = """
    14222596
    4057428
    """
}
