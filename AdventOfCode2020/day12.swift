//
//  day.swift
//  AdventOfCode2020
//
//  Created by Morgan Kan on 29/11/2020.
//

import Foundation

class Day12 : AoCDay {
    
    func move( direction: Character, distance: Int, location : inout (x: Int, y: Int) ) {
        switch direction {
            case "N":
                location.y += distance
            case "S":
                location.y -= distance
            case "E":
                location.x += distance
            case "W":
                location.x -= distance
            default:
                print( "Invalid direction!" )
        }
    }
    
    func followInstructions( instructions: String ) -> (x : Int, y : Int) {
        var location = (x: 0, y: 0)
        var facingDirection = 0
        let directions = ["E", "N", "W", "S"]
        
        for row in instructions.components(separatedBy: "\n") {
            let instr = row.first!
            let value = Int(row.suffix(from:row.index(after: row.startIndex)))!
            
            switch instr {
                case "N", "S", "E", "W":
                    move( direction: instr, distance: value, location: &location)
                case "L":
                    facingDirection = (facingDirection + (value / 90)) % directions.count
                case "R":
                    facingDirection = (facingDirection - (value / 90))
                    while( facingDirection < 0 ) {
                        facingDirection += directions.count
                    }
                case "F":
                    move( direction: directions[facingDirection].first!, distance: value, location: &location)
                default:
                    break
            }
        }
        return location
    }
    
    func followWaypoint( instructions: String ) -> (x: Int, y: Int) {
        var location = (x: 0, y: 0)
        var waypointLoc = (x: 10, y: 1)
        
        for row in instructions.components(separatedBy: "\n") {
            let instr = row.first!
            let value = Int(row.suffix(from:row.index(after: row.startIndex)))!
            
            switch instr {
                case "N", "S", "E", "W":
                    move( direction: instr, distance: value, location: &waypointLoc) // cardinal directions now move waypointLocation
                case "L":
                    var val = value
                    while val > 0 {
                        (waypointLoc.x, waypointLoc.y) = (-waypointLoc.y, waypointLoc.x)
                        val -= 90
                    }
                case "R":
                    var val = value
                    while val > 0 {
                        (waypointLoc.x, waypointLoc.y) = (waypointLoc.y, -waypointLoc.x)
                        val -= 90
                    }
                case "F":
                    location.x += (waypointLoc.x * value)
                    location.y += (waypointLoc.y * value)
                default:
                    break
            }
        }
        return location
    }
    
    override func problem01()
    {
        let result = followInstructions(instructions: input)
        print( "\(result) \(abs(result.x) + abs(result.y))" )
    }
    
    override func problem02()
    {
        let result = followWaypoint(instructions: input)
        print( "\(result) \(abs(result.x) + abs(result.y))" )
    }

    let sampleInput = """
    F10
    N3
    F7
    R90
    F11
    """
    
