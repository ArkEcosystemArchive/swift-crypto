// 
// This file is part of Ark Swift Crypto.
//
// (c) Ark Ecosystem <info@ark.io>
//
// For the full copyright and license information, please view the LICENSE
// file that was distributed with this source code.
//

import Foundation

class ArkDeserializer {

    static func deserialize(serialized: String) {
        var bytes = [UInt8](Data.init(hex: serialized)!)

        var offset = deserializeHeader(&bytes)
        offset = deserializeType(type: TransactionType.vote, &bytes, offset: offset)
        parseSignatures(&bytes, offset: offset)

        // TODO: check some v1 stuff
    }

    private static func deserializeHeader(_ bytes: inout [UInt8]) -> Int {
        // Default info
        let header = bytes[0]
        print(header)
        let version = bytes[1]
        print(version)
        let network = bytes[2]
        print(network)
        let type = bytes[3]
        print(type)
        let timestamp: Int32 = Data(bytes[4..<8]).withUnsafeBytes{$0.pointee}
        print(timestamp)

        // Sender public key
        let publicKeyBytes = bytes[8..<41]
        let publicKey = publicKeyBytes.map{String(format: "%02x", $0)}.joined()
        print(publicKey)

        // Fee
        let fee: UInt64 = Data(bytes[41..<49]).withUnsafeBytes {$0.pointee}
        print(fee)

        // Vendor field
        let vendorFieldLength = bytes[50]
        if vendorFieldLength > 0 {
            let endByte: Int = 50 + Int(vendorFieldLength)
            let vendorField = bytes[50..<endByte].map{String(format: "%02x", $0)}.joined()
        }

        // Byte index up to which we read
        return 50 + Int(vendorFieldLength) - 1
    }

    private static func deserializeType(type: TransactionType, _ bytes: inout [UInt8], offset: Int) -> Int {
        switch type {
        case .delegateRegistration:
            deserializeDelegateRegistration(&bytes, offset: offset)
        case .delegateResignation:
            deserializeDelegateResignation(&bytes, offset: offset)
        case .ipfs:
            deserializeIpfs(&bytes, offset: offset)
        case .multiPayment:
            deserializeMultiPayment(&bytes, offset: offset)
        case .multiSignatureRegistration:
            deserializeMultiSignatureRegistration(&bytes, offset: offset)
        case .secondSignatureRegistration:
            deserializeSecondSignatureRegistration(&bytes, offset: offset)
        case .timelockTransfer:
            deserializeTimelockTransfer(&bytes, offset: offset)
        case .transfer:
            deserializeTransfer(&bytes, offset: offset)
        case .vote:
            deserializeVote(&bytes, offset: offset)
        }
        return 0
    }

    private static func parseSignatures(_ bytes: inout [UInt8], offset: Int) {

    }

    // MARK: - Type deserializers
    private static func deserializeDelegateRegistration(_ bytes: inout [UInt8], offset: Int) -> Int {
        return 0
    }

    private static func deserializeDelegateResignation(_ bytes: inout [UInt8], offset: Int) -> Int {
        return 0
    }

    private static func deserializeIpfs(_ bytes: inout [UInt8], offset: Int) -> Int {
        return 0
    }

    private static func deserializeMultiPayment(_ bytes: inout [UInt8], offset: Int) -> Int {
        return 0
    }

    private static func deserializeMultiSignatureRegistration(_ bytes: inout [UInt8], offset: Int) -> Int {
        return 0
    }

    private static func deserializeSecondSignatureRegistration(_ bytes: inout [UInt8], offset: Int) -> Int {
        return 0
    }

    private static func deserializeTimelockTransfer(_ bytes: inout [UInt8], offset: Int) -> Int {
        return 0
    }

    private static func deserializeTransfer(_ bytes: inout [UInt8], offset: Int) -> Int {
        return 0
    }

    private static func deserializeVote(_ bytes: inout [UInt8], offset: Int) -> Int {
        let voteLength = Int(bytes[offset])
        print(voteLength)

        var votes = [String]()
        for idx in 0..<voteLength {
            let voteType = bytes[(offset + 1) + idx * 34]
            print(voteType)

            let startIndex = Int((offset + 2) + idx * 34)
            let voteByteLength = 32 // 33 - voteType (1)

            let voteBytes = bytes[startIndex..<(startIndex + voteByteLength)]
            var vote = voteBytes.map {String(format: "%02x", $0)}.joined()

            if voteType == 1 {
                vote = "+" + vote
            } else {
                vote = "-" + vote
            }
            votes.append(vote)
            print(vote)
        }
        return offset + voteLength * 34
    }
}