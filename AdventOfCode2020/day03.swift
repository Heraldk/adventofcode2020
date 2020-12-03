//
//  day.swift
//  AdventOfCode2020
//
//  Created by Morgan Kan on 29/11/2020.
//

import Foundation

class Day03 : AoCDay {
    
    func readInput(input : String) -> [[Character]] {
        var result = [[Character]]()
        
        for row in input.components(separatedBy: "\n") {
            result.append( [Character]() )
            for char in row {
                result[result.count-1].append(char)
            }
        }
        
        return result
    }
    
    // this is simple implementation that uses mod to wrap around the map
    func calculateTreesHit( grid : [[Character]], slope : (x: Int, y: Int) ) -> Int {
        var coords = (x: 0, y: 0)
        var treeCount = 0
        while coords.y < grid.count {
            if grid[coords.y][coords.x] == "#" {
                treeCount += 1
            }
            coords.x = (coords.x + slope.x) % grid[0].count
            coords.y += slope.y
        }
        return treeCount
    }
    
    override func problem01()
    {
        let grid = readInput(input: input)
        let slope = (x : 3, y: 1)
        
        print( "Tree Hit for part 1: \(calculateTreesHit( grid: grid, slope: slope ))" )
        
        // part 2:
        
        let slopes = [(x:1, y:1), (x:3, y:1), (x:5, y:1), (x:7, y:1), (x:1, y:2)]
        var multipliedTreesHit = 1
        for nextSlope in slopes {
            let treesHit = calculateTreesHit(grid: grid, slope: nextSlope)
            print( treesHit )
            multipliedTreesHit *= treesHit
        }
        print( "Multiplied trees hit: \(multipliedTreesHit)" )
    }
    
