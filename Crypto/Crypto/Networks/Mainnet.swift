// 
// This file is part of Ark Swift Crypto.
//
// (c) Ark Ecosystem <info@ark.io>
//
// For the full copyright and license information, please view the LICENSE
// file that was distributed with this source code.
//

import Foundation

class Mainnet: Network {
    func epoch() -> String {
        return "2017-03-21T13:00:00.000Z"
    }

    func version() -> UInt8 {
        return 0x17
    }

    func nethash() -> String {
        return "6e84d08bd299ed97c212c886c98a57e36545c8f5d645ca7eeae63a8bd62d8988"
    }

    func wif() -> UInt8 {
        return 170
    }
}
