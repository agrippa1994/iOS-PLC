//
//  S7Client.swift
//  PLC
//
//  Created by Manuel Stampfl on 04.08.15.
//  Copyright (c) 2015 mani1337. All rights reserved.
//

import Foundation

class S7Client {
    private let object = Cli_Create()
    private let dispatchQueue = dispatch_queue_create("S7Client", DISPATCH_QUEUE_CONCURRENT)
    
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
    
    func dbRead<T>(number: Int32, offset: Int32, defaultValue: T, completion: (T? -> Void)?) {
        self.async {
            var buffer = defaultValue
            Cli_DBRead(self.object, number, offset, Int32(sizeof(T)), &buffer)
            completion?(buffer)
        }
    }
}