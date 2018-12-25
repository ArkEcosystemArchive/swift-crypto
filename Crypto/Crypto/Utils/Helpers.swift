//
// This file is part of Ark Swift Crypto.
//
// (c) Ark Ecosystem <info@ark.io>
//
// For the full copyright and license information, please view the LICENSE
// file that was distributed with this source code.
//

import Foundation
import BitcoinKit

func base58CheckEncode(_ bytes: [UInt8]) -> String {
    let checksum = Crypto.sha256sha256(Data.init(bytes: bytes)).prefix(4)
    var checkedBytes = bytes
    checkedBytes.append(contentsOf: checksum)

    return Base58.encode(Data.init(bytes: checkedBytes))
}

func base58CheckDecode(_ string: String) -> [UInt8]? {
    let checkedBytes = Base58.decode(string)

    if var checkedBytes = checkedBytes {
        guard checkedBytes.count >= 0 else {
            return nil
        }

        // TODO: Data.suffix(4)
        let checksum = [UInt8](checkedBytes[checkedBytes.count-4..<checkedBytes.count])
        let bytes = [UInt8](checkedBytes[0..<checkedBytes.count-4])

        let calculatedChecksum = [UInt8](Crypto.sha256sha256(Data.init(bytes: bytes)).prefix(4))
        if checksum != calculatedChecksum {
            return nil
        }
        return bytes
    }
    return nil
}

func unpack<T: Any>(_ bytes: [UInt8], to: T.Type) -> T {
    return bytes.withUnsafeBufferPointer {
        return $0.baseAddress!.withMemoryRebound(to: T.self, capacity: 1) {
            $0.pointee
        }
    }
}

func pack<T: Any>(_ value: T) -> [UInt8] {
    var value = value
    return withUnsafePointer(to: &value) {
        Array(UnsafeBufferPointer(start: $0.withMemoryRebound(to: UInt8.self, capacity: 1) {$0}, count:
            MemoryLayout<T>.size))
    }
}

func hexToString(_ hex: String) -> String {
    // Based on https://stackoverflow.com/a/46413632, room for improvement
    var chars = [Character]()

    for c in hex.characters {
        chars.append(c)
    }

    let numbers = stride(from: 0, to: chars.count, by: 2).map {
        strtoul(String(chars[$0 ..< $0+2]), nil, 16)
    }

    var final = ""
    var i = 0

    while i < numbers.count {
        final.append(Character(UnicodeScalar(Int(numbers[i]))!))
        i += 1
    }

    return final
}
