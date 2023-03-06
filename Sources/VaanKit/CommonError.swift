//
//  CommonError.swift
//  
//
//  Created by Imthathullah on 31/01/23.
//

import Foundation

public struct CommonError: Error {
  public let message: String
  public let underlingError: Error?

  public init(_ message: String, underlyingError: Error? = nil) {
    self.message = message
    self.underlingError = underlyingError
  }
}
