# Ark Crypto - Swift

<p align="center">
    <img src="./banner.png" />
</p>

> A simple Swift Cryptography Implementation for the Ark Blockchain.

[![Build Status](https://badgen.now.sh/travis/ArkEcosystem/swift-crypto)](https://travis-ci.org/ArkEcosystem/swift-crypto)
[![Codecov](https://badgen.now.sh/codecov/c/github/arkecosystem/swift-crypto)](https://codecov.io/gh/arkecosystem/swift-crypto)
[![Latest Version](https://badgen.now.sh/github/release/ArkEcosystem/swift-crypto)](https://github.com/ArkEcosystem/swift-crypto/releases)
[![License: MIT](https://badgen.now.sh/badge/license/MIT/green)](https://opensource.org/licenses/MIT)

## TO-DO

### AIP11 Serialization
- [x] Transfer
- [x] Second Signature Registration
- [x] Delegate Registration
- [x] Vote
- [x] Multi Signature Registration
- [ ] IPFS
- [ ] Timelock Transfer
- [ ] Multi Payment
- [ ] Delegate Resignation

### AIP11 Deserialization
- [x] Transfer
- [x] Second Signature Registration
- [x] Delegate Registration
- [x] Vote
- [x] Multi Signature Registration
- [ ] IPFS
- [ ] Timelock Transfer
- [ ] Multi Payment
- [ ] Delegate Resignation

### Transaction Signing
- [x] Transfer
- [x] Second Signature Registration
- [x] Delegate Registration
- [ ] Vote
- [x] Multi Signature Registration

### Transaction Verifying
- [ ] Transfer
- [ ] Second Signature Registration
- [ ] Delegate Registration
- [ ] Vote
- [ ] Multi Signature Registration

### Transaction
- [x] getId
- [x] sign
- [x] secondSign
- [ ] verify
- [ ] secondverify
- [x] parseSignatures
- [x] serialize
- [x] deserialize
- [x] toBytes
- [x] toArray
- [ ] toJson

### Message
- [x] sign
- [x] verify
- [x] toArray
- [x] toJson

### Address
- [x] fromPassphrase
- [x] fromPublicKey
- [x] fromPrivateKey
- [x] validate

### Private Key
- [x] fromPassphrase
- [x] fromHex

### Public Key
- [x] fromPassphrase
- [x] fromHex

### WIF
- [x] fromPassphrase

### Configuration
- [x] getNetwork
- [x] setNetwork
- [x] getFee
- [x] setFee

### Slot
- [x] time
- [x] epoch

### Networks (Mainnet, Devnet & Testnet)
- [x] epoch
- [x] version
- [x] nethash
- [x] wif

## Installation

TO BE MOVED TO DOCS:

Installing the dependency (BitcointKit) of this SDK will require a lot of time. So after running `pod install` it might take up to 10 minutes to install the BitcoinKit dependency. This is due to the crypto dependencies it relies on, like scpk256, that are compiled from scratch during the install. Don't be alarmed when it looks like the installation got stuck, it's just the underlying dependencies taking their time.

## Documentation

You can find installation instructions and detailed instructions on how to use this package at the [dedicated documentation site](https://docs.ark.io/api/sdk/cryptography/swift.html).

## Security

If you discover a security vulnerability within this package, please send an e-mail to security@ark.io. All security vulnerabilities will be promptly addressed.

## Credits

- [ItsANameToo](https://github.com/ItsANameToo)
- [All Contributors](../../contributors)

## License

[MIT](LICENSE) © [ArkEcosystem](https://ark.io)
