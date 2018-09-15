// 
// This file is part of Ark Swift Crypto.
//
// (c) Ark Ecosystem <info@ark.io>
//
// For the full copyright and license information, please view the LICENSE
// file that was distributed with this source code.
//

import Foundation

class Slot {

    static func time() -> Int {
        let epoch = self.rfc3339().date(from: Network.shared.get().epoch())?.timeIntervalSince1970
        let now = NSDate().timeIntervalSince1970

        return Int(now - epoch!)
    }

    static func epoch() -> Int {
        return Int((self.rfc3339().date(from: Network.shared.get().epoch())?.timeIntervalSince1970)!)
    }

    private static func rfc3339() -> DateFormatter {
        let formatter = DateFormatter()
        formatter.calendar = Calendar(identifier: .iso8601)
        formatter.locale = Locale(identifier: "en_US_POSIX")
        formatter.timeZone = TimeZone(secondsFromGMT: 0)
        formatter.dateFormat = "yyyy'-'MM'-'dd'T'HH':'mm':'ssZ"
        return formatter
    }
}
