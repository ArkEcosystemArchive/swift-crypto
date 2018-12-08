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

class SecondSignatureDeserializerTests: XCTestCase {
    
    func testSecondSignatureRegistration() {
        let json = readJson(file: "ss_second-passphrase", type: type(of: self))
        let serialized = json["serialized"] as! String
        let data = json["data"] as! [String: Any]
        let transaction = ArkDeserializer.deserialize(serialized: serialized)
        
        XCTAssertEqual(transaction.version, 1)
        XCTAssertEqual(transaction.network, 30)
        XCTAssertEqual(transaction.type, TransactionType.secondSignatureRegistration)
        XCTAssertEqual(transaction.id, data["id"] as! String)
        XCTAssertEqual(transaction.timestamp, data["timestamp"] as! UInt32)
        XCTAssertEqual(transaction.senderPublicKey, data["senderPublicKey"] as! String)
        XCTAssertEqual(transaction.fee, data["fee"] as! UInt64)
        XCTAssertEqual(transaction.signature, data["signature"] as! String)
        
        let asset = data["asset"] as! [String: [String: Any]]
        let transactionAsset = transaction.asset as! [String: [String: Any]]
        XCTAssertEqual(transactionAsset["signature"]!["publicKey"]! as! String, asset["signature"]!["publicKey"]! as! String)
    }
}
