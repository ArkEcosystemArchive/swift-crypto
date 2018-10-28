// 
// This file is part of Ark Swift Crypto.
//
// (c) Ark Ecosystem <info@ark.io>
//
// For the full copyright and license information, please view the LICENSE
// file that was distributed with this source code.
//

// swiftlint:disable force_cast

import XCTest
@testable import Crypto

class VoteTests: XCTestCase {

    func testDeserializeVote() {
        let json = readJson(file: "vote_passphrase", type: type(of: self))
        let serialized = json["serialized"] as! String
        let data = json["data"] as! [String: Any]
        let transaction = ArkDeserializer.deserialize(serialized: serialized)

        XCTAssertEqual(transaction.version, 1)
        XCTAssertEqual(transaction.network, 30)
        XCTAssertEqual(transaction.type, TransactionType.vote)
        XCTAssertEqual(transaction.timestamp, data["timestamp"] as! UInt32)
        XCTAssertEqual(transaction.senderPublicKey, data["senderPublicKey"] as! String)
        XCTAssertEqual(transaction.fee, data["fee"] as! UInt64)
        XCTAssertEqual(transaction.signature, data["signature"] as! String)
        
        let asset = data["asset"] as! [String: [String]]
        let transactionAsset = transaction.asset as! [String: [String]]
        XCTAssertEqual(transactionAsset["votes"]![0], asset["votes"]![0])
    }
    
    func testDeserializeVoteSecondSig() {
        let json = readJson(file: "vote_second-passphrase", type: type(of: self))
        let serialized = json["serialized"] as! String
        let data = json["data"] as! [String: Any]
        let transaction = ArkDeserializer.deserialize(serialized: serialized)
        
        XCTAssertEqual(transaction.version, 1)
        XCTAssertEqual(transaction.network, 30)
        XCTAssertEqual(transaction.type, TransactionType.vote)
        XCTAssertEqual(transaction.timestamp, data["timestamp"] as! UInt32)
        XCTAssertEqual(transaction.senderPublicKey, data["senderPublicKey"] as! String)
        XCTAssertEqual(transaction.fee, data["fee"] as! UInt64)
        XCTAssertEqual(transaction.signature, data["signature"] as! String)
        XCTAssertEqual(transaction.signSignature, data["signSignature"] as! String)
        
        let asset = data["asset"] as! [String: [String]]
        let transactionAsset = transaction.asset as! [String: [String]]
        XCTAssertEqual(transactionAsset["votes"]![0], asset["votes"]![0])
    }
}