    let input = """
    S1
    R270
    S5
    W2
    F63
    S3
    L90
    W4
    F59
    S1
    F21
    W4
    R90
    W1
    R180
    S2
    W2
    F91
    W5
    R270
    F97
    R90
    E2
    R90
    F6
    W1
    R90
    W3
    F1
    S4
    F1
    N3
    F76
    S4
    W5
    F88
    W4
    N3
    W2
    F48
    N1
    F50
    E3
    F18
    L90
    F30
    S3
    R90
    W1
    N5
    W1
    R90
    R90
    E1
    S2
    F73
    R90
    S4
    F89
    F34
    L90
    F11
    S3
    F20
    S5
    E3
    R180
    E3
    L90
    E2
    F1
    E3
    N3
    F84
    R90
    E4
    R180
    F24
    N3
    L90
    F15
    W4
    F52
    S5
    L180
    N4
    R90
    E5
    F11
    S4
    F27
    R180
    E4
    R180
    W3
    N2
    W1
    S3
    W4
    E5
    F97
    L180
    E3
    N4
    E3
    S4
    L90
    S4
    R90
    N5
    E1
    S5
    F19
    E1
    S2
    L180
    F36
    S2
    L90
    W1
    F8
    W1
    F67
    E3
    L90
    F33
    N4
    F35
    W2
    F33
    L180
    N1
    L90
    R90
    N3
    W4
    S1
    F36
    E2
    F2
    L90
    W3
    L90
    E5
    F4
    L90
    N1
    N5
    W4
    N5
    R90
    W4
    N5
    W2
    N5
    F43
    N3
    W3
    S2
    W2
    R90
    E1
    R90
    F26
    R90
    E4
    L270
    F97
    L180
    N2
    F2
    R90
    F33
    E2
    F85
    E4
    F80
    R90
    N2
    L90
    S5
    F96
    W1
    S5
    L180
    F54
    E3
    F84
    E3
    L90
    W1
    N2
    W4
    L90
    W4
    F26
    E5
    R180
    W1
    F43
    N4
    E1
    S4
    S3
    L90
    N3
    E1
    F14
    E1
    N2
    F93
    S1
    W3
    N5
    F15
    W5
    R90
    F93
    L90
    E5
    S4
    E4
    L90
    E2
    N4
    F98
    R90
    W3
    F100
    R90
    E2
    F100
    N5
    F9
    R90
    F36
    N3
    W3
    N4
    F35
    E3
    R90
    W4
    L90
    W3
    F15
    L90
    F73
    S2
    E1
    R180
    F93
    L270
    F37
    S1
    F36
    N1
    E1
    W1
    R90
    F46
    W2
    N4
    F50
    R90
    W4
    F90
    L90
    S3
    F2
    E1
    L90
    E5
    S2
    F91
    W2
    F21
    E2
    N2
    W5
    F79
    E1
    F77
    L90
    W5
    N2
    E3
    L180
    S2
    W1
    S1
    R90
    S5
    R180
    E2
    F55
    W4
    R90
    S3
    L90
    S1
    R180
    W4
    R180
    W5
    S5
    L180
    F35
    N1
    F72
    L90
    W4
    L180
    S1
    E1
    N5
    L90
    W5
    N1
    E2
    N4
    W3
    F3
    W4
    F96
    E1
    F20
    R90
    W4
    F99
    L90
    E4
    N3
    N3
    W3
    N5
    E2
    N4
    E4
    L90
    S2
    W3
    F3
    R90
    E2
    R90
    F23
    N5
    F39
    W3
    R90
    N3
    R180
    R90
    F94
    W1
    R90
    N3
    F16
    R90
    F61
    R90
    F67
    N4
    F72
    S2
    F39
    W1
    S1
    R90
    F67
    S1
    L90
    W5
    N5
    E3
    F65
    E2
    N1
    S4
    L90
    N4
    W5
    R90
    F49
    L180
    F22
    E2
    L90
    N3
    R90
    F61
    L180
    F57
    L90
    F90
    R90
    E5
    L180
    E1
    L180
    S3
    W4
    F55
    E1
    F95
    R180
    W5
    L180
    F23
    E3
    F97
    S1
    F19
    N2
    W4
    F10
    L90
    W4
    S1
    L90
    W5
    F64
    R90
    W4
    F60
    W4
    L90
    W3
    F15
    E5
    N5
    L90
    S2
    L180
    F64
    L180
    F93
    E5
    F13
    R270
    S4
    F58
    R180
    W5
    S1
    W4
    N1
    L270
    S4
    E4
    N5
    F38
    W4
    N2
    W2
    N1
    R90
    E1
    L90
    N2
    R90
    N3
    E3
    N3
    F90
    W2
    L90
    F95
    S1
    S4
    F48
    L270
    W2
    L90
    F34
    S3
    F23
    N2
    F13
    R180
    E2
    F95
    L90
    N2
    R90
    S2
    E3
    N1
    F41
    N2
    R180
    S4
    W3
    L90
    W5
    L90
    F35
    S5
    E2
    S5
    E3
    F81
    W4
    N3
    F28
    E1
    F93
    S3
    F53
    L90
    W5
    F59
    W1
    R90
    E2
    S5
    F80
    W3
    S5
    F6
    R90
    F8
    W1
    R180
    E2
    L270
    N3
    F59
    W5
    F51
    R90
    N2
    E4
    R90
    E4
    S1
    W2
    N1
    F45
    R90
    N5
    F28
    L90
    N4
    F78
    S1
    R90
    N5
    L90
    S2
    F92
    L180
    E3
    R90
    F26
    W1
    L180
    R90
    S3
    F51
    N1
    L90
    W2
    F84
    L180
    E1
    F54
    E4
    F65
    R90
    S5
    E2
    F78
    E1
    R90
    S1
    R90
    W3
    R180
    F99
    E5
    R90
    F44
    L90
    W3
    N3
    R180
    N4
    E1
    S4
    L180
    S4
    F59
    E4
    F1
    N5
    R180
    S5
    L180
    F38
    E4
    N3
    R180
    N1
    W4
    R90
    F30
    L90
    S3
    R90
    F71
    L90
    E5
    N4
    R90
    F50
    N2
    L180
    F3
    W5
    L90
    W5
    R90
    W5
    N5
    R180
    E2
    F39
    W5
    R90
    F72
    N5
    E3
    F37
    S5
    W1
    F11
    L180
    E3
    F55
    R90
    R90
    F85
    W4
    F53
    S1
    F33
    W4
    L90
    W5
    F64
    E5
    R90
    N1
    R90
    F14
    N4
    L180
    S3
    E1
    F21
    S2
    F26
    S5
    F6
    S2
    L90
    F50
    N2
    L180
    W4
    N2
    E2
    R90
    F35
    N1
    F69
    W3
    N2
    W3
    L90
    E1
    S3
    E4
    F58
    N1
    W5
    S5
    L90
    W1
    S3
    W1
    S4
    E4
    R90
    N5
    R180
    F57
    L90
    F69
    W4
    F2
    R90
    F1
    L90
    W1
    S2
    F40
    S1
    L180
    F31
    R180
    F24
    R90
    S3
    L180
    S1
    W2
    F64
    S1
    W1
    R180
    W5
    S3
    L90
    S5
    E5
    R90
    E1
    F5
    N5
    F3
    W3
    F57
    R180
    E3
    F94
    W1
    F54
    W4
    S2
    W2
    N1
    L90
    W5
    S4
    L180
    L90
    F100
    E3
    R90
    N5
    E1
    R90
    E5
    L90
    S5
    L90
    S1
    R90
    E4
    S1
    W4
    F65
    R90
    N3
    W5
    F64
    R90
    E5
    R180
    W5
    F28
    S5
    L180
    S5
    R90
    E4
    F82
    """
}
