// 
// This file is part of Ark Swift Crypto.
//
// (c) Ark Ecosystem <info@ark.io>
//
// For the full copyright and license information, please view the LICENSE
// file that was distributed with this source code.
//

import Foundation

public class Devnet: ProtocolNetwork {
    
    public init() {}
    
    public func epoch() -> String {
        return "2017-03-21T13:00:00.000Z"
    }

    public func version() -> UInt8 {
        return 0x1E
    }

    public func nethash() -> String {
        return "2a44f340d76ffc3df204c5f38cd355b7496c9065a1ade2ef92071436bd72e867"
    }

    public func wif() -> UInt8 {
        return 170
    }
}
