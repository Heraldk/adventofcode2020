//
//  day.swift
//  AdventOfCode2020
//
//  Created by Morgan Kan on 29/11/2020.
//

import Foundation

class Day19 : AoCDay {
    
    var overrideRules = false
    let maxRepeats = 9
    
    func prepareExpression( query: Int, rules: [Int: [[Int]]], vals : [Int : String] ) -> String {
        if let result = vals[query] {
            return result
        }
        
        // strategy for part 2: rewrite these regular expressions with an upper limit on repeats
        // the 8 rule is easy: you need to see rule 42 at least once, but it can repeat, so that's a + in regular expressions
        // for 11, it's trickier (or my regular expressions are weaker), so I just did (42 31|42 42 31 31|42 42 42 31 31 31 31...) with the idea that if repeated enough
        // the answer comes out.
        // ran into a weird thing where this started going down with too many repeats. Might be an issue with swift regex? not sure.
        if overrideRules {
            if query == 8 {
                let expr = prepareExpression( query: 42, rules: rules, vals: vals )
                return "(\(expr)+)"
            } else if query == 11 {
                let firstExpr = prepareExpression( query: 42, rules: rules, vals: vals )
                let secondExpr = prepareExpression( query: 31, rules: rules, vals: vals )
                var myStr = "("
                for repeatCount in 1...maxRepeats {
                    if myStr.count > 1 {
                        myStr.append( "|")
                    }
                    myStr.append( String( repeating: firstExpr, count: repeatCount ) )
                    myStr.append( String( repeating: secondExpr, count: repeatCount ) )
                }
                myStr.append(")")
                return myStr
            }
        }
        
        var myStr = ""
        if let rule = rules[query] {
            myStr.append( "(" )
            var first = true
            for ruleOr in rule {
                if( !first ) {
                    myStr.append( "|" )
                }
                first = false
                for recurseRule in ruleOr {
                    myStr.append( prepareExpression(query: recurseRule, rules: rules, vals: vals) )
                }
            }
            myStr.append( ")" )
        }
        return myStr
    }
    
    func readInput( str: String ) -> (rules: [Int: [[Int]]], matches: [Int : String], candidates: [String] ){
        var rules = [Int: [[Int]]]()
        var matches = [Int : String]()
        var candidates = [String]()
        
        for row in str.components(separatedBy: "\n") {
            let vals = row.components(separatedBy: CharacterSet( charactersIn: ": ") )
            if vals.count == 0 {
                continue
            } else if vals.count == 1 {
                candidates.append( row )
                continue
            }
            
            let ruleNum = Int(vals[0])!
            if row.contains( "\"" ) {
                let match = vals[2].components(separatedBy: "\"")
                matches[ruleNum] = match[1]
                continue
            }
            
            var rule = [[Int]]()
            rule.append( [Int]() )
            for val in vals[2..<vals.count] {
                if val == "|" {
                    rule.append( [Int]() )
                } else {
                    rule[rule.count-1].append( Int(val)! )
                }
            }
            rules[ruleNum] = rule
        }
        
        return (rules, matches, candidates)
    }
    
    override func problem01()
    {
        let (rules, matches, candidates) = readInput(str: input)        
        
        let regExp = "^\(prepareExpression(query: 0, rules: rules, vals: matches))$"
        //print( regExp )
        
        var matchCount = 0
        for string in candidates {
            if string.range(of: regExp, options: .regularExpression) != nil {
                matchCount += 1
            }
        }
        print( matchCount )
        
        overrideRules = true
        let newExp = "^\(prepareExpression(query: 0, rules: rules, vals: matches))$"
        print( newExp.count )
        matchCount = 0
        for string in candidates {
            if string.range(of: newExp, options: .regularExpression) != nil {
                matchCount += 1
            }
        }
        print( matchCount )
    }
    
    let sampleInput = """
    0: 4 1 5
    1: 2 3 | 3 2
    2: 4 4 | 5 5
    3: 4 5 | 5 4
    4: "a"
    5: "b"

    ababbb
    bababa
    abbbab
    aaabbb
    aaaabbb
    """
    
    let sampleInput2 = """
    42: 9 14 | 10 1
    9: 14 27 | 1 26
    10: 23 14 | 28 1
    1: "a"
    11: 42 31
    5: 1 14 | 15 1
    19: 14 1 | 14 14
    12: 24 14 | 19 1
    16: 15 1 | 14 14
    31: 14 17 | 1 13
    6: 14 14 | 1 14
    2: 1 24 | 14 4
    0: 8 11
    13: 14 3 | 1 12
    15: 1 | 14
    17: 14 2 | 1 7
    23: 25 1 | 22 14
    28: 16 1
    4: 1 1
    20: 14 14 | 1 15
    3: 5 14 | 16 1
    27: 1 6 | 14 18
    14: "b"
    21: 14 1 | 1 14
    25: 1 1 | 1 14
    22: 14 14
    8: 42
    26: 14 22 | 1 20
    18: 15 15
    7: 14 5 | 1 21
    24: 14 1

    abbbbbabbbaaaababbaabbbbabababbbabbbbbbabaaaa
    bbabbbbaabaabba
    babbbbaabbbbbabbbbbbaabaaabaaa
    aaabbbbbbaaaabaababaabababbabaaabbababababaaa
    bbbbbbbaaaabbbbaaabbabaaa
    bbbababbbbaaaaaaaabbababaaababaabab
    ababaaaaaabaaab
    ababaaaaabbbaba
    baabbaaaabbaaaababbaababb
    abbbbabbbbaaaababbbbbbaaaababb
    aaaaabbaabaaaaababaa
    aaaabbaaaabbaaa
    aaaabbaabbaaaaaaabbbabbbaaabbaabaaa
    babaaabbbaaabaababbaabababaaab
    aabbbbbaabbbaaaaaabbbbbababaaaaabbaaabba
    """
    
