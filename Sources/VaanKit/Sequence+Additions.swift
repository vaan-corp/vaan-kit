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

@resultBuilder public struct ListBuilder<I> {
  public typealias Aggregate = [I]

  @inlinable public static func buildBlock(_ components: Aggregate...) -> Aggregate {
    buildArray(components)
  }

  @inlinable public static func buildOptional(_ component: Aggregate?) -> Aggregate {
    component ?? []
  }

  @inlinable public static func buildEither(first component: Aggregate) -> Aggregate {
    component
  }

  @inlinable public static func buildEither(second component: Aggregate) -> Aggregate {
    component
  }

  @inlinable public static func buildArray(_ components: [Aggregate]) -> Aggregate {
    components.flatMap { $0 }
  }

  @inlinable public static func buildExpression(_ expression: I) -> Aggregate {
    [expression]
  }

  @inlinable public static func buildExpression(_ expression: I?) -> Aggregate {
    expression.map { [$0] } ?? []
  }

  @inlinable public static func buildExpression<S>(_ expression: S) -> Aggregate where S: Sequence, S.Element == I {
    Array(expression)
  }
}
