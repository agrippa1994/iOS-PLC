//
//  String+S7Address.swift
//  PLC
//
//  Created by Manuel Stampfl on 06.09.15.
//  Copyright © 2015 mani1337. All rights reserved.
//

import Foundation

enum S7AddressParserError: ErrorType {
    case InvalidRegEx
    case NoMatches
    case ParseError
    case RangeError
}

enum S7Type {
    case E, A, M, DB
    
    init?(fromString string: String) {
        switch string.uppercaseString {
        case "E":
            self = .E
        case "A":
            self = .A
        case "M":
            self = .M
        case "DB":
            self = .DB
        default:
            return nil
        }
    }
}

struct S7Entry {
    var type: S7Type
    var bitLength: Int
    var start: Int
    var offset: Int?
    var bitOffset: Int?
}

extension String {
    subscript(range: NSRange) -> String {
        return (self as NSString).substringWithRange(range)
    }
    
    func toS7Entry() throws -> S7Entry {
        let patterns = [
            "^(E|A|M)(B|W|D)(\\d+)$",               // EB1000, AW4, MD0
            "^(E|A|M)(\\d+)\\.([0-7])$",            // E5.5, A0.0, M100.2
            "^(DB)(\\d+)\\.DB(B|W|D)(\\d+)$",       // DB1000.DBW100
            "^(DB)(\\d+)\\.DBX(\\d+)\\.([0-7])$"    // DB1.DBX5.1
        ]
        
        for (index, pattern) in patterns.enumerate() {
            guard let regex = try? NSRegularExpression(pattern: pattern, options: [.AllowCommentsAndWhitespace, .CaseInsensitive]) else {
                throw S7AddressParserError.InvalidRegEx
            }
            
            guard let stringRange = self.rangeOfString(self) else {
                throw S7AddressParserError.RangeError
            }
            
            let range = NSRange(location: 0, length: stringRange.count)
            let matches = regex.matchesInString(self, options: .Anchored, range: range)
            
            if matches.count == 0 {
                continue
            }
            
            let match = matches[0]
            let type = S7Type(fromString: self[match.rangeAtIndex(1)])!
            
            let bitLength: Int
            switch type {
            case .E, .A, .M:
                switch index {
                case 0:
                    switch self[match.rangeAtIndex(2)] {
                    case "B":
                        bitLength = 8
                    case "W":
                        bitLength = 16
                    case "D":
                        bitLength = 32
                    default:
                        throw S7AddressParserError.ParseError
                    }
                case 1:
                    bitLength = 1
                    
                default:
                    throw S7AddressParserError.ParseError
                }
            case .DB:
                switch index {
                case 2:
                    switch self[match.rangeAtIndex(3)] {
                    case "B":
                        bitLength = 8
                    case "W":
                        bitLength = 16
                    case "D":
                        bitLength = 32
                    default:
                        throw S7AddressParserError.ParseError
                    }
                case 3:
                    bitLength = 1
                default:
                    throw S7AddressParserError.ParseError
                }
            }
            
            let start: Int
            switch index {
            case 0:
                start = Int(self[match.rangeAtIndex(3)])!
            default:
                start = Int(self[match.rangeAtIndex(2)])!
            }
            
            let offset: Int?
            switch index {
            case 2:
                offset = Int(self[match.rangeAtIndex(4)])!
            case 3:
                offset = Int(self[match.rangeAtIndex(3)])!
            default:
                offset = nil
            }
            
            let bitOffset: Int?
            switch index {
            case 1:
                bitOffset = Int(self[match.rangeAtIndex(3)])!
            case 3:
                bitOffset = Int(self[match.rangeAtIndex(4)])!
            default:
                bitOffset = nil
            }
            
            return S7Entry(type: type, bitLength: bitLength, start: start, offset: offset, bitOffset: bitOffset)
        }
        
        throw S7AddressParserError.NoMatches
    }
}
