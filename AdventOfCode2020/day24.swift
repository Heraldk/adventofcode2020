//
//  day.swift
//  AdventOfCode2020
//
//  Created by Morgan Kan on 29/11/2020.
//

import Foundation

class Day24 : AoCDay {
    
    struct HexGrid {
        var grid = [Int : [Int : Bool]]()
        var maxX = 0, maxY = 0
        
        func pathToCoordinates( path str : String ) -> (Int,Int) {
            var x = 0, y = 0
            var path = str
            while path.count > 0 {
                var prefix = ""
                prefix.append( path.removeFirst() )
                if prefix == "s" || prefix == "n" {
                    prefix.append( path.removeFirst() )
                }
                switch( prefix ) {
                    case "ne":
                        x += (y % 2 == 0) ? 1 : 0
                        y += 1
                    case "nw":
                        x -= (y % 2 == 0) ? 0 : 1
                        y += 1
                    case "e":
                        x += 1
                    case "w":
                        x -= 1
                    case "se":
                        x += (y % 2 == 0) ? 1 : 0
                        y -= 1
                    case "sw":
                        x -= (y % 2 == 0) ? 0 : 1
                        y -= 1
                    default: break
                }
            }
            return (x, y)
        }
        
        mutating func flipTile( path : String ) {
            let (x,y) = pathToCoordinates( path: path )
            if grid[y] == nil {
                grid[y] = [Int : Bool]()
            }
            grid[y]![x] = !(grid[y]![x] ?? false)
            maxY = max( abs(y), maxY )
            maxX = max( abs(x), maxX )
        }
        
        func getTile( x: Int, y: Int ) -> Bool {
            if let yLookup = grid[y], let xLookup = yLookup[x] {
                return xLookup
            }
            return false
        }
        
        static let evenShift = [(1,0),(1,1),(0,1),(-1,0),(0,-1),(1,-1)]
        static let oddShift = [(1,0),(-1,1),(0,1),(-1,0),(0,-1),(-1,-1)]
        
        func countBlackTileNeighbours( x: Int, y: Int ) -> Int {
            var count = 0
            
            let shift = (y % 2 == 0) ? HexGrid.evenShift : HexGrid.oddShift
            for (shiftX, shiftY) in shift {
                if( getTile( x: x+shiftX, y: y+shiftY) ) {
                    count += 1
                }
            }
            return count
        }
        
        mutating func rolloutDay() {
            var newGrid = [Int : [Int : Bool]]()
            
            maxX += 1
            maxY += 1
            
            for y in -maxY...maxY {
                newGrid[y] = [Int : Bool]()
                for x in -maxX...maxX {
                    let blackTileNeighbours = countBlackTileNeighbours( x: x, y: y )
                    if getTile(x: x, y: y) {
                        if( blackTileNeighbours == 1 || blackTileNeighbours == 2 ) {
                            newGrid[y]![x] = true
                        }
                    } else if (blackTileNeighbours == 2) {
                        newGrid[y]![x] = true
                    }
                }
            } 
            
            grid = newGrid
        }
        
        func countBlackTiles() -> Int {
            var count = 0
            for (_,vals) in grid {
                count += vals.reduce(into: 0, {
                    $0 += $1.value ? 1 : 0
                })
            }
            return count
        }
        
        func printGrid() {
            for y in -maxY...maxY {
                if y % 2 != 0 {
                    print( " " , terminator: "" )
                }
                for x in -maxX...maxX {
                    if( getTile( x: x, y: y ) ) {
                        print( " X", terminator: "" )
                    } else {
                        print( " .", terminator: "" )
                    }
                }
                print()
            }
        }
    }
    
    override func problem01()
    {
        var grid = HexGrid()
        for row in input.components(separatedBy: "\n") {
            grid.flipTile(path: row)
        }
        
        print( grid.countBlackTiles() )
    }
    
    override func problem02()
    {
        var grid = HexGrid()
        for row in input.components(separatedBy: "\n" ) {
            grid.flipTile(path: row)
        }
        
        for day in 1...100 {
            grid.rolloutDay()
            print( "Day \(day): \(grid.countBlackTiles())" )
        }
    }
    
    let simpleInput = """
    esew
    nwwswee
    """
    