    let input = """
    91: 94 94
    122: 117 24 | 33 67
    6: 117 40 | 33 47
    70: 63 33 | 3 117
    36: 17 117 | 44 33
    111: 33 91 | 117 109
    31: 33 69 | 117 41
    54: 88 33 | 72 117
    52: 33 32 | 117 82
    58: 33 43 | 117 122
    29: 97 117 | 126 33
    129: 51 33 | 7 117
    43: 33 35 | 117 97
    8: 42
    87: 26 33 | 128 117
    83: 132 117 | 5 33
    57: 126 117
    105: 33 2 | 117 64
    16: 97 33 | 53 117
    110: 33 108 | 117 40
    127: 24 117 | 35 33
    119: 84 117 | 131 33
    135: 109 117 | 126 33
    88: 24 33 | 46 117
    19: 33 46
    64: 117 67 | 33 108
    67: 33 117 | 33 33
    126: 117 117
    12: 43 33 | 50 117
    10: 40 33 | 109 117
    30: 14 117 | 54 33
    108: 33 33 | 117 117
    35: 33 94 | 117 117
    59: 117 61 | 33 107
    93: 50 33 | 76 117
    128: 33 40 | 117 53
    86: 56 33 | 70 117
    115: 33 66 | 117 23
    24: 33 117 | 117 94
    5: 117 21 | 33 12
    79: 33 40 | 117 46
    113: 33 30 | 117 75
    65: 117 96 | 33 74
    1: 91 33 | 24 117
    42: 18 33 | 45 117
    74: 33 92 | 117 15
    56: 129 33 | 101 117
    73: 117 35 | 33 85
    4: 114 117 | 125 33
    63: 68 117 | 111 33
    78: 33 108 | 117 91
    62: 53 117 | 24 33
    98: 109 33 | 85 117
    136: 57 33 | 130 117
    17: 126 33 | 35 117
    7: 108 117 | 53 33
    92: 117 109 | 33 67
    75: 89 117 | 137 33
    104: 33 120 | 117 77
    66: 33 37 | 117 103
    72: 117 126 | 33 108
    106: 117 39 | 33 100
    27: 117 60 | 33 1
    123: 117 24 | 33 40
    82: 124 33 | 76 117
    46: 33 33
    55: 9 117 | 87 33
    100: 40 33 | 35 117
    96: 33 116 | 117 38
    25: 118 117 | 65 33
    89: 22 33 | 102 117
    45: 25 117 | 59 33
    61: 33 49 | 117 27
    109: 94 33 | 33 117
    99: 117 33 | 117 117
    28: 94 108
    40: 117 117 | 33 117
    34: 117 46 | 33 53
    33: "a"
    130: 47 33 | 40 117
    112: 104 117 | 80 33
    118: 105 33 | 95 117
    69: 117 13 | 33 86
    50: 33 40 | 117 67
    60: 47 33 | 126 117
    101: 84 117 | 123 33
    21: 6 33 | 44 117
    47: 117 33
    84: 33 97 | 117 46
    85: 117 33 | 33 117
    71: 117 24 | 33 53
    80: 106 33 | 93 117
    125: 117 99 | 33 109
    14: 33 98 | 117 20
    107: 136 33 | 48 117
    41: 113 117 | 115 33
    15: 117 53
    9: 33 79 | 117 72
    132: 36 33 | 58 117
    18: 33 112 | 117 83
    133: 33 97
    117: "b"
    68: 33 99 | 117 35
    49: 110 33 | 62 117
    20: 46 117 | 67 33
    90: 97 117 | 67 33
    134: 117 85 | 33 91
    26: 47 33 | 47 117
    95: 117 10 | 33 135
    103: 121 33 | 73 117
    124: 117 126 | 33 91
    38: 108 117 | 24 33
    53: 117 33 | 33 33
    81: 117 53 | 33 91
    44: 46 117 | 40 33
    114: 33 53 | 117 91
    37: 33 16 | 117 90
    2: 97 33 | 91 117
    97: 33 117
    76: 40 33 | 108 117
    13: 52 117 | 55 33
    39: 35 94
    137: 33 133 | 117 134
    131: 53 33 | 35 117
    22: 33 108 | 117 97
    11: 42 31
    116: 126 33 | 40 117
    32: 78 33 | 81 117
    121: 117 91 | 33 46
    48: 19 117 | 28 33
    102: 108 117 | 99 33
    51: 117 67 | 33 46
    94: 33 | 117
    120: 34 33 | 127 117
    23: 33 4 | 117 119
    77: 117 62 | 33 71
    3: 33 128 | 117 29
    0: 8 11

    abbbaaaaaabbbaabababaaab
    bbbaaababbaabbaabbbabbaa
    aababbaaabbbababbaaaaaabbbbababb
    bababbbabaaabbbabbbaaaaa
    abaaababaabbbbbabaaabaab
    aabababbbbababbbbbbaabaa
    aabbbaabbbaabbaabaaaabbbbbabbbbbaaabbabb
    bbabababaabbbaabbaabaaab
    baababaaabaaaaaaabbabababbaabbaaaaabbaabbaaaabaaabbaabaaababbbaaabbbaaaabaaabbaabaaabbbb
    bbbbbababbbababaaaaabbba
    bbaaabbaaaabbbbbbbabbbaa
    abbaabbabbabaaabaaababab
    bbbbaabbbaaaabbabaaaabbabaaaaaababbbbbbabbabbabbbbbbbbbb
    aabaaababaaabbbaababbbaa
    aabaaabbabbbaabbbbaaaaabbabbabba
    aabbaaaaaaabbbbbaaabbaab
    bbabbaabbaaaaaaabaababbb
    bbaabaabaababbaaaaabbbaabbbbbaaaaabaaabababaababababaababbbbaaaaaaaabbba
    ababbbaababbbbaaabaaabbbbbbabaababaabababbbbabbbbbbbaaba
    aabbbaababaabaabbababbaaabbbaaaabbaabbabbbaaabaa
    bbabaaabababbbbbaaaabaab
    bababbaabbbbabaabaaaabbbabbbbbaababbbbbbaabaabaa
    baaaabbabababbbbbbabbbbbaabbabaaabbabbabbbbbbbbb
    aaababbaaababbbabaaaaaabaaabbaaabbabbbbbaababbbb
    baabaaabababbbabaaabaaab
    bababbbbaaabbabaaaabbabb
    babaabaabbaaaaabaaabbbbabbbaabbb
    ababaabababbbaaababaabbb
    abbbababbabbbabbbabbbababaababba
    abaabababbbbbbababababab
    bbabbbbbbbbbbbabaabaaaab
    baaabbbaaabbababbabbbbaa
    aabbabbbaabbaabbaaaabbba
    aabababbaabbabbaabaabbbb
    bababbbaababaabaaabbabbb
    abbbbabbaabbbbbabbbabaaaababbbbaaaabaababbbbaaaabbbbababbabbaaaaabababbbbaabbbbaabbbbbba
    bbbbaaabaabbaabbbbaabaab
    abababaaaaaaaabaaaaaabbaabbbabbbaabbbaabababbbbb
    abbaaabbbbbabbbbaaabaabb
    aaabbaaabababbbabbbbbbbaaabbbbbabbaabbbaaaabbbaabbbaabba
    bbaabbaaaaabaaaabaaabbabbaabbbbabbaaabbbabaaaaaaaaabbaabbbaababa
    aaaababbaabbbbbbbaabababbabbbbba
    aaaaaabaabababbbbababaaabbbaabba
    aaabbbaabaabbaabaaaabbbb
    bababaaabbbbbbbabbbbaabababaaabbaababbbbabbaaaab
    baaaaaaaabbbaababbbababbaabababbbbabbaabbbbbaaaa
    aabbbbbbaababaaaaabbbaba
    abaaaababbaabbbaaaaaaabbbaabababaabbabbbbaababbb
    abaaaababbbbbaaaabaabbbb
    baaabbbabaaabbabaabbaaab
    aaabaaaabbaaaaabbabababa
    aabbbaababbaababbaaaaaba
    baababaaaabaabaaaaaaaaab
    bbaaaaababaaababaaabbaab
    bbaabbbaaabaaabaabbbbbaabbbaaabaaaaabababaaabaab
    bbabababbaaaaaabbabaabababbbbbaa
    babbaabbaabbbbbaaabbbaba
    bbbababababaababaaaababa
    aaabaaabaabbaababababbbaaaababaabababbabaaaabaabbbabaabb
    aabbbbbbbbaababbbbaababa
    bbabbbabbbababbbbbaaaaba
    babbbabbaabbabbbababaaba
    bbaaaaaababbaaaabbaaaaabbaabbabbabbbbbabbaaaaaaabbaabbbaabbbaaba
    bbabbbbbbaaabbaabbbaabba
    abaaabababaaaabaaaababbaabbababb
    bbbbbaaababbbbbbaabbbabb
    abaaaaaaaaabaababaaaabaa
    aababbaabaaabaaaaaabbbaababbbaaaaabaaaaa
    bababbbaabbbbababbaabaabababbaab
    abbabbaaaabaaabbbbbaaaaa
    bbbbabaabaaabaaabbbaabab
    aaaababbaabbabababbaaaaa
    bbbbbababbbbabbaababbaab
    aabbabbaaabbaaaaababaaba
    abbbaaabbbaabbbabaaaaaabbbbbabbaaaababaabababbaabaababbb
    bbabbaaaaaabaaabaaabbaabbbbbbaaaabbaababaabaaaabaabbaaaababababaaababbabbabaaabb
    aaaabbabbbbbabbabbbabbbbbbaababbabbbbaabaaabbbbbababbaab
    aabbbaaabbaabbbabbbbbbababaabbab
    bbababbbaabbaabbabaabbaa
    bbbbabbbababbbaabaaaaabbbabbabbaaaabbbbbaaabaaaaababaabbababbaaabaaabaaa
    abbaabbabbbaaababaaabbabbaabaaaa
    aaaababbbbbabaaabaaabbbbbaabbbaabbaaaaabababaaabbaaaaaaa
    bbbbbbabbbabaabbbabaaaaa
    baaabbbaaaaaabbabbaaabbaabbbbaaaabaabbaa
    abbabababbababaaaababbbababbbbaa
    abbbaaaabbabababbaaabbabaabaaaaa
    bbbbbababaaabbabbbbbbaba
    baabbbbababbbbbbaaabaabaaaaabaaabbabbbbbabbbbaaaaaabaabb
    baabbaabaabaaabbbaaabbbb
    bbbaaabbbaaabbababaaabbb
    aabbbbbaaaaaaabbbaabbbaaaababbbaaaaaabbb
    bababaabaabbbaaabbbaabab
    aaaaaabbabbbbabaabaabaaabbbbbbabbabaabbaabbbbbbbbaaabbbb
    bbaabbabaaabaaaaabbbaababababbbbbbbaabababaabbbabaaaaaba
    aababaabababbbaaaaaaaaaa
    babbaabbbbbabbbababababbbabbbbbabbbbabbbbbaabbbbaaaabbbabaabbbabbabaabab
    abaabaaabbaabaababaababb
    abbbababaabbbbbbaabaabab
    babbbababbabbbbbbaaabaaaabaabbabaabbbabb
    bbaabbbaaaabbbaaababaabb
    baaabaaaabaabaaaaaababaa
    ababaaaabaabbbaaabbaaabaabababab
    baaaabbababbbaabaaabbbbaabbabbaabbabaabbabbbbbbaaaaababaababbbabbabaaaaa
    bbaaaaabbbabaaaaabaabaaaaaabaababaaabbbabbaababbaabaabbaabaaabbababbbbba
    bbbabbabbbabbbaabaabaaaababaaabbabaaaabbbbbababb
    bbaabbbabbaabbabbbaaabbbabbaaaaaabaaabbaabbaaaaa
    abbbaabbbbbaaababbabbbaa
    babaabababbbabbabbbaaabaaaababab
    bbabaabbbbabaaaaababbaaabbbaaabbbabaabaabbbbababbbbabbabbaaabbbbbaababaa
    abbbbbaaabaabaaabaaaaaabbabbbaabbabbbaabaabaabaabbabbaaa
    bbbaaabaabaabababaabaabb
    babaabaabaaabbaabbbbabbaaaaabbabaabaabab
    aabbababbaabaabbababaabaabbbbbbbabbabbbaababbbbbabaaabababaabbabbbabaabbbaaaabaa
    babbababbbaababbabbbbbba
    abbbbabbabbabbbbbbaaaabbabbaaaaabbbbabbbabbbbababbbbabaaabaabbbb
    abbbaabaabbbaaabbaaaabab
    bbbbabaababbaabbaabbaabbbbbbbaabababaaab
    abbbaababaaabaaaababbaab
    abababbaababbbbbaaaabaaaaabbaaaabaaabaab
    aaaaaabbabbbaaabbbbbbabbbbbbbabbababaabbbbaabaaa
    abaababaabaaaaaaaaaaaabbabaaaabb
    baabbaabaaaaababbaaabaaaaabaaabaababababbbbbabbb
    baaabbabbbbbababbbbaaaabbabaabbbabaabbaabbaabababbabaabbabbbbaabbabaaaba
    aaaabbabaaababbabbabaabbbbabaaabbbbbaaabaaababbaabbbbbbb
    baabbbbabaaaabbabaaaaaabaabbaaaabaabababbaaababb
    bababbaabbabaabbaaaaaaaa
    abbbabbbabbbaaaaababaabb
    abaaaabaabbaaabbbbababbbabbaabbaabaababbaaaaaaab
    bbaaaaabbbbbbbbabbbaaabababaaabbbbabbbba
    bbbbaabbaabbbbbbbaabbbab
    bababbbbbbabaabbbababaaabbbbbaab
    bbaaabbaabbbaaaaaabbbaba
    aaaaabbabbbaaabbbbaabbbaababababbaaababb
    aabaabbbaaaaaaabababbbabbabbaababaababbbaabaabbabaaababb
    abbaaabbbabaababaaabbbaababaabba
    aaabbbaaabababbbbaaababa
    bababbbbaaababbbaaabaabb
    abbabbbbbaabbbbabaaabaab
    aaababbbabbaabaabaaaabaababababb
    bbaabbbabbaababbbbbababababbbbba
    bbbabaaaabbabbaaabbbbaaaababbabbbaababba
    bababaabbabbbbbbbabbbbba
    abaabbaaaabbabaaabababbaaaaabababaababbbbaabababaabbbababbbaabaaaabbbabbbbbbbbabaabaaaabababbabb
    aaabbabbbabbbabbbbaaaaaaaabbbababbbbbabababaabbaaaabababbbbbabababbbbbbbbbabbabbbaabaaaa
    baabbbbaaabbbaabbabaaaaa
    aabbaaaaaababbaaaababbaaaabbaaaaaabaabaa
    bbbbbbbabbbababaabbaaabbbaaaabaababbbbab
    baaabaaabaaaaaabaaaababbaabbbabbbbbbbbaa
    bbbbbabaabaabababbbbbbbb
    baaaabbaabaabababaababbb
    abbbaabbbaaabbaabababbbbaabaabaa
    aabaabaaabaaaabaaabbabaaaaabaaaabababaab
    babbbabbbaabbababbbbbabbabbabbab
    abaaabaabbaabbabbbabaabbbaaaaaba
    abababbbbbabaabbbababbbaaaababab
    aabaaabbbbbbbbbaabaababb
    babbabbbabaababbaaabababaabaabbababaabbb
    bababaaabaaaabbabbabbbabaabbabbaabbbabbbaabababaaabaababaaaabaab
    bbaabbbabbababaaaaabaaaaaaaaaaaa
    abbbaabbabbbbaaababbabaa
    bbabbaababbaabbaabababbbbaabbaaaaababbab
    bbbabbbaabbbbababaaabbabbabaabba
    baabaababbabbbbbbbbaababbaaababbbbabaaba
    ababaabbaaaaaaabaaaaaabaabbbbaaabbabbaabbabbaabababbababbaababba
    babbaabbabbbbbaabbaaabbababbbaabaabaaaab
    ababbaaababbbaabbaaabaab
    aaabbbaabbabbaabbbabaabbaabbabbbbababbbaaababbabaaabaaababaaaaab
    baabbbbbbbbaaabbbbbbbbaa
    aaabbaaaabbabbbbbbbbbabbbbbbbbaaabaabbaa
    babbbbbbaaabbbbbbabbbaaa
    baabaababbbbabbaaabaabaa
    aabbbbbbbbabbbbbbbbbbbbb
    aaaaabbababbbabaaabababa
    aabbabababbbaabbababbaab
    bbabbbaaaabbbabbbbabbbabaaaabbabababaaba
    bbabbbbbbbbbbbabababbbab
    abbbababaabbbaabbaababaa
    abbabbbbbbaabaabbbbbbbbb
    aababaabbabababababaaabaaaabaabbbabbababbaababaa
    baaaabbaaabaaabbaabbabaabbabaaaababbbbabbaababaababbbbaa
    bbaabbaaaaabbbaaaababbab
    abbbabbbaabbabbbbaaaaaba
    ababbaaababbababbaabbaaabbaaaabb
    baabbbabbabaaabbabbbaaabbbbaaaaaababbbbbbababaabaaabababaaaaabbaababbbaabaababba
    abaaaaaaabababbbbaababaa
    baabbbaabbaababbababaabb
    aabbbbababababaaabaaaabbabaabbaaabbabaaaaabbbbbaabaaaabbaaababbbbabbaaaa
    abababbabbaabbaabbbbabab
    bbaaaaabbaabbaabbbaabbabbabbbaaa
    bbbabaaabbababbbaabbbaabaaaabbbb
    babbaabbabababababbaaabbababbbaaabaaabbbaabaaaaa
    abbbaaaabbaabbaababababa
    baaaaaabbbaabaabbbbabbbbaaaaaabaabbbbaaabbbaaaab
    bbbaabbababababbbbaaabab
    aabbaaaabbabbaabaabbbaaaaaaaaabbbbaaaaaabaaaabababbbbbba
    aababbbabaaaaaaaabaaaabb
    baaaabbabbbbabaabbbabaab
    baabbbaababbaabbbbaaaaaa
    babbbababaaabaaaaaababab
    abbabbbbabbaabbaabbbaaaaabbbbabababaaaaa
    bbbabbbbbabbbbbbbbbaabaa
    aabbbbbbbbbbaabbaabaaabaabaababb
    abababbbbaaaabbaaaaabbaa
    baabbaaabbbabbbbabbbbabb
    bbbaaababaabbababaabaababbbbbbaa
    aaababaabababaabbababbaaaabaaabbaabbaaaababbbbba
    aaaaaababbabaabbbbabbaba
    baaaaaabbbabbbababbababb
    bababbbaaaabbbbaaabbaaaaabaaaabbbabababa
    babaabaaabbbaaaababbbaababaaabaababbbaabbabaabbbbbaaaabb
    abbbbaaabbabbaabbabbbababbababababbaaababbbabbaaaaaaaaab
    abbabababaabbabbaabbbbaa
    bbaabbbabababaabbabaaabaababaaababaaabbb
    bbbabaaaabaaabbbaababaaaaaaaaaabaaabaaab
    baabbaabaabaaabbbbabaaabbbaabbbbbaababbb
    babbbbbbabaaababbbaabbabbbbbbbaa
    bbabaaabbbbbbababbabbbaa
    bbaaabbbbbabbbbbabbbabaa
    abbbabbbabbababaabaababb
    bbbbbbbabbabbaababbbbabb
    baabbababbaaaaabbbbbbaaaaaababaaababbbbbbbabaaaababbaaaa
    bbbabbbbababbbbbaabbbbbbabaabbbb
    babbabbaabaabbabababaabbaababbab
    aaabaaaabbabbbbbaaabbbbaabbabbaaababaaab
    aaaabbabbbbaaabbaababaab
    aaaabaaabaabbabaaababbab
    abbabbaaaaababaaaaabbbbaabbbaabbaabbbaba
    ababbabababbabbbbbbbaaabbabababbabaaabba
    bbaababbabbbbabababaabba
    abbaabaababaaabababaabaabbaaabbbababbbaabbaaabbababaaaaaabbabaababaabbaababbbbbbababbaaa
    bbbbbaaaabaababaabbaaaba
    aaaaabbababbbaabaabbbaaababbababaaababaaaaaaabbbbaaaabab
    aabbaabbbbababababbabababbbaaaabaabaaaaa
    babbaabbabbbaaabababbabb
    abbababaabababbaaababbaaaaabaaaabaabbbbbaabbaaba
    abbbbaaabbbaaabaaaaaaabababababa
    abbbaababbbbbbbaabbbaabbaabbabbbbbaaaaaaaaaabbaaabbabbba
    abbbaaabaaababaaabbbaaaaabbababaaaaabaaaabbababbbabababa
    bababbaababbabbbabbbbaaababbabaaaabaabaa
    abbbababaaaababbbbbaabab
    bbaaabbbabbaaabbbabababb
    bbbbaaaabaaaaabbbababaaabaabaabbbbbbbbab
    aaaaaababaabbabbbaaabbbb
    bbbbbababaaaaaaaaaabbaab
    aabbbaababababbabaabbaba
    bbbaaababbabaaabbababbbaababaaaaabbabaabababbabb
    ababbbbababbbabbaaababaaaabaabab
    bababaaabaabaabaabaabaaaaaababbabaabbaaabbbbbbbb
    aabbabbabaaabbaabbbbaaba
    aaaaaabbbaaabaaababbbaaa
    aaababbbaabababbbabbaabbbabbaaabaaaaaaaa
    aaaabbababbbababaabababbabbbaaaabababbbbaaabaababbbabbab
    babaababababbbbbaaabbabb
    bbbbaabbbbbbababaababbab
    babbbbbbaababbaaaababbaabbbbabbaaabaaabbbabababaaaaaaaab
    aaaaaabbbabaabaabaaabbababaaaabaabbbbabababbbaaa
    aaabaabbaabbbababaabaaaaababbaabaabaaaaa
    ababbabababbbbaaaababbab
    aabaaabbbbaaaaabbababbab
    aaabaabaaabababbaaabbbab
    bbabaabbaabbbaaaababaaab
    bbaabbabbababbaababbaabbabbaababbbbbbaabaabaaaaa
    abaaababbbababaaabbbbbba
    aaaabaaabbbbbbbaaabbbaabaabaaaaa
    bbabbaabaabbbaaabaaabaaababbaaabababbbab
    bbabbaababbbaababbaaabbbbbababba
    baaabbbaaabababbabbbbbbb
    bbababaabaaaabbabbaabbaaaaababbaabbbabbababbbbbaabbbbbbb
    aaaababbbbbabababaaaabbbbbbbaaba
    aaababaaaabaaabababaababbabbababbbabaabbaaabbabbbabababbbbaaabaa
    abababaaabababbbbbbbabbabbbaabbabaaabbbb
    aabaaababaaaabbabbaaaaabbabaaaaa
    babbbbbbbbababbbbbbbaaba
    bababbabbababbbababbbbaa
    bbaabaababbabbaabbaabaababbabababbaabbbb
    aaabaabaaabaaababbbabbab
    bbaabbabbababbabbbbbbbbaaabbbbab
    bbbbbbbaabababbabbbbbaaaaaabbaaababbbbab
    abbabbaabaabaabaabbaaaab
    aabbbaaaabaaabababbbaabbbaaabaab
    abaaaabaabbbbbaaababbbbabaabbbabaaababaa
    ababaaaabaaaabbbaaabbaaabbabaaababaaabaabaabaabababababaaaaabbaa
    aaababbabaabbbaabbaabaababbabbbbbbbbabaabbabbbba
    bababbabaaabbbbbaababbaaaabbabbaaabaaaab
    babbabbbababbbbbbbbbbaab
    bbbaaababbaabbabaaabbbaabbbbabbaabbbaabbbbbbbbbbaaaabbaababbaaaa
    aaaaaabbbababbbaababaaab
    bababbbaabbbbbaabababaaaaaaaaababababababbbbbaabbbaabaaa
    babbbaababbaaabbaabbbaaabbbaaabbaaababaababbbbaa
    bbabaaabaaaaaabbaabaaaab
    baaaaaabaaabbbbbbbaaaaabaaababbbaaaaababaabbaaab
    aaabbaaaabbbaaababbabbab
    aabbbaabbaabbabbbabbbaaa
    baabaaaabbbaaaabbbabbaabbaabbaabbabbaabaaababbab
    abaaaaabaaabbabbabababbbababbaaabbbaabbbbaaaaabaaaaabababbbbaaabaabbbbbb
    bbabaaabbabbbabbbbaabbabaaaabaaabbaabbbbbaaababb
    abaabaaaabababbbbababaaaabbbaaaabbbabaaaaaaaabaa
    aabbabbabbababbbaaabaabb
    bbababaabaaabaaaabbbaaaabbbabbaaabbbbabb
    bbbabbabbabbbbbaaababaabbbbabbabbbababbbabbbababbababbabbbabbbbbababbaaababbbbaa
    bbaababaabbaaaabbaaababb
    abbababaaaabbbaaaaaababa
    abbbaaabaaababaabaabbaababaaaabaababbabbbabbaaab
    ababbababaabbbaabbbaaababaababbbbbaaaaba
    bababbbbaaaabbababbabbaabababaabaaaabbbababababbaaaaaaab
    bbbbabaaaabbaabbbbbabbbaaaababaabbbbbbaaaabaabbabbabbabb
    aaaaaababaabababbbbbaabbbabbabbbbbabbabbbbbbbbaa
    aaaabbabaaaabaaaabbbbbbb
    aaaaaabbbbaaabbbbabbabbbaaaabbba
    bbabaabbababbaaaabbbaaababababaabbbbbbbbaaaabbbaabbabaaa
    abbbbaabaababbbababbbbba
    aabbbaaabbaabaabbbaabaaa
    baaabbabaabaaabbaabbbaabababbbab
    abaabababbbbabaabbaabaabbaaababa
    aaabbbbbaabababbbbababba
    bababbabababaaaaabbbaabbbbabbabbabababab
    bbaabbabaaaaabababaaabba
    baabbaababbabbaaababbbbbbabbbabbabaabbaa
    ababbbbaaababbbaababbaaaaabbababbbbbbbbbbbbbababbabaaaaa
    bbabaabbbaaabbabbbbaabba
    bababbbbbbbabbbbaabbbaababbababaabbbbbaaaaabaaab
    abaabaaabbabababbbaaaaaa
    bbbaabbbbbbaabbaabbabbab
    bbabababbbbbbbabaabbbbaa
    baaabbbababbaabbabbbbbaaaaaaaaabaaabaaab
    abaaababbbbbbaaaabaaabbb
    aaabbbbabaabbabbbbabbbbbabbabaaabaaababb
    babaababababbbbbababaaab
    abaababaababbababbbbabbb
    bbbaaabbbababbaaababaabb
    aaaababbaabbbaaaaabababbabbbbabb
    abababbbbbbabbbabaabaabb
    abaaaaaabaaabbaabbaabaabaaabbaababbababb
    aaaaaaababbaababbaababbbbaabaaabbbababab
    aaabbbaaaababbbabaaaaaba
    babbbbbbabaaaaaabaabaaab
    aaabaabaaabaaabbbbaabbabbaaabbbb
    baaabbaaaaabaabaaaabaababbbabbbbbabaaaab
    aaababbabaabaabababaaabaaababbbbbbaabbbb
    abaaaaaabababbabbbabaabbbbbabaab
    bbbbbabababbabbbbbaaabab
    bbaaaaabbaabbaaabababbaababababb
    aabbbbbbbaaabbabababaaba
    babbaabbbbabaaaabbbbbbbababbbbaabbaabbbb
    abbbaaabbaaaabbaaababbbaaabaaabaabaaabababaaabbabbbabbab
    bbaabbabbbbababaaaabbaaaaaabbabb
    aaabbbbabaaabaaababbbbba
    aaabaaaaaabbabbabbabababbabbbaabbbabbbabaabbbbbabbbbaababbbabaab
    aabbabaababbbabbbbbbabab
    aabbaabaabbabaabaaabbabbbbbaaaabbabbbbaaabaaabaabbbabbbbaabbababababbabaabaabbaaaaabbbba
    babbababbabaaabaababbbbabbabaaba
    abaabbbaabaaaaabbabbbbbabaaababbbbbaaaaa
    ababbbbaabbbbbaaaabbaaba
    aabbabbabbbbabbabbabbaba
    babbbaababbbbaabbaaabbbabbbaabbb
    bbabaaaabbaabbbaabbaaaaa
    bbbbbabbbbababaabbbbabbaaaababbbaaabaaba
    aaaaaabbabbbaaaabbababbbaaaabbba
    bbbbaabbbbaabbbaaaabbbaaabaaaabbaaaabbba
    baabababbbbbbaaabaaabbbb
    aaaaaabbbaaabbbaaaababab
    baaaaaaabababaaabbaabbbb
    bbaababbaaabaabaabbabbaaaabbbbbbaaabbabb
    aaaaabbaaaaababbbaabbbbbabbaaabbabbbabbbabaabbba
    ababbaaaaabaaabaaabbaabbabbababaabbabbbaaaabaaabbabbbaaa
    abaabaaaabbbbababbbaabbb
    baaabbaaababaaaaaababbaaaaaabbaa
    aaabbaaabbaabbaaaababbbb
    bbbbbabaaabbbaabaaabbbaabababaaaaaaabbbaabbabbba
    baaaabbbabaababaaabaaabaabbbabbabbbbbbbb
    aaaaabbabaabbbbbaabaaababbbbbbabbaaaaaaaaababaaa
    abaaabaabbabababaaabbaba
    aaabaababbaababbbbbababb
    ababbaaababbbabbaaabbbabbaabaaabbabaabbaaaabaaab
    babaabaaaabbababbbbabaab
    abaaaaaaabbabbbbbbabbabb
    baabbaaaaaaabaabbaababaabbbbbbbbbabbaaab
    baaabaaaabaababababbbbabbaaaabaa
    aaababbaaabbaaaababababb
    bababbabaaaababbbababaaabbbbaaaa
    bbaabaabbaaaabbabaabbbab
    abbbabbaaaaaabbaabaabbba
    aabaaababababbbaaabaaabaaabbaaabbaaabbbb
    bbabababaababbbaabbbababaaabaababbbbbbaa
    aaaaaabaaaabaaaabbbaaabaabbbbbbb
    bbaaabbbabbbaabbbabbbabaaabaabbabaababba
    baaabbaabbaaabbabaaaabbaaababbbaaababaab
    abaabaababbbbababbbbbaab
    babababaaaabaabaaaaaaabaabbababbaabbabbaaaaabaab
    bababbbbbbaaabbaaaababbabbbbaaba
    abbabbbbabbbabbabaabaabaabaaabaabbbbaababbaaabab
    babbbabbbbbbbbbaabbabaaa
    aaaabaaabaababababbbaaabbbabbbabbbbabbbbbbbabbaa
    bbabaabbaabbabaaaaaababa
    bababbaaaababbbaabaabbaa
    babbabababbaabbaabaabbaa
    baaaabbbbbabaabbbaabaaab
    abbbaababaaaaaabbbbbbababbbbaaba
    bbbbabbaabaabaabbabbbbbb
    babbaaaaaababbbbaaaaaaababaabbab
    baaaaaaaaabbababaaababaaabaaababbbbbbabaabbbbbaaaabbbbaaabaababbabbaabbbabbbbabb
    baabbbbbbaabbabbaabbaaab
    abbbbabaaaabbbbbbaabbbbbaabbabbbbbabaabbbbabaabbaaabaaab
    aaababbbabbbabbabbbbbbbaaaabbbbaaaabaaab
    aaabaaaaaaababaaaabbaabbababbabb
    aaaaaabbababbababbbaabab
    bbbbbaaaabbaaabbbbababaaaabababbabaaabba
    babbbabaaaaaaabaaababbabbabbbbbaabbabababbaaaabb
    babaaababbaaabbaaaabbbaabaaabbbbababaabb
    abbbaababbbbabbababbababaaaabbaa
    baabaaabbbaaaabbbbabaaba
    bbbabbbbabbabbaaaabaabbbaababbaabbabbbbbaaaabbbb
    bbaaabbbbababbaaabababaaabaaabaababbbabaaaaaaabbbbbaababaabababa
    bbbaaaabbaaaaababbaaabaaaaabbaab
    baabbaabaaabaaaabaaabaaabaabbabbaaaaaaabbaababaa
    baaabaaaababbaaabbbbabbaaabaaabbaaabbbabbbbaaaaa
    aaabbaaaaabababbbaaaaaba
    aaaaaabababbbababbbbabbabababaabbbbababbbaabbbab
    babbaabbbababbaabbbaabaa
    bababbbbaababaabbabbbbbaabababaabbaaaaababbaabbaaaaaabbbabbabbabbababbaaaaaaaaabababaaab
    abbababbaabbbbaaabaaababbbaabbabbbbbabba
    baabbaaabaabbbbaaaabbbbaabaababbbbabbbaa
    bbbabbbaabbbbaabbbbbbaab
    aabbbaaaabababbabaabbabbbabaabaaabbabbba
    aaabaababbaababbaabbaabbababaaaabbababbaaaabbbab
    abababbababbabbbbabababb
    bbaaabbbaaaaababbabbabba
    baaaabbaaaabaabaaaababbbaaaabbba
    bbbaabbbaaaabaaaaabbbbbbbbaaaaabbbababbbaabaaabaaaaabbaaaaaaaaababaaababbaabaabb
    bbaabaabbaabbaaabbaaaaba
    bbbbbbbaabaaaaaaabbabababbababbbabbbbaaababbbbabaaabaabb
    aababababbbaaaaabbaabaaaabbbbbbb
    baabaabbaababaabaaaaabbbbbbababbbaaaaaab
    abbbabbbaaaaaababbabbaba
    baabbabbbbbaaabaaaabbaaaaabbaabbaababaab
    baabbaababbbaababbbbbabbabaaabbbababbaab
    baabaabbbbaabaaabaaababb
    abaaababaabbabbbaabbbbab
    aaabbbbabbbbaaabaabbaaab
    aababbaababbabbbbbabbbbbbaababba
    bababaaaabbbabbaaababbbaaabaabbbbabbbbaa
    aabbbaabaaabaabaabaabaabbababaaabaabbababaaabaaababaabba
    baaaabaaaaabababaababbbaabbbaaabbbbbbbabbbbaaaababbbabaababaaaababbbbaaabaabbabb
    abaaaabaabbabbaabbabbbbbbbaabbabaaabbaab
    bbbbbbabaaabbbaabaaaaaba
    babbbabbaabbaaaabbaaaaabbbaabbbbabaabbba
    abbbaabbababbaaabaaaaaba
    """
}