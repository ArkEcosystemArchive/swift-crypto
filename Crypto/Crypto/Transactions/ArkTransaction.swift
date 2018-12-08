// 
// This file is part of Ark Swift Crypto.
//
// (c) Ark Ecosystem <info@ark.io>
//
// For the full copyright and license information, please view the LICENSE
// file that was distributed with this source code.
//

//swiftlint:disable force_try

import Foundation
import BitcoinKit

class ArkTransaction {

    // Header
    var header: UInt8?
    var version: UInt8?
    var network: UInt8?
    var type: TransactionType?
    var timestamp: UInt32?

    // Types
    var id: String?
    var senderPublicKey: String?
    var recipientId: String?
    var vendorField: String?
    var vendorFieldHex: String?
    var amount: UInt64?
    var fee: UInt64?

    // Signatures
    var signature: String?
    var secondSignature: String?
    var signSignature: String?
    var signatures: [String]?

    var expiration: UInt32?

    var asset: [String: Any]?

    func getId() -> String {
        return Crypto.sha256(Data(bytes: self.toBytes())).hex
    }

    // TODO: proper try statement
    func sign(_ keys: PrivateKey) -> ArkTransaction {
        let transaction = Crypto.sha256(Data(bytes: self.toBytes()))
        self.signature = try! Crypto.sign(transaction, privateKey: keys).hex
        return self
    }

    // TODO: proper try statement
    func secondSign(_ keys: PrivateKey) -> ArkTransaction {
        let transaction = Crypto.sha256(Data(bytes: self.toBytes(skipSignature: false)))
        self.signSignature = try! Crypto.sign(transaction, privateKey: keys).hex
        return self
    }

    func verify() -> Bool {
        let publicKey = ArkPublicKey.from(hex: self.senderPublicKey!)
        // TODO: verify data
        return false
    }
    // secondVerify()

    func toBytes(skipSignature: Bool = true, skipSecondSignature: Bool = true) -> [UInt8] {
        var bytes = [UInt8]()
        bytes.append(UInt8.init(self.type!.rawValue))
        bytes.append(contentsOf: pack(self.timestamp))
        bytes.append(contentsOf: [UInt8](Data.init(hex: self.senderPublicKey!)!))
        // bytes.append(contentsOf: pack(self.senderPublicKey)) // Or this one for public key?

        let skipRecipient = self.type == .secondSignatureRegistration || self.type == .multiSignatureRegistration
        if !skipRecipient && recipientId != nil {
            bytes.append(contentsOf: base58CheckDecode(recipientId!)!)
        } else {
            bytes.append(contentsOf: [UInt8](repeating: 0, count: 21))
        }

        if vendorField != nil && (vendorField?.count)! < 64 {
            bytes.append(contentsOf: pack(self.vendorField))
            bytes.append(contentsOf: [UInt8](repeating: 0, count: (64 - (vendorField?.count)!)))
        } else {
            bytes.append(contentsOf: [UInt8](repeating: 0, count: 64))
        }

        bytes.append(contentsOf: pack(self.amount))
        bytes.append(contentsOf: pack(self.fee))

        // TODO: recheck this, handle if cases properly (throw error?)
        if self.type == .secondSignatureRegistration {
            if let signature = self.asset!["signature"] as? [String: String] {
                let publickey = signature["publickey"]
                bytes.append(contentsOf: [UInt8](Data.init(hex: publickey!)!))
            }
        } else if self.type == .delegateRegistration {
            if let delegate = self.asset!["delegate"] as? [String: String] {
                let username = delegate["username"]
                bytes.append(contentsOf: pack(username!))
            }
        } else if self.type == .vote {
            if let votes = self.asset!["votes"] as? [String] {
                let voteString = votes.joined()
                bytes.append(contentsOf: pack(voteString))
            }
        } else if self.type == .multiSignatureRegistration {
            // TODO: implement
        }

        if !skipSignature && self.signature != nil {
            bytes.append(contentsOf: [UInt8](Data.init(hex: self.signature!)!))
        }

        if !skipSecondSignature && self.secondSignature != nil {
            bytes.append(contentsOf: [UInt8](Data.init(hex: self.secondSignature!)!))
        }

        return bytes
    }

}
