//
//  Sequence+Additions.swift
//  
//
//  Created by Imthathullah on 31/01/23.
//

import Foundation

public extension Sequence {
  func sorted<T: Comparable>(
    by keyPath: KeyPath<Element, T>,
    using comparator: (T, T) -> Bool = (<)
  ) -> [Element] {
    sorted { lhs, rhs in
      comparator(lhs[keyPath: keyPath], rhs[keyPath: keyPath])
    }
  }
}
