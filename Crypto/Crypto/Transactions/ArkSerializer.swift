// 
// This file is part of Ark Swift Crypto.
//
// (c) Ark Ecosystem <info@ark.io>
//
// For the full copyright and license information, please view the LICENSE
// file that was distributed with this source code.
//

import Foundation

class ArkSerializer {

    static func serialize(transaction: ArkTransaction) -> String {
        var bytes = [UInt8]()
        bytes.append(0xff)
        bytes.append(transaction.version > 0 ? transaction.version : 0x01)
        bytes.append(transaction.network > 0 ? transaction.network : ArkNetwork.shared.get().version())
        bytes.append(UInt8.init(transaction.type.rawValue))
        bytes.append(contentsOf: pack(transaction.timestamp))
        bytes.append(contentsOf: [UInt8](Data.init(hex: transaction.senderPublicKey)!))
        bytes.append(contentsOf: pack(transaction.fee))

        serializeVendorField(transaction: transaction, &bytes)
        serializeType(transaction: transaction, &bytes)
        serializeSignatures(transaction: transaction, &bytes)

        return String(format: "%02X", bytes)
    }

    private static func serializeVendorField(transaction: ArkTransaction, _ bytes: inout [UInt8]) {
        if let vendorField = transaction.vendorField {
            if vendorField.count > 0 {
                let length = vendorField.count
                bytes.append(contentsOf: pack(length))
            }
        } else if let vendorFieldHex = transaction.vendorFieldHex {
            if vendorFieldHex.count > 0 {
                let length = vendorFieldHex.count / 2
                bytes.append(contentsOf: pack(length))
                bytes.append(contentsOf: [UInt8](Data.init(hex: vendorFieldHex)!))
            }
        } else {
            bytes.append(0x00)
        }
    }

    private static func serializeType(transaction: ArkTransaction, _ bytes: inout [UInt8]) {
        switch transaction.type {
        case .delegateRegistration:
            serializeDelegateRegistration(transaction: transaction, &bytes)
        case .delegateResignation:
            serializeDelegateResignation(transaction: transaction, &bytes)
        case .ipfs:
            serializeIpfs(transaction: transaction, &bytes)
        case .multiPayment:
            serializeMultiPayment(transaction: transaction, &bytes)
        case .multiSignatureRegistration:
            serializeMultiSignatureRegistration(transaction: transaction, &bytes)
        case .secondSignatureRegistration:
            serializeSecondSignatureRegistration(transaction: transaction, &bytes)
        case .timelockTransfer:
            serializeTimelockTransfer(transaction: transaction, &bytes)
        case .transfer:
            serializeType(transaction: transaction, &bytes)
        case .vote:
            serializeVote(transaction: transaction, &bytes)
        }
    }

    private static func serializeSignatures(transaction: ArkTransaction, _ bytes: inout [UInt8]) {

    }

    // MARK: - Type serializers
    private static func serializeDelegateRegistration(transaction: ArkTransaction, _ bytes: inout [UInt8]) {
        let delegate = transaction.asset["delegate"] as! [String: String]
        let username = delegate["username"]!
        bytes.append(contentsOf: pack(username.count))
        bytes.append(contentsOf: [UInt8](username.data(using: .utf8)!))
    }

    private static func serializeDelegateResignation(transaction: ArkTransaction, _ bytes: inout [UInt8]) {

    }

    private static func serializeIpfs(transaction: ArkTransaction, _ bytes: inout [UInt8]) {

    }

    private static func serializeMultiPayment(transaction: ArkTransaction, _ bytes: inout [UInt8]) {

    }

    private static func serializeMultiSignatureRegistration(transaction: ArkTransaction, _ bytes: inout [UInt8]) {

    }

    private static func serializeSecondSignatureRegistration(transaction: ArkTransaction, _ bytes: inout [UInt8]) {
        let signature = transaction.asset["signature"] as! [String: String]
        bytes.append(contentsOf: [UInt8](Data.init(hex: signature["publicKey"]!)!))
    }

    private static func serializeTimelockTransfer(transaction: ArkTransaction, _ bytes: inout [UInt8]) {

    }

    private static func serializeTransfer(transaction: ArkTransaction, _ bytes: inout [UInt8]) {
        bytes.append(contentsOf: pack(transaction.amount))
        bytes.append(contentsOf: pack(transaction.expiration))
        let recipientId = base58CheckDecode(transaction.recipientId!)
        bytes.append(contentsOf: recipientId!)
    }

    private static func serializeVote(transaction: ArkTransaction, _ bytes: inout [UInt8]) {

    }
}
