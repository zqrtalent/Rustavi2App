//
//  WebScrapper.swift
//  Rustavi2Tv
//
//  Created by Zaqro Butskrikidze on 10/26/18.
//  Copyright © 2018 Zakaria Butskhrikidze. All rights reserved.
//

import Foundation
import os
import Compression

public extension HttpClient {
    
    public func decodeGzipAsString(_ gzipData:Data) -> String?{
        let decodedCapacity = gzipData.count * 4 //8_000_000
        let decodedDestinationBuffer = UnsafeMutablePointer<UInt8>.allocate(capacity: decodedCapacity)
        let algorithm = COMPRESSION_ZLIB
        
        let decodedString = gzipData.withUnsafeBytes {
            (encodedSourceBuffer: UnsafePointer<UInt8>) -> String in
            let decodedCharCount = compression_decode_buffer(decodedDestinationBuffer,
                                                             decodedCapacity,
                                                             encodedSourceBuffer,
                                                             gzipData.count,
                                                             nil,
                                                             algorithm)
            
            if decodedCharCount == 0 {
                os_log("Failed decoding gzip data", type:OSLogType.error)
                return ""
            }
            
            return String(cString: decodedDestinationBuffer)
        }
        
        return decodedString
    }
}
