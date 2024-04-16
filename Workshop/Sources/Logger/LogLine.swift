//
//  LogLine.swift
//  Core
//
//  Created by Stefano Mondino on 28/12/21.
//

import Foundation

public struct LogLine: Equatable, ExpressibleByStringInterpolation {
    public static let dateFormatter: DateFormatter = .init()
    public let message: String
    public let level: Logger.Level
    public let tag: Logger.Tag
    public let file: String
    public let line: UInt
    public let function: String
    public let date = Logger.now()
    public let logRemotely: Bool
    public init(stringLiteral: String) {
        self.init(message: stringLiteral, level: .default, tag: .none)
    }

    public init(message: String,
                level: Logger.Level,
                tag: Logger.Tag,
                logRemotely: Bool = false,
                file: String = #file,
                line: UInt = #line,
                function: String = #function) {
        self.message = message
        self.level = level
        self.tag = tag
        self.file = file
        self.line = line
        self.function = function
        self.logRemotely = logRemotely
    }

    public func fileString() -> String {
        let trimmedFile: String = if let lastIndex = file.lastIndex(of: "/") {
            String(file[file.index(after: lastIndex) ..< file.endIndex])
        } else {
            file
        }
        return "\(trimmedFile):\(line) (\(function))"
    }

    public func line(logFileLines: Bool = true,
                     dateFormat: String = "dd-MM-YYYY HH:mm:ss.sss") -> String {
        if LogLine.dateFormatter.dateFormat != dateFormat {
            LogLine.dateFormatter.dateFormat = dateFormat
        }

        let fileString: String? = logFileLines ? fileString() : nil
        let date = LogLine.dateFormatter.string(from: date)
        let tagString = tag.description.isEmpty ? "" : "[\(tag)]"

        return
            """
            \([[[tagString, date].filter { !$0.isEmpty }.joined(separator: " "),
                [fileString].compactMap { $0 }.joined()].joined(separator: " - "),
               message.description].joined(separator: " -> ")
            )
            """
    }
}
