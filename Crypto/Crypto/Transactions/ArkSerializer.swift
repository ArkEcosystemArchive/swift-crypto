// 
// This file is part of Ark Swift Crypto.
//
// (c) Ark Ecosystem <info@ark.io>
//
// For the full copyright and license information, please view the LICENSE
// file that was distributed with this source code.
//

//swiftlint:disable force_cast

import Foundation

class ArkSerializer {

    static func serialize(transaction: ArkTransaction) -> String {
        var bytes = [UInt8]()
        bytes.append(0xff)
        bytes.append(transaction.version! > 0 ? transaction.version! : 0x01)
        bytes.append(transaction.network! > 0 ? transaction.network! : ArkNetwork.shared.get().version())
        bytes.append(UInt8.init(transaction.type!.rawValue))
        var transactionBytes = pack(transaction.timestamp)
        transactionBytes.removeLast() // Timestamp is 32bits (5 bytes), but only 4 bytes serialized
        bytes.append(contentsOf: transactionBytes)
        bytes.append(contentsOf: [UInt8](Data.init(hex: transaction.senderPublicKey!)!))
        var feeBytes = pack(transaction.fee)
        feeBytes.removeLast()
        bytes.append(contentsOf: feeBytes)

        serializeVendorField(transaction: transaction, &bytes)
        serializeType(transaction: transaction, &bytes)
        serializeSignatures(transaction: transaction, &bytes)

        return bytes.map { String(format: "%02x", $0) }.joined()
    }

    private static func serializeVendorField(transaction: ArkTransaction, _ bytes: inout [UInt8]) {
        if let vendorField = transaction.vendorField {
            let length = vendorField.count
            bytes.append(contentsOf: pack(length))
            bytes.append(contentsOf: pack(vendorField))
        } else if let vendorFieldHex = transaction.vendorFieldHex {
            let length = vendorFieldHex.count / 2
            bytes.append(contentsOf: pack(length))
            bytes.append(contentsOf: [UInt8](Data.init(hex: vendorFieldHex)!))
        } else {
            bytes.append(0x00)
        }
    }

    private static func serializeType(transaction: ArkTransaction, _ bytes: inout [UInt8]) {
        switch transaction.type! {
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
            serializeTransfer(transaction: transaction, &bytes)
        case .vote:
            serializeVote(transaction: transaction, &bytes)
        }
    }

    private static func serializeSignatures(transaction: ArkTransaction, _ bytes: inout [UInt8]) {
        if let signature = transaction.signature {
            bytes.append(contentsOf: [UInt8](Data.init(hex: signature)!))
        }

        if let secondSignature = transaction.secondSignature {
            bytes.append(contentsOf: [UInt8](Data.init(hex: secondSignature)!))
        } else if let signSignature = transaction.signSignature {
            bytes.append(contentsOf: [UInt8](Data.init(hex: signSignature)!))
        }

        if let signatures = transaction.signatures {
            if signatures.count > 0 {
                bytes.append(0xff)
                bytes.append(contentsOf: [UInt8](Data.init(hex: transaction.signatures!.joined())!))
            }
        }
    }

    // MARK: - Type serializers
    private static func serializeDelegateRegistration(transaction: ArkTransaction, _ bytes: inout [UInt8]) {
        let delegate = transaction.asset!["delegate"] as! [String: String]
        let username = delegate["username"]!
        bytes.append(contentsOf: pack(username.count))
        bytes.append(contentsOf: [UInt8](username.data(using: .utf8)!))
    }

    private static func serializeDelegateResignation(transaction: ArkTransaction, _ bytes: inout [UInt8]) {
        // TODO
    }

    private static func serializeIpfs(transaction: ArkTransaction, _ bytes: inout [UInt8]) {
        let ipfs = transaction.asset!["ipfs"] as! [String: String]
        let dag = ipfs["dag"]!
        bytes.append(contentsOf: pack(dag.count))
        bytes.append(contentsOf: [UInt8](Data.init(hex: dag)!))
    }

    private static func serializeMultiPayment(transaction: ArkTransaction, _ bytes: inout [UInt8]) {
        // TODO
    }

    private static func serializeMultiSignatureRegistration(transaction: ArkTransaction, _ bytes: inout [UInt8]) {
        
    }

    private static func serializeSecondSignatureRegistration(transaction: ArkTransaction, _ bytes: inout [UInt8]) {
        let signature = transaction.asset!["signature"] as! [String: String]
        bytes.append(contentsOf: [UInt8](Data.init(hex: signature["publicKey"]!)!))
    }

    private static func serializeTimelockTransfer(transaction: ArkTransaction, _ bytes: inout [UInt8]) {
        // TODO
    }

    private static func serializeTransfer(transaction: ArkTransaction, _ bytes: inout [UInt8]) {
        bytes.append(contentsOf: pack(transaction.amount))
        bytes.append(contentsOf: pack(transaction.expiration))
        let recipientId = base58CheckDecode(transaction.recipientId!)
        bytes.append(contentsOf: recipientId!)
    }

    private static func serializeVote(transaction: ArkTransaction, _ bytes: inout [UInt8]) {
        let votes = transaction.asset!["votes"] as! [String]
        print(votes)

        var voteBytes = [String]()

        for vote in votes {
            let prefix = vote.prefix(1) == "+" ? "01" : "00"
            let votePK = String(vote.suffix(vote.count - 1))
            voteBytes.append(String(format: "%@%@", prefix, votePK))
        }

        bytes.append(contentsOf: pack(UInt8(votes.count)))
        bytes.append(contentsOf: [UInt8](Data.init(hex: voteBytes.joined())!))
    }
}
