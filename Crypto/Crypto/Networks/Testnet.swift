// 
// This file is part of Ark Swift Crypto.
//
// (c) Ark Ecosystem <info@ark.io>
//
// For the full copyright and license information, please view the LICENSE
// file that was distributed with this source code.
//

import Foundation

class Testnet: Network {
    func epoch() -> String {
        return "2017-03-21T13:00:00.000Z"
    }

    func version() -> UInt8 {
        return 0x17
    }

    func nethash() -> String {
        return "todo"
    }

    func wif() -> UInt8 {
        return 186
    }
}
