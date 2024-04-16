import Foundation

// sourcery: AutoMockable
public protocol LoggerType {
    func log(_ logLine: LogLine)
}

/**
 A global-state class to log lines in any type of `LoggerType` object registered into it
 */
public class Logger {
    private var loggers: [LoggerType] = []

    public internal(set) static var shared = Logger()

    public init() {}

    static var now: () -> Date = { Date() }

    public func add(logger: LoggerType) {
        loggers.append(logger)
    }

    public static func log(_ message: Any,
                           level: Level = .verbose,
                           tag: Tag = .none,
                           file: String = #file,
                           line: UInt = #line,
                           function: String = #function) {
        shared.log(.init(message: String(describing: message),
                         level: level,
                         tag: tag,
                         file: file,
                         line: line,
                         function: function))
    }

    public static func log(_ logLine: LogLine) {
        shared.log(logLine)
    }

    public func log(_ logLine: LogLine) {
        loggers.forEach { $0.log(logLine) }
    }
}

//protocol ClosureInitializable: AnyObject {
//    init()
//}
//
//extension NSObject: ClosureInitializable {}
//
//extension ClosureInitializable {
//    init(_ closure: (Self) -> Void) {
//        self.init()
//        closure(self)
//    }
//}
