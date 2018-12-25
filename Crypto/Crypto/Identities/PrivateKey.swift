//
// This file is part of Ark Swift Crypto.
//
// (c) Ark Ecosystem <info@ark.io>
//
// For the full copyright and license information, please view the LICENSE
// file that was distributed with this source code.
//

import Foundation
import BitcoinKit

public class ArkPrivateKey {

    public static func from(passphrase: String) -> PrivateKey {
        let hash = Crypto.sha256(passphrase.data(using: .utf8)!)
        return PrivateKey.init(data: hash)
    }

    public static func from(hex: String) -> PrivateKey {
        return PrivateKey.init(data: Data.init(hex: hex)!)
    }

    // FIXME: with wif, the network is checked for which BitcoinKit only has BTC/BCH networks
    // therefore this returns an invalidFormat error for ARK
//    public static func from(wif: String) throws -> PrivateKey {
//        return try PrivateKey.init(wif: wif)
//    }
}
