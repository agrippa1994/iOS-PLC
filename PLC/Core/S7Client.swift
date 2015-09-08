//
//  S7Client.swift
//  PLC
//
//  Created by Manuel Stampfl on 04.08.15.
//  Copyright (c) 2015 mani1337. All rights reserved.
//

import Foundation

enum S7Area: Int32 {
    case PE = 0x81
    case PA = 0x82
    case MK = 0x83
    case DB = 0x84
    case CT = 0x1C
    case TM = 0x1D
}

enum S7WordLength: Int32 {
    case Bit     = 0x01
    case Byte    = 0x02
    case Word    = 0x4
    case Dword   = 0x6
    case Real    = 0x8
    case Counter = 0x1C
    case Timer   = 0x1D
}

protocol S7Convertable {
    func convert() -> Self
}

typealias BIT = Bool
typealias BYTE = UInt8
typealias WORD = UInt16
typealias DWORD = UInt32

extension BIT: S7Convertable {
    func convert() -> BIT {
        return self
    }
}

extension BYTE: S7Convertable {
    func convert() -> BYTE {
        return self
    }
}

extension WORD: S7Convertable {
    func convert() -> WORD {
        return CFSwapInt16(self)
    }
}

extension DWORD: S7Convertable {
    func convert() -> DWORD {
        return CFSwapInt32(self)
    }
}

class S7Client {
    private let object = Cli_Create()
    private let dispatchQueue = dispatch_queue_create("S7Client", DISPATCH_QUEUE_SERIAL)

    private func async(handler: Void -> Void) {
        dispatch_async(self.dispatchQueue, handler)
    }
    
    func connect(address: String, rack: Int, slot: Int, completion: (Int -> Void)?) {
        self.async {
            completion?(Int(Cli_ConnectTo(self.object, address, Int32(rack), Int32(slot))))
        }
    }
    
    func disconnect(completion: (Int -> Void)?) {
        self.async {
            completion?(Int(Cli_Disconnect(self.object)))
        }
    }
    
    func read<T: S7Convertable>(address: String, defaultValue: T, completion: ((T, Int32) -> Void)?) -> Bool {
        guard let address = (try? address.toS7Address()) else {
            return false
        }
        
        if address.size != sizeof(T) {
            return false
        }
        
        self.async {
            var buffer = defaultValue
            let retn = Cli_ReadArea(self.object, address.type.rawValue, Int32(address.dbNumber), Int32(address.realOffset), Int32(address.size), address.length.rawValue, &buffer)
            completion?(buffer.convert(), retn)
        }
        
        return true
    }
    
    func write<T: S7Convertable>(address: String, value: T, completion: (Int32 -> Void)?) -> Bool {
        guard let address = (try? address.toS7Address()) else {
            return false
        }
        
        if address.size != sizeof(T) {
            return false
        }
        
        self.async {
            var buffer = value.convert()
            completion?(Cli_WriteArea(self.object, address.type.rawValue, Int32(address.dbNumber), Int32(address.realOffset), Int32(address.size), address.length.rawValue, &buffer))
        }
        
        return true
    }
}
