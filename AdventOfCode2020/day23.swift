//
//  day.swift
//  AdventOfCode2020
//
//  Created by Morgan Kan on 29/11/2020.
//

import Foundation

class Day23 : AoCDay {
    
    struct State : CustomStringConvertible {
        
        var lookup : [Int : (prev : Int, next: Int)]
        var current : Int
        
        let maxVal : Int
        
        init( _ str: String, isPartTwo: Bool ) {
            var nums = [Int]()
            for char in str {
                nums.append( Int(String(char))! )
            }
            
            let localMaxVal = nums.max()! 
            if( isPartTwo ) {
                maxVal = 1000000
            } else {
                maxVal = localMaxVal
            }
            
            lookup = [Int : (prev: Int, next: Int)]()
            for (index, num) in nums.enumerated() {
                let prev = (index > 0) ? nums[index-1] : nums[nums.count - 1]
                let next = (index + 1 < nums.count) ? nums[index+1] : nums[0]
                lookup[num] = (prev,next)
            }
            
            if isPartTwo {
                lookup[nums[0]]!.prev = maxVal
                lookup[nums[nums.count-1]]!.next = localMaxVal + 1
                var prev = nums[nums.count-1]
                for x in (localMaxVal+1)...maxVal {
                    let next = x == maxVal ? nums[0] : x+1
                    lookup[x] = (prev,next)
                    prev = x
                }
            }
            
            current = nums[0]
        }
        
        var description : String {
            var str = ""
            
            var curVal = current
            repeat {
                str.append( " \(curVal) ")
                curVal = lookup[curVal]!.next
            } while current != curVal
            
            return str
        }
        
        mutating func makeMove() {
            
            var curVal = current
            var pickup = [Int]()
            for _ in 1...3 {
                curVal = lookup[curVal]!.next
                pickup.append(curVal)
            }
            // remove the picked up cups from where they are
            let lastPickup = pickup.last!
            lookup[current]!.next = lookup[curVal]!.next
            lookup[lookup[lastPickup]!.next]!.prev = current
            
            // pick the destination label
            var destination = current > 1 ? current - 1 : maxVal
            while pickup.contains(destination) {
                destination = destination > 1 ? destination - 1 : maxVal
            }
            // insert the picked up cups

            let nextPlusOne = lookup[destination]!.next
            lookup[destination]!.next = pickup[0]
            lookup[pickup[0]]!.prev = destination
            lookup[lastPickup]!.next = nextPlusOne
            lookup[nextPlusOne]!.prev = lastPickup
            
            // update the current item
            current = lookup[current]!.next
        }
        
        func printAfterOne() {
            var val = lookup[1]!.next
            while val != 1 {
                print( val, terminator: "" )
                val = lookup[val]!.next
            }
            print()
        }
    }
    
    func makeMoves( startState: State, moves : Int ) -> State {
        var state = startState
        //print(state)
        for _ in 1...moves {
            
            state.makeMove()
            //print(state)
        }
        //print(state)
        return state
    }
    
    override func problem01()
    {
        var state = State(input, isPartTwo: false)
        state = makeMoves(startState: state, moves: 100)
        state.printAfterOne()
    }
    
    override func problem02()
    {
        var state = State(input, isPartTwo: true)
        state = makeMoves(startState: state, moves: 10000000)
        let cup1 = state.lookup[1]!.next
        let cup2 = state.lookup[cup1]!.next
        print( "\(cup1) \(cup2): \(cup1 * cup2)")
    }
    
    let sampleInput = """
    389125467
    """
    
    let input = """
    712643589
    """
}
