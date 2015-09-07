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

extension S7Area {
    init?(fromString string: String) {
        switch string.uppercaseString {
        case "E":
            self = .PE
        case "A":
            self = .PA
        case "M":
            self = .MK
        case "DB":
            self = .DB
        default:
            return nil
        }
    }
}

struct S7Address {
    var type: S7Area
    var length: S7WordLength
    var size: Int
    var dbNumber: Int
    var offset: Int
    var bitOffset: Int
    
    // Calculate for I/O-Operations
    var realOffset: Int {
        return self.length == .Byte ? self.offset : self.offset * 8 + self.bitOffset
    }
}

extension String {
    subscript(range: NSRange) -> String {
        return (self as NSString).substringWithRange(range)
    }
    
    func toS7Address() throws -> S7Address {
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
            guard let type = S7Area(fromString: self[match.rangeAtIndex(1)]) else {
                throw S7AddressParserError.ParseError
            }
            
            let length: S7WordLength
            let size: Int
            switch type {
            case .PE, .PA, .MK:
                switch index {
                case 0:
                    switch self[match.rangeAtIndex(2)] {
                    case "B":
                        size = 1
                        length = .Byte
                    case "W":
                        size = 2
                        length = .Byte
                    case "D":
                        size = 4
                        length = .Byte
                    default:
                        throw S7AddressParserError.ParseError
                    }
                case 1:
                    size = 1
                    length = .Bit
                    
                default:
                    throw S7AddressParserError.ParseError
                }
            case .DB:
                switch index {
                case 2:
                    switch self[match.rangeAtIndex(3)] {
                    case "B":
                        size = 1
                        length = .Byte
                    case "W":
                        size = 2
                        length = .Byte
                    case "D":
                        size = 4
                        length = .Byte
                    default:
                        throw S7AddressParserError.ParseError
                    }
                case 3:
                    size = 1
                    length = .Bit
                default:
                    throw S7AddressParserError.ParseError
                }
            default:
                throw S7AddressParserError.ParseError
            }
            
            guard let dbNumber = type == .DB ? Int(self[match.rangeAtIndex(2)]) : 0 else {
                throw S7AddressParserError.ParseError
            }
            
            
            let offset: Int
            switch index {
            case 0:
                offset = Int(self[match.rangeAtIndex(3)])!
            case 1:
                offset = Int(self[match.rangeAtIndex(2)])!
            case 2:
                offset = Int(self[match.rangeAtIndex(4)])!
            case 3:
                offset = Int(self[match.rangeAtIndex(3)])!
            default:
                offset = 0
            }
            
            let bitOffset: Int
            switch index {
            case 1:
                bitOffset = Int(self[match.rangeAtIndex(3)])!
            case 3:
                bitOffset = Int(self[match.rangeAtIndex(4)])!
            default:
                bitOffset = 0
            }
            
            return S7Address(type: type, length: length, size: size, dbNumber: dbNumber, offset: offset, bitOffset: bitOffset)
        }
        
        throw S7AddressParserError.NoMatches
    }
}
