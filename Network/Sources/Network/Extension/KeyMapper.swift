//
//  KeyMapper.swift
//  
//
//  Created by 김호세 on 2022/09/17.
//

import Foundation

struct KeyMapper: CodingKey {
  var stringValue: String
  var intValue: Int?
  init(stringValue: String) {
    self.stringValue = stringValue
  }
  init?(intValue: Int) {
    self.stringValue = String(intValue)
    self.intValue = intValue
  }
}

extension KeyedDecodingContainer where K == KeyMapper {
  func decode<T>(
    _ type: T.Type,
    forMappedKey key: String,
    in keyMap: [String: [String]]
  ) throws -> T where T: Decodable {
    for key in keyMap[key] ?? [] {
      if let value = try? decode(T.self, forKey: KeyMapper(stringValue: key)) {
        return value
      }
    }
    return try decode(T.self, forKey: KeyMapper(stringValue: key))
  }
}
