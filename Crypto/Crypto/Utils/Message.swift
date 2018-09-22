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

class ArkMessage: Codable {

    let publicKey: String
    let signature: String
    let message: String

    public init(publicKey: String, signature: String, message: String) {
        self.publicKey = publicKey
        self.signature = signature
        self.message = message
    }

    // TODO: throw proper error
    static func sign(message: String, passphrase: String) -> ArkMessage? {
        let keys = ArkPrivateKey.from(passphrase: passphrase)
        let hash = Crypto.sha256(message.data(using: .utf8)!)
        do {
            return try ArkMessage(publicKey: keys.publicKey().raw.hex,
                              signature: Crypto.sign(hash, privateKey: keys).hex,
                              message: message)
        } catch {
            return nil
        }
    }

    // TODO: throw proper error
    // TODO: fix this
    func verify() -> Bool {
        do {
            return try Crypto.verifySignature(self.signature.data(using: .utf8)!,
                                      message: Crypto.sha256(message.data(using: .utf8)!),
                                      publicKey: ArkPublicKey.from(hex: self.publicKey).raw)
        } catch {
            return false
        }
    }

    func toDict() -> [String: String] {
        return [
            "publickey": self.publicKey,
            "signature": self.signature,
            "message": self.message
        ]
    }

    // TODO: throw proper error
    func toJson() -> String {
        do {
            let jsonEncoder = JSONEncoder()
            let jsonData = try jsonEncoder.encode(self)
            return String(data: jsonData, encoding: String.Encoding.utf8)!
        } catch {
            return ""
        }
    }
}
