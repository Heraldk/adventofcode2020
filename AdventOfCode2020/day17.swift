//
//  day.swift
//  AdventOfCode2020
//
//  Created by Morgan Kan on 29/11/2020.
//

import Foundation

class Day17 : AoCDay {
    typealias Grid = [Int : [Int : [Int: Bool]]]
    
    func readInput( str: String ) -> Grid {
        // input is just one slice, but return the three dimensional array with one item anyway
        var result = Grid()
        
        var currentSlice = [Int : [Int: Bool]]()
        var y = 0
        for row in str.components(separatedBy: "\n") {
            var currentRow = [Int : Bool]()
            for (x, char) in row.enumerated() {
                if char == "#" {
                    currentRow[x] = true
                } else {
                    currentRow[x] = false
                }
            }
            currentSlice[y] = currentRow
            y += 1
        }
        result[0] = currentSlice
        return result
    }

    func countNeighbours( grid: Grid, x : Int, y : Int, z : Int ) -> Int {
        var count = 0
        for zDiff in -1...1 {
            if let zSlice = grid[z + zDiff] {
                for yDiff in -1...1 {
                    if let ySlice = zSlice[y + yDiff] {
                        for xDiff in -1...1 {
                            if let isActive = ySlice[x + xDiff] {
                                count += isActive ? 1 : 0
                            }
                        }
                    }
                }
            }
        }
        return count
    }
    
    func runIteration( input: Grid ) -> Grid {
        var result = Grid()
        let minSlice = input[0]!.keys.min()!
        let maxSlice = input[0]!.keys.max()!
        
        for z in (-input.count...input.count) {
            var newZSlice = [Int : [Int: Bool]]()
            for y in (minSlice-1...maxSlice+1 ) {
                var newYSlice = [Int : Bool]()
                for x in (minSlice-1...maxSlice+1 ) {
                    var isActive = false
                    if let zSlice = input[z], let ySlice = zSlice[y], let xSlice = ySlice[x] {
                        isActive = xSlice
                    }
                    let neighbours = countNeighbours( grid: input, x : x, y : y, z: z)
                    //print( "\(x) \(y) \(z) \(isActive) \(neighbours)")
                    if isActive {
                        newYSlice[x] = (neighbours == 3 || neighbours == 4) // note: countNeighbours counts itself if set, so these are higher than the problem def by one
                    } else {
                        newYSlice[x] = (neighbours == 3)
                    }
                }
                newZSlice[y] = newYSlice
            }
            result[z] = newZSlice
        }
        
        return result
    }
    
    func countActive( input : Grid ) -> Int {
        var count = 0
        for z in input.keys {
            for y in input[z]!.keys {
                for (_,isActive) in input[z]![y]! {
                    count += isActive ? 1 : 0
                }
            }
        }
        return count
    }
//    
//    func printGrid( input : Grid ) {
//        for z in input.keys.sorted() {
//            print( "z=\(z)")
//            for y in input[z]!.keys.sorted() {
//                for (_,isActive) in input[z]![y]! {
//                    if( isActive ) {
//                        print( "#", terminator: "" )
//                    } else {
//                        print( ".", terminator: "" )
//                    }
//                }
//                print()
//            }
//            print()
//        }
//    }
    
    override func problem01()
    {
        var grid = readInput(str: input)
        
        for _ in 1...6 {
            grid = runIteration(input: grid)
        }
            
        print( countActive(input: grid) )
    }
    
    typealias HyperCube = [Int : Grid]
    
    func countNeighbours( cube: HyperCube, x : Int, y : Int, z : Int, w : Int ) -> Int {
        var count = 0
        for wDiff in -1...1 {
            if let wSlice = cube[w + wDiff] {
                count += countNeighbours(grid: wSlice, x: x, y: y, z: z)
            }
        }
        return count
    }
    
    func runIteration( input: HyperCube ) -> HyperCube {
        var result = HyperCube()
        let minSlice = input[0]![0]!.keys.min()!
        let maxSlice = input[0]![0]!.keys.max()!
        
        for w in (-input.count...input.count) {
            var newWSlice = Grid()
            for z in (-input[0]!.count...input[0]!.count) {
                var newZSlice = [Int : [Int: Bool]]()
                for y in (minSlice-1...maxSlice+1 ) {
                    var newYSlice = [Int : Bool]()
                    for x in (minSlice-1...maxSlice+1 ) {
                        var isActive = false
                        if let wSlice = input[w], let zSlice = wSlice[z], let ySlice = zSlice[y], let xSlice = ySlice[x] {
                            isActive = xSlice
                        }
                        let neighbours = countNeighbours( cube: input, x : x, y : y, z: z, w: w)
                        //print( "\(x) \(y) \(z) \(isActive) \(neighbours)")
                        if isActive {
                            newYSlice[x] = (neighbours == 3 || neighbours == 4)
                        } else {
                            newYSlice[x] = (neighbours == 3)
                        }
                    }
                    newZSlice[y] = newYSlice
                }
                newWSlice[z] = newZSlice
            }
            result[w] = newWSlice
        }
        
        return result
    }
    
    func countActive( input: HyperCube ) -> Int {
        var count = 0
        for w in input {
            count += countActive(input: w.value)
        }
        return count
    }
    
    override func problem02()
    {
        let grid = readInput(str: input)
        var cube = [0 : grid]
        
        for _ in 1...6 {
            cube = runIteration(input: cube)
        }
            
        print( countActive(input: cube) )
    }
    
    let sampleInput = """
    .#.
    ..#
    ###
    """
    
    let input = """
    ##.#...#
    #..##...
    ....#..#
    ....####
    #.#....#
    ###.#.#.
    .#.#.#..
    .#.....#
    """
}
