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

    // TODO: add remaining props
    let id: String
    let timestamp: UInt32
    let senderPublicKey: String
    var recipientId: String?
    var vendorfield: String?
    let amount: UInt64
    let fee: UInt64
    var signature: String?
    var secondSignature: String?
    let type: TransactionType

    let asset: [String: Any]

    // TODO: recheck initializer
    init(_ id: String, _ timestamp: UInt32, _ senderPublicKey: String, _ amount: UInt64, _ fee: UInt64, _ type: TransactionType, _ asset: [String: Any]) {
        self.id = id
        self.timestamp = timestamp
        self.senderPublicKey = senderPublicKey
        self.amount = amount
        self.fee = fee
        self.type = type
        self.asset = asset
    }

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
        self.signature = try! Crypto.sign(transaction, privateKey: keys).hex
        return self
    }

    func verify() -> Bool {
        let publicKey = ArkPublicKey.from(hex: self.senderPublicKey)
        // TODO: verify data
        return false
    }
    // secondVerify()

    func toBytes(skipSignature: Bool = true, skipSecondSignature: Bool = true) -> [UInt8] {
        var bytes = [UInt8]()
        bytes.append(UInt8.init(self.type.rawValue))
        bytes.append(contentsOf: pack(self.timestamp))
        bytes.append(contentsOf: [UInt8](Data.init(hex: self.senderPublicKey)!))
        // bytes.append(contentsOf: pack(self.senderPublicKey)) // Or this one for public key?

        let skipRecipient = self.type == .secondSignatureRegistration || self.type == .multiSignatureRegistration
        if !skipRecipient && recipientId != nil {
            bytes.append(contentsOf: base58CheckDecode(recipientId!)!)
        } else {
            bytes.append(contentsOf: [UInt8](repeating: 0, count: 21))
        }

        if vendorfield != nil && (vendorfield?.count)! < 64 {
            bytes.append(contentsOf: pack(self.vendorfield))
            bytes.append(contentsOf: [UInt8](repeating: 0, count: (64 - (vendorfield?.count)!)))
        } else {
            bytes.append(contentsOf: [UInt8](repeating: 0, count: 64))
        }

        bytes.append(contentsOf: pack(self.amount))
        bytes.append(contentsOf: pack(self.fee))

        // TODO: recheck this, handle if cases properly (throw error?)
        if self.type == .secondSignatureRegistration {
            if let signature = self.asset["signature"] as? [String: String] {
                let publickey = signature["publickey"]
                bytes.append(contentsOf: [UInt8](Data.init(hex: publickey!)!))
            }
        } else if self.type == .delegateRegistration {
            if let delegate = self.asset["delegate"] as? [String: String] {
                let username = delegate["username"]
                bytes.append(contentsOf: pack(username!))
            }
        } else if self.type == .vote {
            if let votes = self.asset["votes"] as? [String] {
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
