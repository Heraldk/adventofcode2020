//
//  day.swift
//  AdventOfCode2020
//
//  Created by Morgan Kan on 29/11/2020.
//

import Foundation

class Day15 : AoCDay {
    override func problem01()
    {
        var seenMap = [Int : Int]()
        var lastNumber = 0
        
        let theInput = input
        
        for counter in 1...theInput.count {
            if counter > 1 {
                seenMap[lastNumber] = counter - 1
            }
            lastNumber = theInput[counter-1]
        }
        
        for counter in theInput.count ..< 30000000 {
            var nextNumber = 0
            if let seenNum = seenMap[lastNumber] {
                nextNumber = counter - seenNum
            }
            
            if counter == 2020 {
                print( lastNumber )
            }
            
            seenMap[lastNumber] = counter
            lastNumber = nextNumber
        }
        print( lastNumber )
    }
   
    let sampleInput = [0,3,6]
    
    let input = [15,12,0,14,3,1]
}
