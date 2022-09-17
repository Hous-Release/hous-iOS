//
//  MockParser.swift
//  Hous-iOS-release
//
//  Created by 김지현 on 2022/09/14.
//

import Foundation

final class MockParser {
  static func load<D: Codable>(_ type: D.Type, from resourceName: String) -> D? {
    guard let path = Bundle.main.path(forResource: resourceName, ofType: "json") else { return nil }

    guard let jsonString = try? String(contentsOfFile: path) else { return nil }

    let decoder = JSONDecoder()
    let data = jsonString.data(using: .utf8)

    guard let data = data else { return nil }
    return try? decoder.decode(type, from: data)

  }
}
