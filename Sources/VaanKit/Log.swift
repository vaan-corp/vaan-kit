//
//  File.swift
//  
//
//  Created by Imthathullah on 09/02/23.
//

import Foundation

public enum LogLevel {
  case info
  case warning
  case error
}

public func log(_ error: Error,
                file: StaticString = #fileID,
                function: StaticString = #function,
                line: UInt = #line,
                column: UInt = #column) {
  log(error.localizedDescription, .error, file: file, function: function, line: line, column: column)
}

public func log(_ message: String,
                _ level: LogLevel = .info,
                file: StaticString = #fileID,
                function: StaticString = #function,
                line: UInt = #line,
                column: UInt = #column) {
  let emoji: String = {
    switch level {
    case .info: return "ℹ️"
    case .warning: return "⚠️⚠️"
    case .error: return "💥💥💥"
    }
  }()
  print(emoji, " ", file.description.dropLast(6), ".", function, "#", line, ":", column, " ", message, separator: "")
}