    let input = """
    .#....#..##.#..####....#.......
    ......#..#....#....###......#.#
    #..#.....#..............##.#.#.
    #.#...#....#...#......##..#..#.
    ...#..#.##..#..#........###.#.#
    ...#.#..........#.........##...
    ...#.#....#.#....#..#......#...
    ..##.#.....#.......#.###..#..##
    ..#.......#.......#....##......
    ....##........##.##...#.###.##.
    #.......#.......##..#......#...
    ..##.............##.#......#...
    ...#.####....#.....#...##......
    .............##.#......#.......
    ..#...#....#......#....#.......
    ..#....#..#............#.......
    ##...#..#........##..#......#..
    ##........##........#.#.......#
    #.......#........#.#..#....###.
    .....#..#.#..........##...#....
    ..##...#......#.#...#..#...#...
    ##.##...#......#....#....#...#.
    #.......#..#.#..#....#..###.#.#
    #.............#.#....#..#.#....
    ...#.......###.#.##.##.#...#..#
    .##.......##..##...#..###......
    .......#.#.#.#..####..#..#..#..
    ...##......#.#.##.###....#.###.
    ###......###......#.#####..#...
    ..#........##..#..##.##..#...#.
    .....##..#...#..#.##.....#.#...
    #......#.##....#..##.#....#.#..
    ##.#.##..#................#....
    ......#.#....#......##.....#...
    ..#...##..#..#...#..#.#..#.....
    ........#.#.#.##...#.#.....#.#.
    #.#......#.....##..#...#.......
    ..#.#......#...........###.....
    ......##....#....##..#..#.#.#.#
    ##....#.###...#......#..#...#..
    #.#.##....###...####.......#..#
    ##...........#.....#........#.#
    .##.#..#.....#......#.......#..
    ##..##..###....#.........##....
    ..#..#..#.##...#.#...#........#
    #.##.###...#.......#...........
    .........#.................#...
    #.##...#.....#..##........#....
    ....#.#...##...#...........#...
    .#.....#.#..#...##..##.....#...
    .#.....####....#..##..#........
    ...#..#......##.#..##.#.#.#..#.
    .##.#.....#.....#...#.......##.
    ......#..#..#......#...####....
    .......#......##..#..##.....#..
    ......#.#..#...#..#.#..........
    ....##.........#...............
    .#....#..##.....#....##.##.....
    #.#.....#...#....####....#.#...
    #.....#....#.#...#.............
    ...#..#.....#....##..#..#......
    ...#.#............#...........#
    ###.#..#.#......#.....##.....#.
    ####....#....###.....#..#.#####
    .###..#...#.#..#......##.#.#.#.
    .....#.##.#....#..##....#..#..#
    ...#....#...##.....#......#.#..
    ....#...#....#...#....#.....#.#
    .#.....#.....#.#..#......#..#..
    ..#..##....##.##....#.....##...
    #..##...#.##...#..#.#.#.....#..
    ...#..##.#..#....#.#....######.
    ..........#..#.....#....#...##.
    #.#####.#.###..#.....#.........
    #....#......#..#.#.##.##..###..
    ..#...###.#.#....##.##...##....
    .......#....#..#...##......#...
    ...#.#...#..#.....#..##.#......
    ###..##...........#............
    ..#....#.##....#.#..##...#.....
    ##....#...#....#.....#.#..##...
    ..............#.##.#..#..##.###
    ......#..#..#..#.#....###...##.
    .#...#..#.#.#....#..........#..
    ..#.#.....#..#...........#.##..
    ...#.#......#......#..#..#.#...
    ...#....#.#.#.....#...#.##..#..
    .#.#..#...#........##.......#..
    ##..........#..#...#....###.#..
    #.....###......#..#.#.#....#.#.
    ..###.......#.#...............#
    #....#.....#.#......#..##.##...
    #.##.#.#....#..#.#...#.#...#..#
    #....#..#...........#.......#..
    ...#.####.....#.........###.##.
    ......#..#.....#..........#..#.
    #...#.#..####...#...#.#.##...##
    .##.........#......#.#.#.......
    .......##...##.##....###...##..
    ...#..#....#..#.#.#.....#.#....
    #....#.#.#.......##..###..##...
    ......#............#.#...#..#..
    #.#.....#......#...#.......###.
    ...#.#................#...#....
    .....#......#.#..#...##.#.#...#
    #....#.#..#..#..##..#.##..#....
    #.................#..#....#....
    ..#....#.......####....###.....
    .#..#.#.#...###..#...#..###....
    ..#..#.#......#.###..........#.
    .....#......#.......##....##.#.
    .#....#........#.#.##.#........
    #.#..##..#..#.#...####....##...
    ...#....#.#..#...#..........#..
    .#.....#.##....#...##..........
    ....##....#.....#.....#...#.###
    .#...##.#.#..##..#...#.#..#..#.
    ..#.......#.##.....#.#........#
    ...#...#.....##..#.#.#....#....
    ...#.....#.......##.........#.#
    .##.....#..#.#...#.#...#.#...#.
    ...........#...#.###..#...#..#.
    #.##........#..###.##...####...
    .#.....#.#...##...#..#..#...##.
    ..#....#..#...#.....#.....##...
    ..###..#.#.....##........#.##..
    .#.#..##........#.##....#..#.##
    .####.#..##..#.#..#....##....#.
    .##....##...#.#........#.......
    ....#..#..#...#..#..#..#.#.....
    ...#......................#....
    #.....#.#....#..#..#.#..#....#.
    ##.....#.....##..........###...
    .#..#..............#...##.#.#.#
    ...#...#.#.............#.#..#.#
    ..#.....#.......#......#.#.....
    .###.#..#..#..#.#..#.....#.....
    .....##..##...##.......#....###
    .#........###...##..#....##....
    #....#.#......##..#....#.##..#.
    #....#.#...#........##...###...
    .#.....#...#.###....#.##.#.####
    ###......#....#...#....##..#..#
    ##....#..###......#...#.#.#....
    ..........#......##.#..#.......
    .#..#......###.........##...#..
    ....#......#....#.........#.#.#
    ##.#.#...#.#...#...#..#......#.
    ....#.##.........#..#.....##.#.
    ........#...#..#.#.#.#.....##..
    ..#......#.#.#..#.....##.......
    ..............#....#....##.#..#
    ....#.#.....#....#.#.###.#....#
    ..#..........#..#......#.##..#.
    ...#...#.#.............#..#....
    #.......#..#..##.........##..#.
    ..##..#............#.....#.....
    ....#.#..##...#.#..#.........#.
    ........#.......#.##....#....#.
    ...#.....#.#.....#.#....#......
    ..#......##.#.............#.#.#
    #.#.............#.#.....#......
    .##....##.#.....#....#...##....
    .#.#....##....#.....##.........
    ...#.....#.....#.....#..#.###..
    .......#....#...##.#...#...#..#
    ..#.#.......#...###.#...#....#.
    .....###..##....###.#.##.......
    ....#..................##.#.##.
    .#.......###.##...#.#.....#....
    ....#....##...##.....#.#...#..#
    #..#.....#......##...#....#....
    #..##.........#.....#...#......
    ...#..##.......##......#..#####
    .#..###.###.#.##........#......
    .#...#....#....#.#....#...##...
    ##........#....#.........##..#.
    .#.....##............#.#.......
    ....#....#...........###.....##
    .#......#.#.#..#....#.#.....##.
    ......#.##.#..##....#.#.#..#...
    #....#......#...#..####........
    ......#..#..##..#.......#.#..#.
    ##....##.###.#...#.##.#..#.###.
    .#.........#...##...#.#......#.
    ..#.#...........####.#....##.##
    .....#.#..##.#...###...#..#.#..
    ...#..#..##.#...#.....#.##...##
    ..##......##..........#..###...
    .#......##.....#.##....#.#.##.#
    ...#.......##..##.....#....#...
    .##...#...#....#..#............
    #..#....#...........#..........
    ......#...#.#.......#...#.##..#
    ..#.###..#.....#.....#..#.....#
    ....#....#..........##....#..#.
    .......##.#.#.#......#....#...#
    ####..#.###........#..#......#.
    #........##.#.#.#.............#
    .#......#......#..#.##.....#...
    .....##.##......##.#.....#.#.#.
    .......##.#.....##.......#.#.#.
    .#.#..#.#..#.##...#.#....#.#..#
    .#..##....#..#...##.......#..#.
    .#.#..#.......#................
    #........#.#.#......#.#.#.#....
    ##......#...#..##.#...##.##....
    ##.#..#...........##...#..###..
    ......#.####...#........#.#.#..
    ...#........##..###.#.#...#...#
    .#.....##..#......##......###..
    ..#.#...#......#..#..##.#.....#
    #....#..#.#..........#...#.....
    .#......#.##..###..#.#....#..##
    .......#.......#..#..#......#..
    ..##.....##.#..#..#.....##.....
    ........#.##...#.#.#..#..#..#..
    ...#.######.........#.....#..##
    .#.#............#....#.........
    #...#....###.#......#.#........
    #.........#....#...##..........
    ....#...........#.###.#...###..
    .........#........#.#.#..#...#.
    .#.......#.#.....#.#.....#.##..
    .....#.......#.....#.#.#.......
    #.##..#..##.......#...#......#.
    .###.....##...##.#...##.##.#.#.
    ...#......##..##............#.#
    ...#......................#..##
    #..#..#................#...#...
    #..#....#.#.#...##.......#..#..
    ....#.#..###.##...#..#.###..#..
    ..#...#....####.#............#.
    ......#....#.#...#.#.#.........
    #...#........#.....##..###.#..#
    #....#...#...##...#..#....##...
    #..#...#..#.......#.#..##.#..#.
    #.#..........#...........##....
    .#...###...#......#.......#.#.#
    .........#.........#...#...##..
    ##.#..###......##..#.....#..#..
    ....##...............#.....#...
    .....#.....###.#.....#.#.......
    ....#..#......###..#..##..#....
    ......................#.....#..
    ..#..#...##....##....#........#
    ..#....#...#...#.......#.....#.
    ...##.#.#.##......#.#.#.#.####.
    .###...#..#......#.#..#........
    #..#...##.#..#..##..##....#...#
    ...#...#..#..#..#........#..##.
    .##....#.##.#....#...#.#.#....#
    #..#....#..#....#.......##..#.#
    ...#.#....####...........#...#.
    #...#####...#.#..#......#...#.#
    .##....#.#.#..#......#..##.....
    ..........#..#.#.#.....##......
    .....#....#..................#.
    .........#...#...#....#..###...
    .#.#.#....#....................
    ......##............##.###..#..
    #.#...#........####.##..#.#.##.
    #........#.#.#.#..#.##.....#...
    ......####..#.##.......#....#..
    .........#...#...#.....#.......
    ..##.....#...#...#.....##.....#
    ....#...##....#.....#..#..##.##
    ..#.........##...##..###..#....
    #....#.#.........##.###.#...##.
    .##...#....#..#..#.#....##.....
    ##..#..#..#...........#.##....#
    ....#..........#...#..#.....#..
    ........###..#..#.#.#.....##...
    #...#...#..###............###..
    ..#.....#.#.#..#..#.#..#......#
    ..#...##..#....#...#......#....
    #....#........##.....#..##....#
    #.....#.#.#..#.......##.#.#.##.
    ..##...#...#.....#..........#..
    ##.....#....#......#..........#
    ......#..#..........#.#..####..
    ......#...#............##...##.
    ..#.......##.......#...###.###.
    .#..#.#.#...#..##.#......#.#...
    .##.....##.#.#...#.##.........#
    #.#.######...........#.#####.#.
    ........#.##...##....##.#.##.#.
    ....#......#.....#.....###...##
    #..............#.#....#.#....#.
    ....#..###.#.........##.#.#....
    ..#.#.#..##....####..........#.
    ...#..#.......#................
    ...#....#..............#....#..
    .....#...#...#....#.#.#..#...#.
    ......##.............###.##..##
    .#...#.#..#......#..#.##.......
    ##.....#.....#.##...#....#.....
    ..#..#.#.#.#.#..........#..###.
    ##..........#........#....#.#..
    .....#...#........#.#..###....#
    .###.#........#.##......#.#...#
    #...##....#....#....##.#.#.....
    .....#.#............#..........
    ..#.##....................#....
    .....#..#..#.#..#.##.......#...
    .....###......#......##......##
    #.....#.#.......##.......#...#.
    .#.#...#......#..###...#.....#.
    #.#..#...#..##.....#...#.#..#..
    .....#.#..........#..#.........
    .###..##..##.....#...#...#..##.
    #...#.#....#.......##..#.......
    ###...#.#.#..#.......#......#..
    ....##........#..........##....
    ............#....#...........#.
    #..#.#....##..#.#..#......##...
    .###....##...#....##..........#
    .###........#........###.....#.
    ...#...#.#......#...#....#.....
    .###.......#.........#.........
    ....##.#......#...###......##.#
    .###...#..##.....##.......#....
    .#.#...#..#.##....#........#...
    """
    
    let testInput = """
    ..##.......
    #...#...#..
    .#....#..#.
    ..#.#...#.#
    .#...##..#.
    ..#.##.....
    .#.#.#....#
    .#........#
    #.##...#...
    #...##....#
    .#..#...#.#
    """
}
