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

class WIF {

    static func from(passphrase: String) -> String {
        var bytes = [UInt8]()
        bytes.append(ArkNetwork.shared.get().wif())
        bytes.append(contentsOf: Crypto.sha256(passphrase.data(using: .utf8)!))
        bytes.append(0x01)

        return base58CheckEncode(bytes)
    }

    private static func base58CheckEncode(_ bytes: [UInt8]) -> String {
        let checksum = Crypto.sha256sha256(Data.init(bytes: bytes)).prefix(4)
        var checkedBytes = bytes
        checkedBytes.append(contentsOf: checksum)

        return Base58.encode(Data.init(bytes: checkedBytes))
    }
}
