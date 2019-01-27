//
//  Log.swift
//  Rustavi2TvShared
//
//  Created by Zaqro Butskrikidze on 1/27/19.
//  Copyright © 2019 Zakaria Butskhrikidze. All rights reserved.
//

import Foundation

public enum LogLevel{
    case verbose, warning, error, critical
}

public protocol ILog{
    func writeLog(_ sLog: String, level: LogLevel) -> Void
}

public class Log : ILog{
    
    public func writeLog(_ sLog: String, level: LogLevel) {
        // TODO: log error here.
    }
}


