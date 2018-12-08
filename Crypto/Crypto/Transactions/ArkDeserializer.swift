// 
// This file is part of Ark Swift Crypto.
//
// (c) Ark Ecosystem <info@ark.io>
//
// For the full copyright and license information, please view the LICENSE
// file that was distributed with this source code.
//

// swiftlint:disable opening_brace

import Foundation

class ArkDeserializer {

    static func deserialize(serialized: String) -> ArkTransaction {
        var bytes = [UInt8](Data.init(hex: serialized)!)
        var transaction = ArkTransaction()

        var offset = deserializeHeader(&transaction, &bytes)
        offset = deserializeType(&transaction, type: transaction.type!, &bytes, offset: offset)
        parseSignatures(&transaction, &bytes, offset: offset)

        // Handle v1 stuff
        if transaction.version == 1 {
            handleVersionOne(&transaction)
        }
        
        return transaction
    }

    private static func deserializeHeader(_ transaction: inout ArkTransaction, _ bytes: inout [UInt8]) -> Int {
        // Default info
        transaction.header = bytes[0]
        transaction.version = bytes[1]
        transaction.network = bytes[2]
        transaction.type = TransactionType(rawValue: Int(bytes[3]))
        transaction.timestamp = Data(bytes[4..<8]).withUnsafeBytes{$0.pointee}

        // Sender public key
        let publicKeyBytes = bytes[8..<41]
        transaction.senderPublicKey = publicKeyBytes.map{String(format: "%02x", $0)}.joined()

        // Fee
        transaction.fee = Data(bytes[41..<49]).withUnsafeBytes {$0.pointee}

        // Vendor field
        let vendorFieldLength = bytes[49]
        if vendorFieldLength > 0 {
            let endByte: Int = 50 + Int(vendorFieldLength)
            transaction.vendorFieldHex = bytes[50..<endByte].map{String(format: "%02x", $0)}.joined()
        }

        // Byte index up to which we read
        return 50 + Int(vendorFieldLength)
    }

    private static func deserializeType(_ transaction: inout ArkTransaction, type: TransactionType, _ bytes: inout [UInt8], offset: Int) -> Int {
        switch type {
        case .delegateRegistration:
            return deserializeDelegateRegistration(&transaction, &bytes, offset: offset)
        case .delegateResignation:
            return deserializeDelegateResignation(&transaction, &bytes, offset: offset)
        case .ipfs:
            return deserializeIpfs(&transaction, &bytes, offset: offset)
        case .multiPayment:
            return deserializeMultiPayment(&transaction, &bytes, offset: offset)
        case .multiSignatureRegistration:
            return deserializeMultiSignatureRegistration(&transaction, &bytes, offset: offset)
        case .secondSignatureRegistration:
            return deserializeSecondSignatureRegistration(&transaction, &bytes, offset: offset)
        case .timelockTransfer:
            return deserializeTimelockTransfer(&transaction, &bytes, offset: offset)
        case .transfer:
            return deserializeTransfer(&transaction, &bytes, offset: offset)
        case .vote:
            return deserializeVote(&transaction, &bytes, offset: offset)
        }
    }

    private static func parseSignatures(_ transaction: inout ArkTransaction, _ bytes: inout [UInt8], offset: Int) {
        let signature = bytes[offset..<bytes.count].map{String(format: "%02x", $0)}.joined()
        var multiSigOffset = 0
        if signature.count > 0 {
            // Signature
            let start = signature.index(signature.startIndex, offsetBy: 2)
            let end = signature.index(signature.startIndex, offsetBy: 4)
            let signatureLength = Int(signature[start..<end], radix: 16)! + 2

            transaction.signature = bytes[offset..<offset + signatureLength].map{String(format: "%02x", $0)}.joined()
            multiSigOffset += offset + signatureLength
            
            // Second Signature
            let secondSignatureOffset = offset + signatureLength
            let secondSignature = bytes[secondSignatureOffset..<bytes.count].map{String(format: "%02x", $0)}.joined()
            
            if secondSignature.count > 0 && !secondSignature.starts(with: "ff") {
                let start = secondSignature.index(secondSignature.startIndex, offsetBy: 2)
                let end = secondSignature.index(secondSignature.startIndex, offsetBy: 4)
                let secondSignatureLength = Int(secondSignature[start..<end], radix: 16)! + 2
                
                transaction.secondSignature = bytes[secondSignatureOffset..<secondSignatureOffset + secondSignatureLength].map{String(format: "%02x", $0)}.joined()
                multiSigOffset += secondSignatureLength
            }
            
            var multiSigs = bytes[multiSigOffset..<bytes.count].map{String(format: "%02x", $0)}.joined()
            print(multiSigs)
            if multiSigs.count > 0 && multiSigs.starts(with: "ff") {
                transaction.signatures = [String]()
                var internalOffset = 0 // To keep track of the offset between the different multisigs
                multiSigOffset += 1 // Remove initial "ff" byte from the String
                multiSigs.removeFirst(2) // Remove initial "ff" byte from the String
                while multiSigs.count - 1 > internalOffset {
                    let start = multiSigs.index(multiSigs.startIndex, offsetBy: 2 + internalOffset)
                    let end = multiSigs.index(multiSigs.startIndex, offsetBy: 4 + internalOffset)
                    let multiSigLength = Int(multiSigs[start..<end], radix: 16)! + 2
                    
                    if (multiSigLength > 0) {
                        print(multiSigLength)
                        let currentOffset = multiSigOffset + (internalOffset / 2)
                        print(bytes[currentOffset..<currentOffset + multiSigLength].map{String(format: "%02x", $0)}.joined())
                        transaction.signatures!.append(bytes[currentOffset..<currentOffset + multiSigLength].map{String(format: "%02x", $0)}.joined())
                    } else {
                        break;
                    }
                    internalOffset += multiSigLength * 2
                }
            }
            
        }
    }

