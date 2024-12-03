//
//  LogManager.swift
//  Polarnal
//
//  Created by 최승범 on 12/3/24.
//

import Foundation
import os

enum LogLevel: String {
    case debug = "DEBUG"
    case info = "INFO"
    case warning = "WARNING"
    case error = "ERROR"
}

struct LogManager {
    private static let logger = Logger(subsystem: "beom.Polarnal",
                                       category: "General")
    
    static func log(_ message: String,
                    level: LogLevel = .debug,
                    file: String = #file,
                    function: String = #function,
                    line: Int = #line) {
        let fileName = (file as NSString).lastPathComponent
        let logMessage = "[\(level.rawValue)] \(fileName):\(line) \(function)\n 내용: \(message)"
        
        switch level {
        case .debug:
            logger.debug("\(logMessage)")
        case .info:
            logger.info("\(logMessage)")
        case .warning:
            logger.warning("\(logMessage)")
        case .error:
            logger.error("\(logMessage)")
        }
    }
    
    static func errorLog(_ error: LocalizedError,
                         level: LogLevel = .debug,
                         file: String = #file,
                         function: String = #function,
                         line: Int = #line) {
        log(error.errorDescription!, level: level, file: file, function: function, line: line)
    }
}
