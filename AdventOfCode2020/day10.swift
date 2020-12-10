//
//  day.swift
//  AdventOfCode2020
//
//  Created by Morgan Kan on 29/11/2020.
//

import Foundation

class Day10 : AoCDay {
    
    // recursive function: counts all valid sequences of adaptors that get you from startingVoltage to the last item in the seq
    func countValidSubsequences( startingVoltage: Int, seq : ArraySlice<Int> ) -> Int {
        if seq.first! - 3 > startingVoltage {
            return 0
        } else if seq.count == 1 {
            // last item is within 3 so this is a full valid sequence. Count it.
            return 1
        }
        
        // see how many valid sequences we get by including the adapter at the start of the sequence
        // and how many if we don't include it
        return countValidSubsequences(startingVoltage: startingVoltage, seq: seq.dropFirst( 1 )) +
            countValidSubsequences(startingVoltage: seq.first!, seq: seq.dropFirst( 1 ))
    }
    
    func splitSortedVoltagesIntoChains( sortedVoltages: [Int] ) -> [ArraySlice<Int>] {
        var result = [ArraySlice<Int>]()
        // look for differences of 3 voltage since those are bridges that must be closed by including both adaptors
        var startIndex = 0
        for currentIndex in 1 ..< sortedVoltages.count {
            if sortedVoltages[currentIndex] - sortedVoltages[currentIndex-1] == 3 {
                result.append( sortedVoltages[startIndex...currentIndex] )
                startIndex = currentIndex
            }
        }
        return result
    }

    override func problem01()
    {
        var nums = [0] // starting voltage is zero
        for row in input.components(separatedBy: "\n") {
            nums.append( Int(row)! )
        }
        nums.append( nums.max()! + 3 ) // add the device we want to connect's voltage: 3 higher than the max of our input
        
        nums.sort()
        var differences = [Int : Int]()
        for i in 1..<nums.count {
            let diff = nums[i] - nums[i-1] 
            differences[ diff ] = (differences[diff] ?? 0) + 1
        }
        print( differences )
        print( differences[1]! * differences[3]! )
        
        let splitIntoChunks = splitSortedVoltagesIntoChains(sortedVoltages: nums)
        
        let total = splitIntoChunks.reduce(into: 1, { 
            $0 *= countValidSubsequences(startingVoltage: $1.first!, seq: $1.dropFirst())
        })
        print( total )
    }
    
    let sampleInput = """
    16
    10
    15
    5
    1
    11
    7
    19
    6
    12
    4
    """
  
    let sampleInput2 = """
    28
    33
    18
    42
    31
    14
    46
    20
    48
    47
    24
    23
    49
    45
    19
    38
    39
    11
    1
    32
    25
    35
    8
    17
    7
    9
    4
    2
    34
    10
    3
    """
    
    let input = """
    67
    118
    90
    41
    105
    24
    137
    129
    124
    15
    59
    91
    94
    60
    108
    63
    112
    48
    62
    125
    68
    126
    131
    4
    1
    44
    77
    115
    75
    89
    7
    3
    82
    28
    97
    130
    104
    54
    40
    80
    76
    19
    136
    31
    98
    110
    133
    84
    2
    51
    18
    70
    12
    120
    47
    66
    27
    39
    109
    61
    34
    121
    38
    96
    30
    83
    69
    13
    81
    37
    119
    55
    20
    87
    95
    29
    88
    111
    45
    46
    14
    11
    8
    74
    101
    73
    56
    132
    23
    """
}
