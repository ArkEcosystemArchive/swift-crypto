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
        return Crypto.sha256(Data(bytes: self.toBytes(skipSignature: false, skipSecondSignature: false))).hex
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
        var timestampBytes = pack(self.timestamp)
        timestampBytes.removeLast() // Timestamp is 32bits (5 bytes), but only 4 bytes serialized
        bytes.append(contentsOf: timestampBytes)
        bytes.append(contentsOf: [UInt8](Data.init(hex: self.senderPublicKey!)!))

        let skipRecipient = self.type == .secondSignatureRegistration || self.type == .multiSignatureRegistration
        if !skipRecipient && recipientId != nil {
            bytes.append(contentsOf: base58CheckDecode(recipientId!)!)
        } else {
            bytes.append(contentsOf: [UInt8](repeating: 0, count: 21))
        }

        if vendorField != nil && (vendorField?.count)! <= 64 {
            bytes.append(contentsOf: [UInt8](vendorField!.data(using: .utf8)!))
            bytes.append(contentsOf: [UInt8](repeating: 0, count: (64 - (vendorField?.count)!)))
        } else {
            bytes.append(contentsOf: [UInt8](repeating: 0, count: 64))
        }

        var transactionBytes = pack(self.amount)
        transactionBytes.removeLast()
        bytes.append(contentsOf: transactionBytes)

        var feeBytes = pack(self.fee)
        feeBytes.removeLast()
        bytes.append(contentsOf: feeBytes)

        if self.type == .secondSignatureRegistration {
            if let signature = self.asset!["signature"] as? [String: String] {
                let publickey = signature["publicKey"]
                bytes.append(contentsOf: [UInt8](Data.init(hex: publickey!)!))
            }
        } else if self.type == .delegateRegistration {
            if let delegate = self.asset!["delegate"] as? [String: String] {
                let username = delegate["username"]!
                bytes.append(contentsOf: [UInt8](username.data(using: .utf8)!))
            }
        } else if self.type == .vote {
            if let votes = self.asset!["votes"] as? [String] {
                bytes.append(contentsOf: [UInt8](votes.joined().data(using: .utf8)!))
            }
        } else if self.type == .multiSignatureRegistration {
            if let multisig = self.asset!["multisignature"] as? [String: Any] {
                let min = multisig["min"] as! UInt8
                let lifetime = multisig["lifetime"] as! UInt8
                let keys = multisig["keysgroup"] as! [String]
                bytes.append(min)
                bytes.append(lifetime)
                bytes.append(contentsOf: [UInt8](keys.joined().data(using: .utf8)!))
            }
        }

        if !skipSignature && self.signature != nil {
            bytes.append(contentsOf: [UInt8](Data.init(hex: self.signature!)!))
        }

        if !skipSecondSignature && self.secondSignature != nil {
            bytes.append(contentsOf: [UInt8](Data.init(hex: self.secondSignature!)!))
        }

        return bytes
    }

    func toDict() -> [String: Any] {
        var transactionDict: [String: Any] = [:]
        if let amount = self.amount {
            transactionDict["amount"] = amount
        }
        if let asset = self.asset {
            transactionDict["asset"] = asset
        }
        if let id = self.id {
            transactionDict["id"] = id
        }
        if let network = self.network {
            transactionDict["network"] = network
        }
        if let recipientId = self.recipientId {
            transactionDict["recipientId"] = recipientId
        }
        if let secondSignature = self.secondSignature {
            transactionDict["secondSignature"] = secondSignature
        }
        if let senderPublicKey = self.senderPublicKey {
            transactionDict["senderPublicKey"] = senderPublicKey
        }
        if let signature = self.signature {
            transactionDict["signature"] = signature
        }
        if let signatures = self.signatures {
            transactionDict["signatures"] = signatures
        }
        if let signSignature = self.signSignature {
            transactionDict["signSignature"] = signSignature
        }
        if let timestamp = self.timestamp {
            transactionDict["timestamp"] = timestamp
        }
        if let type = self.type {
            transactionDict["type"] = type
        }
        if let vendorField = self.vendorField {
            transactionDict["vendorField"] = vendorField
        }
        if let vendorFieldHex = self.vendorFieldHex {
            transactionDict["vendorFieldHex"] = vendorFieldHex
        }
        if let version = self.version {
            transactionDict["version"] = version
        }
        
        return transactionDict
    }
    
    // TODO: func toJson()
}
