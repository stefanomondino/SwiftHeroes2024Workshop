//
//  Logger+Combine.swift
//  Core
//
//  Created by Stefano Mondino on 13/07/2020.
//

import Combine
import Foundation

public extension Publisher {
    func log(level: Logger.Level = .verbose,
             tag: Logger.Tag = .none,
             levelForAppError _: Logger.Level? = nil,
             file: String = #file,
             line: UInt = #line,
             function: String = #function) -> Publishers.HandleEvents<Self> {
        handleEvents {
            Logger.log("Subscription: \($0)",
                       level: level,
                       tag: tag,
                       file: file,
                       line: line,
                       function: function)

        } receiveOutput: {
            Logger.log("Output: \($0)",
                       level: level,
                       tag: tag,
                       file: file,
                       line: line,
                       function: function)
        } receiveCompletion: {
            Logger.log("Completion: \($0)",
                       level: level,
                       tag: tag,
                       file: file,
                       line: line,
                       function: function)
        } receiveCancel: {
            Logger.log("Cancel",
                       level: level,
                       tag: tag,
                       file: file,
                       line: line,
                       function: function)
        } receiveRequest: {
            Logger.log("Request with: \($0)",
                       level: level,
                       tag: tag,
                       file: file,
                       line: line,
                       function: function)
        }
    }
}
