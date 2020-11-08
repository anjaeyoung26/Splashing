//
//  Response+Rx.swift
//  Splashing
//
//  Created by 안재영 on 2020/09/21.
//  Copyright © 2020 안재영. All rights reserved.
//

import RxSwift

extension PrimitiveSequence where Trait == SingleTrait, Element == Response {
  func mapJSON<Model: Decodable>(_ model: Model.Type) -> PrimitiveSequence<Trait, Model> {
    return self
      .map { response in
        try JSONDecoder().decode(model, from: response.data)
      }
      .do(onError: { error in
        log.error(error)
      })
  }
  
  func mapJSON<Model: Decodable>(_ list: List<Model>.Type) -> PrimitiveSequence<Trait, List<Model>> {
    return self
      .map { response -> List<Model> in
        let item    = try JSONDecoder().decode([Model].self, from: response.data)
        let nextURL = Self.findNextURL(response: response)
        return List<Model>(item: item, nextURL: nextURL)
      }
      .do(onError: { error in
        log.error(error)
      })
  }

  private static func findNextURL(response: Response) -> URL? {
    guard let linkString = response.response.allHeaderFields["Link"] as? String else { return nil }
    return self.links(from: linkString)
      .first { url, relation in relation == "next" }
      .map   { url, relation in url }
  }

  private static func links(from linkString: String) -> [(url: URL, relation: String)] {
    return linkString
      .components(separatedBy: ",")
      .map { $0.trimmingCharacters(in: .whitespacesAndNewlines) }
      .compactMap { part in
        guard let urlString = self.firstMatch(in: part, pattern: "^<(.*)>") else { return nil }
        guard let url       = URL(string: urlString) else { return nil }
        guard let relation = self.firstMatch(in: part, pattern: "rel=\"(.*)\"") else { return nil }
        return (url: url, relation: relation)
      }
  }

  private static func firstMatch(in string: String, pattern: String) -> String? {
    guard let regex = try? NSRegularExpression(pattern: pattern) else { return nil }

    let nsString = string as NSString
    let range    = NSMakeRange(0, nsString.length)

    guard let result = regex.firstMatch(in: string, range: range) else { return nil }
    return nsString.substring(with: result.range(at: 1))
  }
}
