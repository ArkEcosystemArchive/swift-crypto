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

class TransferSerializerTests: XCTestCase {
    
    func testSerializeTransfer() {
        let json = readJson(file: "transfer_passphrase", type: type(of: self))
        let serialized = json["serialized"] as! String
        let transaction = ArkDeserializer.deserialize(serialized: serialized)
        
        XCTAssertEqual(serialized, ArkSerializer.serialize(transaction: transaction))
    }
    
    func testSerializeTransferSecondSig() {
        let json = readJson(file: "transfer_second-passphrase", type: type(of: self))
        let serialized = json["serialized"] as! String
        let transaction = ArkDeserializer.deserialize(serialized: serialized)
        
        XCTAssertEqual(serialized, ArkSerializer.serialize(transaction: transaction))
    }
    
    func testSerializeTransferWithVendorField() {
        let json = readJson(file: "transfer_passphrase-with-vendor-field", type: type(of: self))
        let serialized = json["serialized"] as! String
        let transaction = ArkDeserializer.deserialize(serialized: serialized)
        
        XCTAssertEqual(serialized, ArkSerializer.serialize(transaction: transaction))
    }
    
    func testSerializeTransferWithVendorFieldSecondSig() {
        let json = readJson(file: "transfer_second-passphrase-with-vendor-field", type: type(of: self))
        let serialized = json["serialized"] as! String
        let transaction = ArkDeserializer.deserialize(serialized: serialized)
        
        XCTAssertEqual(serialized, ArkSerializer.serialize(transaction: transaction))
    }
    
    func testSerializeTransferWithVendorFieldHex() {
        let json = readJson(file: "transfer_passphrase-with-vendor-field-hex", type: type(of: self))
        let serialized = json["serialized"] as! String
        let transaction = ArkDeserializer.deserialize(serialized: serialized)
        
        XCTAssertEqual(serialized, ArkSerializer.serialize(transaction: transaction))
    }
    
    func testSerializeTransferWithVendorFieldHexSecondSig() {
        let json = readJson(file: "transfer_second-passphrase-with-vendor-field-hex", type: type(of: self))
        let serialized = json["serialized"] as! String
        let transaction = ArkDeserializer.deserialize(serialized: serialized)

        XCTAssertEqual(serialized, ArkSerializer.serialize(transaction: transaction))
    }
}
