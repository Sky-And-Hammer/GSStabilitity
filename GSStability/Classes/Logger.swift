//
//  Logger.swift
//  GSStability
//
//  Created by 孟钰丰 on 2018/2/8.
//

import Foundation

/// A protocol for control all logers work or not
protocol LogGenerator: class {
    var enabel: Bool { get set }
}

/// A protocol for object which need to show by logger.
public protocol Loggerable {
    var logDetail: String { get }
}

/// A enum for loger levels
///
/// - verbose: verbose level
/// - info: info level
/// - warning: warning level
/// - error: error level
enum LogLevel: Int {
    case verbose, info, warning, error
    
    var textColor: UIColor {
        switch self {
        case .verbose: return UIColor.lightGray
        case .info: return UIColor.cyan
        case .warning: return UIColor.yellow
        case .error: return UIColor.red
        }
    }
    
    var logConsole: String {
        switch self {
        case .verbose: return "◽️"
        case .info: return "🔷"
        case .warning: return "⚠️"
        case .error: return "❌"
        }
    }
}

public func print(_ items: Any...) {
    if let items = items as? [Loggerable],  Logger.share.enabel {
        Logger.handlerLog(items, level: LogLevel.info, file: nil, function: nil, line: nil)
    } else {
        Swift.print(items)
    }
}

/// A share instance for gengrate log infos
public class Logger: LogGenerator {
    
    /// Show log date or not
    public var showDate = true
    /// Show log fileInfo or not
    public var showFileInfo = true
    /// Log date formatter, 'yyyy-MM-dd HH:mm:ss' by defualt
    public var dateFormatter = DateFormatter.init().then {
        $0.timeZone = TimeZone.current
        $0.dateFormat = "yyyy-MM-dd HH:mm:ss"
    }
    
    /// A closure for store log if you need, will call in Logger.share.queue
    /// SEE 'GSLogger'
    public var storeClosure: ((LogEntity) -> Void)? = nil
    
    var enabel: Bool = true
    
    private let queue = DispatchQueue.init(label: "com.Sky-And-Hammer.ios.GS.log.queue")
    
    static let share = Logger.init()
    
    /// Console a verbose level log
    public static func verbose(_ items: Loggerable..., module: String? = nil, file: String = #file, function: String = #function, line: Int = #line) {
        handlerLog(items, module: module, level: .verbose, file: file, function: function, line: line)
    }
    
    /// Console a info level log
    public static func info(_ items: Loggerable..., module: String? = nil, file: String = #file, function: String = #function, line: Int = #line) {
        handlerLog(items, module: module, level: .info, file: file, function: function, line: line)
    }
    
    /// Console a warning level log
    public static func warning(_ items: Loggerable..., module: String? = nil, file: String = #file, function: String = #function, line: Int = #line) {
        handlerLog(items, module: module, level: .warning, file: file, function: function, line: line)
    }
    
    /// Console a error level log
    public static func error(_ items: Loggerable..., module: String? = nil, file: String = #file, function: String = #function, line: Int = #line) {
        handlerLog(items, module: module, level: .error, file: file, function: function, line: line)
    }
    
    fileprivate static func handlerLog(_ items: [Loggerable], module: String? = nil,  level: LogLevel, file: String?, function: String?, line: Int?) {
        
        func parseFileInfo(file: String?, function: String?, line: Int?) -> String? {
            guard let file = file, let function = function, let line = line else { return nil }
            guard let fileName = file.components(separatedBy: "/").last else { return nil }
            
            return "\(fileName).\(function)[\(line)]"
        }
        
        guard Logger.share.enabel else { return }
        
        let fileInfo = parseFileInfo(file: file, function: function, line: line)
        let stringContent = items.map { $0.logDetail }.joined(separator: "\n")
        
        Logger.share.queue.async {
            let newLog = LogEntity.init(content: stringContent, module: module, fileInfo: fileInfo, level: level)
            Swift.print(newLog.debugDescription)
        }
    }
}

public struct LogEntity {
    
    let level: LogLevel
    let moduleName: String?
    let id: String
    let fileInfo: String?
    let content: String
    let timestamp: Date
    
    init(content: String, module:String?, fileInfo: String? = nil, level: LogLevel = .verbose) {
        id = NSUUID().uuidString
        self.fileInfo = fileInfo
        self.moduleName = module
        self.content = content
        self.level = level
        timestamp = Date.init()
    }
}

extension LogEntity: CustomDebugStringConvertible {
    
    public var debugDescription: String {
        var value = level.logConsole
        if Logger.share.showDate { value.append("[\(Logger.share.dateFormatter.string(from: timestamp))]") }
        if Logger.share.showFileInfo { value.append(" \(fileInfo ?? "System print")") }
        value.append(": \n**********\(moduleName ?? "SYSTEM")**********\n")
        value.append(content)
        
        return value
    }
}

extension LogEntity: CustomStringConvertible {
    public var description: String { return debugDescription }
}

// MARK: Loggerable Extensions

extension String: Loggerable { public var logDetail: String { return self } }

