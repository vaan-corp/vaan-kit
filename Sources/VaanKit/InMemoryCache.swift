//
//  File.swift
//  
//
//  Created by Imthathullah on 14/02/23.
//

import Foundation

/// Note: InMemoryCache is thread-safe because it is implemented using NSCache.
/// You can add, remove, and query items in the cache from different threads without having to lock the cache yourself.
public final class InMemoryCache<Key: Hashable, Value> {
  private let cache = NSCache<WrappedKey, Entry>()

  public init(totalCostLimit: Int? = nil) {
    if let limit = totalCostLimit {
      cache.totalCostLimit = limit
    }
  }

  // Apple doc says not to set cost manually
  public func setValue(_ value: Value, forKey key: Key, cost: Int? = nil) {
    let entry = Entry(value: value)
    if let cost = cost {
      cache.setObject(entry, forKey: WrappedKey(key), cost: cost)
    } else {
      cache.setObject(entry, forKey: WrappedKey(key))
    }
  }

  public func value(forKey key: Key) -> Value? {
    cache.object(forKey: WrappedKey(key))?.value
  }

  public func removeValue(forKey key: Key) {
    cache.removeObject(forKey: WrappedKey(key))
  }

  /// removes all cached values
  public func removeAll() {
    cache.removeAllObjects()
  }

  public subscript(key: Key) -> Value? {
    get { value(forKey: key) }
    set {
      guard let value = newValue else {
        return removeValue(forKey: key)
      }
      setValue(value, forKey: key)
    }
  }
}

private extension InMemoryCache {
  final class WrappedKey: NSObject {
    let key: Key

    init(_ key: Key) {
      self.key = key
    }

    override var hash: Int {
      key.hashValue
    }

    override func isEqual(_ object: Any?) -> Bool {
      guard let value = object as? WrappedKey else { return false }
      return value.key == key
    }
  }

  final class Entry {
    let value: Value

    init(value: Value) {
      self.value = value
    }
  }
}
