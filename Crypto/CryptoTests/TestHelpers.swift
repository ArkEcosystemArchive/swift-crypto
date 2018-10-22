// 
// This file is part of Ark Swift Crypto.
//
// (c) Ark Ecosystem <info@ark.io>
//
// For the full copyright and license information, please view the LICENSE
// file that was distributed with this source code.
//

import Foundation

public func readJson(file: String, type: AnyClass) -> [String: Any] {
    let bundle = Bundle(for: type)
    if let path = bundle.path(forResource: file, ofType: "json") {
        do {
            let data = try Data(contentsOf: URL(fileURLWithPath: path), options: .mappedIfSafe)
            let jsonResult = try JSONSerialization.jsonObject(with: data, options: .mutableLeaves)
            if let jsonResult = jsonResult as? [String: Any] {
                return jsonResult
            }
        } catch {
            debugPrint("Error while parsing json")
            return [:]
        }
    }
    debugPrint("No resource found")
    return [:]
}
