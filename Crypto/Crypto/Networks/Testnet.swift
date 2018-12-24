// 
// This file is part of Ark Swift Crypto.
//
// (c) Ark Ecosystem <info@ark.io>
//
// For the full copyright and license information, please view the LICENSE
// file that was distributed with this source code.
//

import Foundation

public class Testnet: ProtocolNetwork {
    public func epoch() -> String {
        return "2017-03-21T13:00:00.000Z"
    }

    public func version() -> UInt8 {
        return 0x17
    }

    public func nethash() -> String {
        return "todo"
    }

    public func wif() -> UInt8 {
        return 186
    }
}
