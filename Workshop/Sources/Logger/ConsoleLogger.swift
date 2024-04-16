//
//  ConsoleLogger.swift
//  App
//
//  Created by Stefano Mondino on 17/07/18.
//  Copyright © 2018 Deltatre. All rights reserved.
//

import Foundation
import os

public final class ConsoleLogger: LoggerType {
    public init(logLevel: Logger.Level, logFileLines: Bool = false) {
        self.logLevel = logLevel
        self.logFileLines = logFileLines
    }
    private let identifier = Bundle.main.bundleIdentifier ?? ""
    public let logLevel: Logger.Level
    public var isEnabled: Bool = true
    public var logFileLines: Bool
    
    public func log(_ logLine: LogLine) {
        let level = logLine.level
        guard
            isEnabled,
            logLevel != .none,
            level != .none,
            level.rawValue >= logLevel.rawValue else { return }

        let logger = os.Logger(subsystem: identifier,
                               category: logLine.tag.description)
        if logLevel < .default {
            let fileInfo = fileInfo(for: logLine)
            logger.log(level: level.logType, "\(fileInfo)\n\n\(logLine.message)")
        } else {
            logger.log(level: level.logType, "\(logLine.message)")
        }
    }

    private func fileInfo(for logLine: LogLine) -> String {
        let file = logLine.file
        let trimmedFile: String = if let lastIndex = file.lastIndex(of: "/") {
            String(file[file.index(after: lastIndex) ..< file.endIndex])
        } else {
            file
        }
        return "\(trimmedFile):\(logLine.line) (\(logLine.function))"
    }
}

private extension Logger.Level {
    var logType: os.OSLogType {
        if self >= .error { return .fault }
        if self >= .warning { return .error }
        if self >= .default { return .info }
        return .debug
    }
}
