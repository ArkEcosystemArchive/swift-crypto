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

class ArkAddress {

    // TODO: pass along the network used?
    static func from(passphrase: String, network: UInt8? = nil) -> String {
        return from(privateKey: ArkPrivateKey.from(passphrase: passphrase), network: network)
    }

    static func from(privateKey: PrivateKey, network: UInt8? = nil) -> String {
        return from(publicKey: privateKey.publicKey().raw.hex, network: network)
    }

    static func from(publicKey: String, network: UInt8? = nil) -> String {
        let networkVersion = network != nil ? network! : ArkNetwork.shared.get().version()
        let ripemd160 = Crypto.ripemd160(Data.init(hex: publicKey)!)
        var seed = [UInt8]()
        seed.append(networkVersion)
        seed.append(contentsOf: ripemd160)

        return base58CheckEncode(seed)
    }

    static func validate(address: String) -> Bool {
        let decoded = base58CheckDecode(address)
        if let decoded = decoded {
            return ArkNetwork.shared.get().version() == decoded.first
        }
        return false
    }
}
