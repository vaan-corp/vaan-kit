//
//  URL+Additions.swift
//
//
//  Created by Imthathullah on 30/01/23.
//  Copyright © 2023 Vaan Corporation. All rights reserved.
//

import Foundation

public extension String {
  /// Converts the string to an URL and prepends `https://` scheme if it's missing.
  var webURLWithScheme: URL {
    get throws {
      guard !isEmpty else {
        throw CommonError("Cannot form URL with empty string")
      }
      let url = try validWebURL
      if url.scheme == nil {
        return try "https://\(url)".validWebURL
      }
      return  url
    }
  }

  private var validWebURL: URL {
    get throws {
      let trimmed = trimmingCharacters(in: .whitespacesAndNewlines)
      guard let url = URL(string: trimmed) else {
        throw CommonError("Cannot form URL from string: \(trimmed)")
      }
      guard isURLDetected(in: trimmed) else {
        throw CommonError("URL is not detected in string: \(trimmed)")
      }
      return url
    }
  }
}

private func isURLDetected(in string: String) -> Bool {
  assert(domainDetector != nil)
  let range = NSRange(string.startIndex..<string.endIndex, in: string)
  return dataDetector?.firstMatch(in: string, options: .anchored, range: range) != nil ||
  domainDetector?.firstMatch(in: string, options: .anchored, range: range) != nil
}

private let dataDetector = try? NSDataDetector(types: NSTextCheckingResult.CheckingType.link.rawValue)

/// NSDataDetector does not match some domains e.g. "ray.so", so we include an additional test with our custom domainDetector.
private let domainDetector = try? NSRegularExpression(
  pattern: #"((?:[a-z]+://)?(?!-)[a-z0-9-]{1,63}(?<!-)\.)+[a-z]{2,6}"#,
  options: .caseInsensitive
)

// MARK: Email Validation
public enum Email {
  private static let emails = [
    "ken@bell.labs",
    "guido@python.nl",
    "james@java-lang.ca",
    "bjarne@cplusplus.com",
    "ada@lovelace.co.uk",
    "matz@ruby-lang.jp",
    "brian@bell.labs",
    "chris@swift-lang.com",
    "grace@bugfree.com",
  ]

  private static let regex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"

  public static var random: String {
    return Self.emails.randomElement() ?? "john@appleseed.com"
  }

  public static func isValid(_ email: String) -> Bool {
    guard !email.isEmpty else { return false }
    let emailPred = NSPredicate(format: "SELF MATCHES %@", Self.regex)
    return emailPred.evaluate(with: email)
  }
}