    // MARK: - Type deserializers
    private static func deserializeDelegateRegistration(_ transaction: inout ArkTransaction, _ bytes: inout [UInt8], offset: Int) -> Int {
        let usernameLength = Int(bytes[offset])
        transaction.asset = [
            "delegate": [
                "username": hexToString(bytes[offset + 1..<offset + 1 + usernameLength].map{String(format: "%02x", $0)}.joined())
            ]
        ]

        return offset + 1 + usernameLength
    }

    private static func deserializeDelegateResignation(_ transaction: inout ArkTransaction, _ bytes: inout [UInt8], offset: Int) -> Int {
        // TODO
        return 0
    }

    private static func deserializeIpfs(_ transaction: inout ArkTransaction, _ bytes: inout [UInt8], offset: Int) -> Int {
        // TODO
        return 0
    }

    private static func deserializeMultiPayment(_ transaction: inout ArkTransaction, _ bytes: inout [UInt8], offset: Int) -> Int {
        // TODO
        return 0
    }

    private static func deserializeMultiSignatureRegistration(_ transaction: inout ArkTransaction, _ bytes: inout [UInt8], offset: Int) -> Int {
        let min = bytes[offset]
        let count = Int(bytes[offset + 1])
        let lifetime = bytes[offset + 2]

        var keys = [String]()
        let idx = offset + 3
        for keyIndex in 0..<count {
            let startIndex = idx + keyIndex * 33
            let key = bytes[startIndex..<startIndex + 33].map{String(format: "%02x", $0)}.joined()
            keys.append(key)
        }

        transaction.asset = [
            "multisignature": [
                "min": min,
                "keysgroup": keys,
                "lifetime": lifetime
            ]
        ]

        return offset + 3 + count * 33
    }

    private static func deserializeSecondSignatureRegistration(_ transaction: inout ArkTransaction, _ bytes: inout [UInt8], offset: Int) -> Int {
        transaction.asset = [
            "signature": [
                "publicKey": bytes[offset..<offset+33].map{String(format: "%02x", $0)}.joined()
            ]
        ]

        return offset + 33
    }

    private static func deserializeTimelockTransfer(_ transaction: inout ArkTransaction, _ bytes: inout [UInt8], offset: Int) -> Int {
        // TODO
        return 0
    }

    private static func deserializeTransfer(_ transaction: inout ArkTransaction, _ bytes: inout [UInt8], offset: Int) -> Int {
        var idx = offset
        transaction.amount = Data(bytes[idx..<idx+8]).withUnsafeBytes{$0.pointee}
        idx += 8
        transaction.expiration = Data(bytes[idx..<idx+4]).withUnsafeBytes{$0.pointee}
        idx += 4
        let recipientBytes = Array(bytes[idx..<idx+21])
        transaction.recipientId = base58CheckEncode(recipientBytes)

        return idx + 21
    }

    private static func deserializeVote(_ transaction: inout ArkTransaction, _ bytes: inout [UInt8], offset: Int) -> Int {
        let voteLength = Int(bytes[offset])

        var votes = [String]()
        for idx in 0..<voteLength {
            let voteType = bytes[(offset + 1) + idx * 34]

            let startIndex = Int((offset + 2) + idx * 34)
            let voteByteLength = 33 // 34 - voteType (1)

            let voteBytes = bytes[startIndex..<(startIndex + voteByteLength)]
            var vote = voteBytes.map {String(format: "%02x", $0)}.joined()

            if voteType == 1 {
                vote = "+" + vote
            } else {
                vote = "-" + vote
            }
            votes.append(vote)
        }
        transaction.asset = ["votes": votes]

        return offset + 1 + voteLength * 34
    }
    
    // MARK: - v1
    private static func handleVersionOne(_ transaction: inout ArkTransaction) {
        if let secondSig = transaction.secondSignature {
            transaction.signSignature = secondSig
        }
        
        if let type = transaction.type {
            if type == .vote {
                let publicKey = ArkPublicKey.from(hex: transaction.senderPublicKey!).description
                transaction.recipientId = ArkAddress.from(publicKey: publicKey)
            } else if type == .multiSignatureRegistration {
                var asset = transaction.asset as! [String: [String: Any]]
                var keysgroup = asset["multisignature"]!["keysgroup"] as! [String]
                for idx in 0..<keysgroup.count {
                    keysgroup[idx] = "+" + keysgroup[idx]
                }
                asset["multisignature"]!["keysgroup"] = keysgroup
                transaction.asset = asset
            }
        }
        
        if let vendorFieldHex = transaction.vendorFieldHex {
            transaction.vendorField = hexToString(vendorFieldHex)
        }
        
        if transaction.id == nil {
            transaction.id = transaction.getId()
        }
        
        if let type = transaction.type {
            if type == .secondSignatureRegistration {
                let publicKey = ArkPublicKey.from(hex: transaction.senderPublicKey!).description
                transaction.recipientId = ArkAddress.from(publicKey: publicKey)
            } else if type == .multiSignatureRegistration {
                let publicKey = ArkPublicKey.from(hex: transaction.senderPublicKey!).description
                transaction.recipientId = ArkAddress.from(publicKey: publicKey)
            }
        }
    }
}
