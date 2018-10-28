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

class TransferDeserializerTests: XCTestCase {
    
    func testDeserializeTransfer() {
        let json = readJson(file: "transfer_passphrase", type: type(of: self))
        let serialized = json["serialized"] as! String
        let data = json["data"] as! [String: Any]
        let transaction = ArkDeserializer.deserialize(serialized: serialized)
        
        XCTAssertEqual(transaction.version, 1)
        XCTAssertEqual(transaction.network, 30)
        XCTAssertEqual(transaction.type, TransactionType.transfer)
        XCTAssertEqual(transaction.timestamp, data["timestamp"] as! UInt32)
        XCTAssertEqual(transaction.senderPublicKey, data["senderPublicKey"] as! String)
        XCTAssertEqual(transaction.fee, data["fee"] as! UInt64)
        XCTAssertEqual(transaction.amount, data["amount"] as! UInt64)
        XCTAssertEqual(transaction.recipientId, data["recipientId"] as! String)
        XCTAssertEqual(transaction.signature, data["signature"] as! String)
    }
    
    func testDeserializeTransferSecondSig() {
        let json = readJson(file: "transfer_second-passphrase", type: type(of: self))
        let serialized = json["serialized"] as! String
        let data = json["data"] as! [String: Any]
        let transaction = ArkDeserializer.deserialize(serialized: serialized)
        
        XCTAssertEqual(transaction.version, 1)
        XCTAssertEqual(transaction.network, 30)
        XCTAssertEqual(transaction.type, TransactionType.transfer)
        XCTAssertEqual(transaction.timestamp, data["timestamp"] as! UInt32)
        XCTAssertEqual(transaction.senderPublicKey, data["senderPublicKey"] as! String)
        XCTAssertEqual(transaction.fee, data["fee"] as! UInt64)
        XCTAssertEqual(transaction.amount, data["amount"] as! UInt64)
        XCTAssertEqual(transaction.recipientId, data["recipientId"] as! String)
        XCTAssertEqual(transaction.signature, data["signature"] as! String)
        XCTAssertEqual(transaction.signSignature, data["signSignature"] as! String)
    }
}
