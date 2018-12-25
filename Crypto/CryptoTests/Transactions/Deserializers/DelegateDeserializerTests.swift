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

class DelegateDeserializerTests: XCTestCase {

    func testDeserializeDelegateRegistration() {
        let json = readJson(file: "del_reg_passphrase", type: type(of: self))
        let serialized = json["serialized"] as! String
        let data = json["data"] as! [String: Any]
        let transaction = ArkDeserializer.deserialize(serialized: serialized)

        XCTAssertEqual(transaction.version, 1)
        XCTAssertEqual(transaction.network, 30)
        XCTAssertEqual(transaction.type, TransactionType.delegateRegistration)
        XCTAssertEqual(transaction.id, data["id"] as! String)
        XCTAssertEqual(transaction.timestamp, data["timestamp"] as! UInt32)
        XCTAssertEqual(transaction.senderPublicKey, data["senderPublicKey"] as! String)
        XCTAssertEqual(transaction.fee, data["fee"] as! UInt64)
        XCTAssertEqual(transaction.signature, data["signature"] as! String)
        XCTAssertTrue(transaction.verify())

        let asset = data["asset"] as! [String: [String: Any]]
        let transactionAsset = transaction.asset as! [String: [String: Any]]
        XCTAssertEqual(transactionAsset["delegate"]!["username"]! as! String, asset["delegate"]!["username"]! as! String)
    }

    func testDeserializeDelegateRegistrationSecondSig() {
        let json = readJson(file: "del_reg_second-passphrase", type: type(of: self))
        let serialized = json["serialized"] as! String
        let data = json["data"] as! [String: Any]
        let transaction = ArkDeserializer.deserialize(serialized: serialized)

        XCTAssertEqual(transaction.version, 1)
        XCTAssertEqual(transaction.network, 30)
        XCTAssertEqual(transaction.type, TransactionType.delegateRegistration)
        XCTAssertEqual(transaction.id, data["id"] as! String)
        XCTAssertEqual(transaction.timestamp, data["timestamp"] as! UInt32)
        XCTAssertEqual(transaction.senderPublicKey, data["senderPublicKey"] as! String)
        XCTAssertEqual(transaction.fee, data["fee"] as! UInt64)
        XCTAssertEqual(transaction.signature, data["signature"] as! String)
        XCTAssertEqual(transaction.signSignature, data["signSignature"] as! String)
        XCTAssertTrue(transaction.verify())

        let asset = data["asset"] as! [String: [String: Any]]
        let transactionAsset = transaction.asset as! [String: [String: Any]]
        XCTAssertEqual(transactionAsset["delegate"]!["username"]! as! String, asset["delegate"]!["username"]! as! String)
    }
}
