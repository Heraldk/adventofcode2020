//
//  day.swift
//  AdventOfCode2020
//
//  Created by Morgan Kan on 29/11/2020.
//

import Foundation

class Day13 : AoCDay {
    override func problem01()
    {
        let vals = input.components(separatedBy: CharacterSet(charactersIn: ",\n"))
        let timestamp = Int(vals[0])!
        var soonestBusId = -1
        var soonestBusWait = -1
        for i in 1..<vals.count {
            if let busId = Int(vals[i]) {
                let timeToWait = busId - (timestamp % busId)
                if soonestBusWait < 0 || timeToWait < soonestBusWait {
                    soonestBusWait = timeToWait
                    soonestBusId = busId
                }
            }
        }
        print( "\(soonestBusId) \(soonestBusWait) \(soonestBusId * soonestBusWait)" )
    }
    
    func findNextCycle( startTime: Int, cycleLength: Int, busId: Int, offset: Int ) -> (timestamp: Int, cycleLength: Int) {
        
        var currentTime = startTime
        while (currentTime + offset) % busId != 0 {
            currentTime += cycleLength
        }
        
        return (currentTime, cycleLength * busId)
    }
    
    override func problem02()
    {   
        let vals = input.components(separatedBy: CharacterSet(charactersIn: ",\n"))
        
        var timestamp = 0
        var cycleLength = -1
        
        for i in 1..<vals.count {
            if let busId = Int(vals[i]) {
                if cycleLength < 0 {
                    cycleLength = busId
                } else {
                    (timestamp, cycleLength) = findNextCycle(startTime: timestamp, cycleLength: cycleLength, busId: busId, offset: i-1)
                }
            }
        }
        print( timestamp )
    }
    
    let sampleInput = """
    939
    7,13,x,x,59,x,31,19
    """
    
    let sampleInput2 = """
    939
    1789,37,47,1889
    """
    
    let input = """
    1001287
    13,x,x,x,x,x,x,37,x,x,x,x,x,461,x,x,x,x,x,x,x,x,x,x,x,x,x,17,x,x,x,x,19,x,x,x,x,x,x,x,x,x,29,x,739,x,x,x,x,x,x,x,x,x,41,x,x,x,x,x,x,x,x,x,x,x,x,23
    """
}
