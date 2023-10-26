//
//  Concurrency.swift
//  ProTube
//
//  Created by Imthathullah on 04/03/23.
//

import Foundation

@available(iOS 16.0, *)
public extension Duration {
  static func measure<Result>(
    prefix: String = "",
    file: StaticString = #fileID,
    function: StaticString = #function,
    line: UInt = #line,
    column: UInt = #column,
    _ work: () throws -> Result
  ) throws -> Result {
    let clock = ContinuousClock()
    var result: Result?
    var workError: Error?
    let duration = clock.measure {
      do {
        result = try work()
      } catch {
        workError = error
        log(error, file: file, function: function, line: line, column: column)
      }
    }
    let string = result == nil ? "Failure" : "Success"
    log("\(prefix)\(string) Duration \(duration.milliSecondsString)", file: file, function: function, line: line, column: column)
    guard let result else {
      throw workError ?? CommonError("Failed producing result with work")
    }
    return result
  }

  static func measure<Result>(
    prefix: String = "",
    file: StaticString = #fileID,
    function: StaticString = #function,
    line: UInt = #line,
    column: UInt = #column,
    _ work: () async throws -> Result
  ) async throws -> Result {
    let clock = SuspendingClock()
    var result: Result?
    var workError: Error?
    let duration = await clock.measure {
      do {
        result = try await work()
      } catch {
        workError = error
        log(error, file: file, function: function, line: line, column: column)
      }
    }
    let string = result == nil ? "Failure" : "Success"
    log("\(prefix) \(string) Duration \(duration.milliSecondsString)", file: file, function: function, line: line, column: column)
    guard let result else {
      throw workError ?? CommonError("Failed producing result with work")
    }
    return result
  }
}

@available(iOS 16.0, *)
public extension Task<Void, any Error> {
  static func measured(file: StaticString = #fileID,
                       function: StaticString = #function,
                       line: UInt = #line,
                       column: UInt = #column,
                       _ work: @escaping @Sendable () async throws -> Void) {
    Self.init {
      let clock = ContinuousClock()
      let duration = try await clock.measure(work)
      log("Duration \(duration.milliSecondsString)", file: file, function: function, line: line, column: column)
    }
  }
}

@available(iOS 16.0, *)
public func measuredTask(_ work: @escaping @Sendable () async throws -> Void) {
  Task {
    let clock = ContinuousClock()
    let duration = try await clock.measure(work)
    log("Duration \(duration.milliSecondsString)")
  }
}

@available(iOS 16.0, *)
private extension Duration {
  var milliSecondsString: String {
    let seconds = components.seconds
    let atto = components.attoseconds
    let milli = Double(atto) / Double(pow(Double(10), 15))
    if seconds == .zero {
      return "\(milli) ms"
    }
    return "\(seconds)\(milli) ms"
  }
}
