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

enum S7ConnectionType: word {
    case PG = 1
    case OP
    case Basic
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

enum S7BlockType: Int32 {
    case OB  = 0x08
    case DB  = 0x0A
    case SDB = 0x0B
    case FC  = 0x0C
    case SFC = 0x0D
    case FB  = 0x0E
    case SFB = 0x0F
}

enum S7BlockLanguage: Int32 {
    case AWL = 1
    case KOP
    case FUP
    case SCL
    case DB
    case Graph
}

enum S7Error: longword {
    case NegotiatingPDU         = 0x00100000;
    case InvalidParams          = 0x00200000;
    case JobPending             = 0x00300000;
    case TooManyItems           = 0x00400000;
    case InvalidWordLen         = 0x00500000;
    case PartialDataWritten     = 0x00600000;
    case SizeOverPDU            = 0x00700000;
    case InvalidPlcAnswer       = 0x00800000;
    case AddressOutOfRange      = 0x00900000;
    case InvalidTransportSize   = 0x00A00000;
    case WriteDataSizeMismatch  = 0x00B00000;
    case ItemNotAvailable       = 0x00C00000;
    case InvalidValue           = 0x00D00000;
    case CannotStartPLC         = 0x00E00000;
    case AlreadyRun             = 0x00F00000;
    case CannotStopPLC          = 0x01000000;
    case CannotCopyRamToRom     = 0x01100000;
    case CannotCompress         = 0x01200000;
    case AlreadyStop            = 0x01300000;
    case FunNotAvailable        = 0x01400000;
    case UploadSequenceFailed   = 0x01500000;
    case InvalidDataSizeRecvd   = 0x01600000;
    case InvalidBlockType       = 0x01700000;
    case InvalidBlockNumber     = 0x01800000;
    case InvalidBlockSize       = 0x01900000;
    case DownloadSequenceFailed = 0x01A00000;
    case InsertRefused          = 0x01B00000;
    case DeleteRefused          = 0x01C00000;
    case NeedPassword           = 0x01D00000;
    case InvalidPassword        = 0x01E00000;
    case NoPasswordToSetOrClear = 0x01F00000;
    case JobTimeout             = 0x02000000;
    case PartialDataRead        = 0x02100000;
    case BufferTooSmall         = 0x02200000;
    case FunctionRefused        = 0x02300000;
    case Destroying             = 0x02400000;
    case InvalidParamNumber     = 0x02500000;
    case CannotChangeParam      = 0x02600000;
}

typealias S7BlockCount = TS7BlocksList

class S7Client {
    private let object = Cli_Create()
    private let dispatchQueue = dispatch_queue_create("S7Client", DISPATCH_QUEUE_CONCURRENT)
    private let lock = NSLock()
    
    private func async(handler: Void -> Void) {
        dispatch_async(self.dispatchQueue, handler)
    }
    
    func connect(address: String, rack: Int, slot: Int, completion: (Int -> Void)?) {
        self.async {
            completion?(Int(Cli_Connect(self.object)))
        }
    }
    
    func disconnect(completion: (Int -> Void)?) {
        self.async {
            completion?(Int(Cli_Disconnect(self.object)))
        }
    }
    
    func setConnectionType(type: S7ConnectionType) -> Int32 {
        return Cli_SetConnectionType(self.object, type.rawValue)
    }
    
    func read<T>(area: S7Area, number: Int32, offset: Int32, defaultValue: T, completion: ((T?, Int32) -> Void)?) {
        self.async {
            var buffer = defaultValue
            var retn = Cli_ReadArea(self.object, area.rawValue, number, offset, Int32(sizeof(T)), S7WordLength.Byte.rawValue, &buffer)
            completion?(buffer, retn)
        }
    }
    
    func write<T>(area: S7Area, number: Int32, offset: Int32, value: T, completion: (Int32 -> Void)?) {
        self.async {
            var buffer = value
            completion?(Cli_WriteArea(self.object, area.rawValue, number, offset, Int32(sizeof(T)), S7WordLength.Byte.rawValue ,&buffer))
        }
    }
    
    func numberOfBlocks(completion: ((S7BlockCount?, Int32) -> Void)?) {
        self.async {
            var list = S7BlockCount()
            var retn = Cli_ListBlocks(self.object, &list)
            completion?(list, retn)
        }
    }
}