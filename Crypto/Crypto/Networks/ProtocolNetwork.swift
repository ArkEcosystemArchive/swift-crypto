// 
// This file is part of Ark Swift Crypto.
//
// (c) Ark Ecosystem <info@ark.io>
//
// For the full copyright and license information, please view the LICENSE
// file that was distributed with this source code.
//

import Foundation

public protocol ProtocolNetwork {
    func epoch() -> String
    func version() -> UInt8
    func nethash() -> String
    func wif() -> UInt8
}
