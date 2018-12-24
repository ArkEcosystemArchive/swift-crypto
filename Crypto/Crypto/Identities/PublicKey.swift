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

public class ArkPublicKey {

    public static func from(passphrase: String) -> PublicKey {
        return ArkPrivateKey.from(passphrase: passphrase).publicKey()
    }

    public static func from(hex: String) -> PublicKey {
        return ArkPrivateKey.from(hex: hex).publicKey()
    }
}