    let sampleInput = """
    sesenwnenenewseeswwswswwnenewsewsw
    neeenesenwnwwswnenewnwwsewnenwseswesw
    seswneswswsenwwnwse
    nwnwneseeswswnenewneswwnewseswneseene
    swweswneswnenwsewnwneneseenw
    eesenwseswswnenwswnwnwsewwnwsene
    sewnenenenesenwsewnenwwwse
    wenwwweseeeweswwwnwwe
    wsweesenenewnwwnwsenewsenwwsesesenwne
    neeswseenwwswnwswswnw
    nenwswwsewswnenenewsenwsenwnesesenew
    enewnwewneswsewnwswenweswnenwsenwsw
    sweneswneswneneenwnewenewwneswswnese
    swwesenesewenwneswnwwneseswwne
    enesenwswwswneneswsenwnewswseenwsese
    wnwnesenesenenwwnenwsewesewsesesew
    nenewswnwewswnenesenwnesewesw
    eneswnwswnwsenenwnwnwwseeswneewsenese
    neswnwewnwnwseenwseesewsenwsweewe
    wseweeenwnesenwwwswnew
    """
    
    let input = """
    wseseseswsesesewnesesesesewneseseswnene
    seswswsenenweseneesweenwswneswsenwsenw
    nenwneneneeneneneneseeenene
    swwenwseswseswwnweswswswnwwswesww
    nwenenwnwwswnwsewneneswnwswnwwwwsenw
    seswseseswsesweseswswswnw
    seneesweneesweweeseeseeeenese
    nwswnwenwnwnwnwseneswnenwneswswsenenwnenw
    wsewwwwwwnenwwwwwneswww
    wneneneneenenewneneenesenenenee
    sesenweswswneswneswwswnwnwseswseswswnesw
    eenwneswseswnwneseneneswwesenwswnwwnese
    swnwwenenenwnwnwnwwswnwnwnwnwnwnwneswsw
    neeeweswneesweeseeeenweswswwnenw
    swswseswnwswseseseneneswsw
    eeswnwwnwsenenesenwnwnenwenwnwnenwwnwsw
    wseeseswsesewenwswswnweseseseseseswswne
    newnewneneneeneswseeneeneeneneese
    wenweeswseeeeweseeswneeenwene
    swneneswswswnwseseseseswneswswsesesesese
    weweewwswwwnw
    esesesesewesesenweseseeneswswenesee
    eswneswswnwswenewnenwneeeswneswnene
    esenenesewseseseesewsesese
    wswseneseseeewseswnwneeseneewenee
    swseswseewswweeswnwewswenwnewsese
    seswseseswwneswswswseswswnwswnwnewnene
    sweeesenenenewnenenwneneeneeenewsw
    wnwwwwseswnwwwswneswswesewswsenwsww
    swswseswswnwneesewswseswneswswsw
    seenwseswseesenwseeseseseseseseswswne
    swswswnewswswswswswswswsenewwwnewse
    swswsewneneswseswnewseswneswneseswsese
    wwswnwewswsesenweneeeenwwneee
    nwnenenwnwnenenenwnewnwnwnwswe
    wwsenwsewwweewwswwswwwnenew
    wnenwewnenenenweneenwnwswsw
    weeewsweeeeneeeenwneneneneesw
    sewnwnwwnwwnwwneweeswnwsenwswnw
    swnenenenwswnweswnenenenewnenenene
    nwswnwnwsenwesenwnwnwnenwsenenwnwnwwnwsew
    nweeeenenenewsweeeneeeeesewese
    neneneneneenenwneneeneewnesw
    nenwnenwnwnwswnwnwnwnwnwnwnw
    nenwswnwnwnwwswnwnwwwnwenwsenwneswnwne
    wseneseseseesweseseeenenwenewsese
    senwwsesenwenwenenwewseswnweswsese
    eweseeseswenwseseeseesenwnwnenwee
    wwnwnwwenwnesewwnwnwswwnweeswww
    neeneeeneeenenenenwenese
    nesenwnwneenwnenwwswnwseswswwwnwene
    nesweeswwseswsesewnesewswnw
    nwnwewnwnewswnwswwnww
    enwnesenwsweseeeewneseeee
    seneswwsesesenesesesesesesesenwsesesese
    seweswsenesweswswnwswswswwswswswswsw
    swswswswswwswneenwswswswswswsewswsene
    nenwenewnwnwneneswneneneneneneswenenesene
    esenwsesesesesesesesesese
    nenwnenwnwnwnenenwnwnenweswnene
    swwwwwnewnwnwseewnww
    nesenenenenwnewnenwswnweneesenew
    wwwwwwwwsewswwswwnw
    sesweswswswenwnwswswswswwseswswnwswswswnw
    sewnwswswewesee
    swnwswswsewswswswneseswswswsw
    seswenwnwseeswwnwneseesenweseseesenw
    ewesenwseseseeseeseseswsewwwsesw
    neeswnenwseenwnenenenwewwnenwnenwnw
    eswweeeneneeswenwneenwsewseswse
    wwswseseeeseewnwseesesesenwsenese
    nwswnwnwenwweswseneswswneswsenenenw
    nwwweswewswwnwswswswewwwnwwseee
    seseeswsewnwnenweneneenwse
    swswwwswsewnwswswww
    nwseweseesewsesesewneseseswesese
    wwwwnewwwwnwnenwwswwsw
    nwenenwseneneswnesenenwnwsewnwswwnwswnwnw
    wswneswswswenwseswnwswsesweswswwsesenwne
    neesenwnenwseseesweswnwenwneeewe
    wneswwwwswwwswweeswweswswwww
    wnwewwwwwewwswwwwwwwew
    seewwswwwswwneswswwneswnw
    swnwswnwsesenwnweswswwseneeewswswsw
    swenenwneswwnenweswswnenweeeeeseee
    wnwnwneenwswswsenwseenwnwnenwwnwwnene
    neneeneswnwneeseewneeweneneneenee
    seesenwnwsenesesweseseseswseeneswnwwnw
    nweeseseneeenewneeeeeswenwneee
    swnenesenwswnenwnwewweswswnwwnenese
    senwnewwsenwnwnwnenwnwnwnwnwneeesenwnw
    swseenwswneseeseeseseseeewnesenee
    sewwswwsenesewnenwewwneeswswee
    swneneeeswneneeenenwnene
    swwneswswwswseswswswsewwwwnww
    nenwnenenenenenesenwsweneneswnenenwnenw
    nweswneswseeeeeeswneeeeeneew
    swneseneenweeeenwsweseenwsw
    nwwswswwenweswwswswwswswswneewwsw
    nesweeewsenewsenwnenenwneeneneenenene
    swswwswnwwneeswweswswwswswesewwswe
    seswseseseeenenweenewwsewseseesese
    wswweswwseswwwnw
    wsenwsesesenwnenenenwnwswwwnwnenwswwne
    swswsweseswswswswswnwswsweswnwswneswswsw
    wswwwnwwwwwe
    seneseswseseeswnewswswsenwswsesesesese
    neesenenesenwenweenwsewneew
    wswwswswwswnwswwewswewwnwswesw
    swsewsweseneseseneswnese
    seseseneswesesesesesesese
    newwnesesewnwnenewneneneneswneneswenese
    eseswneeenewsenwnewee
    nwswswswneswwsweswsw
    nwwswwswswsewnwswweewwswswswwswnese
    wnewseneeeesweseeewseseseseseneese
    swenewnwnweeneneneneswnewsenwnwnenw
    nweweeeeswneweseneneneeeswnene
    eswneseeeesenweewseweseneesee
    nwwswwneneenwsenenwnweneneneeneswe
    eweswneneeeseeswenwsenenwnesesewenw
    nwseneeswneesesenenwnwneneeswnenwnenwse
    swswnwsweeswnesenwswswswswswswswsenwse
    nenwnwenwnwswneswnwsenwnwnwenwnwswnwsesw
    nwseneenwnwnenwwnwnenwsw
    nwnesewswswswsweswwswneswnweswe
    enwswwwnewnewwswwwwnwswwwseww
    nenwnenenwwneweneseswenwnenwneeswswne
    nenwnenwswwneneneneenwswnwneswneneneenesw
    neseseneswnewnenesesenenwnwneswsenwnwnw
    swenenenenenenesenewnene
    nwnwnwnwnwnwnwnwnwenwnwnwswnw
    neseneswwnwneswnwsewseseeswenwneswswsw
    wwwwneenwnwseswenenwnenwwwnwsesw
    wwnewswwwnewswwsewwww
    sesesewswsweseswseswse
    seswewneenwnenwnwnenwnwnwnwneneswswnwnenw
    neeseenwseesweneseweeseeesenwsw
    swneneneenewswneneewnenwnwwnwswswnesese
    swnesenwnwnwnewnwnenenenwnenenw
    wwwnewneeswsenwnwswwnwnwenwnwnewnw
    eeeeeeneweeseeeeee
    neweeswsenenwseeeeeneneneeneeneswnw
    nwnwwenwnwseenwnwenwwnwswwnwswewne
    wneenewenweenwseseseesesenewww
    eewneeneneeneeenene
    swswsenwweenwswswswswswswswsw
    nwneneseeenwnwnwswnwwswnwse
    swenwnwenwswwnwnwswneenwnwnwnenwnwnwse
    wsewswwnenwneseswsenwsww
    seeeenwseseneeeeseeeswesew
    weenwnewnenwseenwnwnenwnenwnenwwne
    sweeeswesenwwnwswwneswnwwewenenw
    eeneeenwesewweeneeeswewee
    sweseswseswneseseswswsewsesw
    wneswseseseseswseseseswswwswsesee
    swswswswswseswswwwseeseenewnewsw
    eeswnwnwnesewswneseneswsesweewswsee
    eseweeneseseseee
    weswswnwswsesewswsewenwneneswswenwnw
    seseenwseeswneswseenwseseewee
    eeneneeswsweseswewwneenwe
    neseewnwwesewnwwwswwsewnesenew
    eneswnenwewneseneneenenweneneseene
    sesenesesesesesenewswsesewseseseseseew
    nenenwnenwneeneneneneenwwswneeswnwesw
    wwewwsewewwsewwnwwwnwnewww
    nweneewnwseneseseeeeswsenweeenew
    nwnwwseswseeseseseneenwewswnwseswse
    neewsweseeeweswnwsenenwnwwwne
    senenwnewseseeswsweseseswswnwwseesesenw
    neswswnwnenenwnwsewwnwneswswenwsewnwnenw
    wwswwenwnewseneeswsewewnw
    seswsewseseneseswneesesenwseseswsesesene
    ewwsenenwwseswswsenwnewweenwwenww
    nenweenwneenwseneneewwsweeesewe
    wswnwwwewwwsewnwsewwsewnwnwse
    nwnenwnwenwnwenwnwnesweneswnwnwnwnwswnenw
    seeneswwesesesewswsenwwwneewnwne
    swwnwswseeswwswswenwswsweswswswwwnw
    seswnwewswseswwswwseenesw
    eneneseneneneeeneswneneeewnweseswne
    enwwneeneeeeesw
    sesesenwsesenweesweseeseseneseseswe
    nwnwnwnenwenenenenww
    nwnwwnwswenwnwnwwnwnwnwwesewnwwnwsw
    wwneesenwwsenweswwsewsewwnenww
    swswseswswneneswswswswwsweseseswnwswse
    wseenwwwwnwnwnenwnwwnwesewsenwnww
    wseneseswswwwsewswswwnewsweneswswnww
    nwsewnwwnenwnesewsewwnwwswnwnwswnw
    senwenesenenenesweenewnewnenenenenw
    swnwswweewnwwwnwswseswewewwsww
    wsewswnewsenewsewwwswwwwwwnw
    nwsenwnenenenenwnwnwnenwnw
    nenenwnenwnwnwnwnwenwwnesenwswnene
    nwwweewenweeswesw
    wnwnwnwsenwswnenwweswwnwnenwwwnwww
    seseneenwseneneswwneseneeeweneneenw
    swswwswswwswswswswwwesww
    nenesenewnwsenenenenwwnenwenenenenww
    wnwneseswswswswswnenewswenwswwsesesw
    wwwwnwseswwswwsww
    nwseenenwswweeseseneseeesewswsesene
    nenewsenewwneesweneesewwnwe
    wwswwewwwwseswwwweswnweesw
    nesweewswsweneeneneenwne
    wseseswnwesenwnewseneswenwneswseesw
    nwnwwswsenweeswswnwseswsweswse
    nenwnwnwnwswneneenenwswswsenwnwnenwnwsenw
    wswnewwnwswwwewnwnwsenwnw
    nwswneneseeseneeswwne
    nwseseswswneswnewsenwseneseswseeseswsenw
    enwnwnwswnwnwseneswnwswneswenwwwnesee
    wnwnwwswnwnwnenwwwnwnwnwnw
    nenwewnesewwswwswneswwseewnwww
    nwswsweewswsesesesweswnewnewneesesw
    nenwsewwwswwwwswwseswww
    nwnwseneneneneneswnwnwnwneswewneneewne
    weswsweseseneswsenwsenwseneneesesenwsesw
    nwnwswwnwnwnwwnwwnwenw
    swnwnwnwenwnwneswnwenwsenwnwnwnwnwnenw
    neswnenwneenwswnesenwneesweneswwnene
    neeeneneeeeeeesewweeesw
    eswneneneseswseswswsesenwnwseswseseswse
    seeeeneseseseseswenwnweseesw
    wewewnenwnwnesweenwnwwsewswnew
    seseweseseseeseneesesewswenewse
    wnesewswwswwswwwwneewwwwswsewnw
    nwweseswnwwsweseseeneneseeesewsese
    nwswneeseewseswneeswnwwwnw
    seseswwneesenwneseseeenweseseseesesw
    enwnenenenweneneneneneswswnenenesene
    eneswseeneseweeeeneenweenwene
    swwwwwwwwswnwe
    nwsesesesesesewnewseeeswsesee
    nwseeseeseseeswsenweneseesweee
    nweswwneswnwwnwswweswnwnwnwnwnwnewe
    neneswseswenenwnweseeswseseswwnwswswne
    wnwnwwwwneswewnwwwseswnenwwww
    wnwenwsewwwneseswnwesweeeewse
    seeseswnweseseeswswwnwswnwnwwswsee
    swswswewsewswseswnwnwwswswswswnewswse
    eswseneswnwsweneenw
    enwnwswnwwsewwenwnwnwsenwwnwnwnwnw
    eeeenesewseeeeeeseweneswwee
    eswsweeneneneeeneseneneneewswnwnwe
    nwwseseswsenwnwenenewwneneneenewnwnw
    nwnwnwnwnwnenwnwnwnwnwnwnwnesw
    wneeneswewneneenesenwnwswne
    nenweswneesweeeneee
    neseneswneneneseenenewenenwneneenwse
    swnwswsweneswswswwnwswswswsewseseswwnew
    swenwwnesenweewww
    swswwwwnwswwwnwnwwswwwseewswe
    seswseseswsesesesesenwsese
    nenwsewnesenwnenenwnenenesenenenewseswne
    nenwnwnwswnenweneenwnenwneswswswnenwesw
    wswseswewneseseesenenenwnewswseseswswsw
    nesewseseseseseseeseseseseseswenwswnwse
    senweswswswseswseswseweeswswwse
    wwweesewnwnwswswswswswwwnenwwww
    nwswseneenwswswwnwsweseswswswwswswsw
    weswneneswneenenesenesewnenenwnenwsesw
    neneenenenenenenenwswneneneneeswne
    eeenwseseeeeeswseweeenwneeee
    swswswswswswwsweswswnwswwenwswswsw
    senwnwswswswswewnesenewwswnwwwswsw
    nenenwneswnenwnwwnesenenewnenwnenwesese
    wwsewnewswnweswsesenwnwnwnwsweswe
    nwnenwnwsenwnwnwnwnwwnwseswwnwwnenwewnw
    seswswnenweeswnwnwnwswswswneswse
    nenesenweeseeneneswneenweweeswene
    enesweneeneewneswwnenewneenwnw
    swseseswsesenweswnwnwnesenw
    nwsenwwnwnwneenwwwnwwwwwnww
    seeseneswseswswswsesewswswseswsenewwse
    swnenenenwewnenwsenwsenwnwnwnwnw
    ewwwswnenwswnwwsenwewneenwwnwwse
    swneenweeeneenweeeeeswnweeswnwse
    sweeeeseenweeeeeenwwee
    weswwwwwnesewwwswwswswwnw
    swswswswswswnwswswswswswswswe
    wnwnwnenwswnwsenwsenwwnwnwnwwnenwswe
    swwwswwwnwnwnweswnwwwenwnwenewne
    eenwesesewseenw
    neeeseseeenwenwsweeseeeeewe
    swnesenwnesenwnwnenwnenewswseenenenwnw
    enwwneenwneswnwsenenwnwwnwnwnwnwnw
    swswnwnweenwswwneneeswnwnwnewnwwswsene
    neswwswsenenwwnwneesesenwnwswweswnee
    seswsesesenewneswsese
    seneswnenwswswnwneeneswnenwwnesenenww
    sesesesesenewewseeseene
    eseeewneeneeeeweeneswnweneneswe
    neswswswswswseeswswnwwswsweswwsw
    wnenwswsewenwnwswwnwenwswwnwnwee
    seseneswsewswseseswnesesesesesenwswsese
    enewswswnwsewnweswswneswwewwwneswse
    seseseswnwnwnwnwnwnwnenwnenwnwnewwnwnwnw
    neswnenwwneswswswew
    seseenwneneneweseeenwnenewswwwneew
    swswswneswswwnwswsweeswswseswseswnwseswne
    nenenwwneswswenwnwnenenwnenewnesenenw
    enwwneneeeneenenenewsesenewsenenenesw
    swseseseseseseseseswnwsesese
    swnwnwewsesewenesenwswew
    eesenwnwenesweswweeswswsenwnwse
    nwwneseseseneneswwswseswswsewswneswsenw
    sweseswnwswnwswswswswswswsenwswswesweswsw
    seneswneneenwnewnwwseswnewene
    wnwnesewnenenwseswnwnenwneenenenenenee
    seseeseneswswseseseeenwsenenwsesesee
    """
}
