// SettingsModel.swift is a part of Banter project
//
// Created by Andrei Chenchik (andrei@chenchik.me), 21/2/25
// Copyright © 2025 Andrei Chenchik, Inc. All rights reserved.
// Unauthorized copying of this file, via any medium is strictly prohibited
// Proprietary and confidential
//

import Sharing
import SwiftUI
import Web3

@Observable
final class SettingsModel: ObservableObject {
  @ObservationIgnored @Shared(.userSettings) var settings
  @ObservationIgnored @Shared(.walletKeyHex) var walletKeyHex
    @ObservationIgnored @Shared(.userAdressKeyHex) var userAdressKeyHex

  var isReadyToChat: Bool {
    !settings.web3.rpcWSURL.isEmpty
      && !settings.web3.contractAddress.isEmpty
      && !walletKeyHex.isEmpty
      && !settings.web3.chainId.isEmpty
      && Int(settings.web3.chainId) != nil
  }

  var walletAddress: String? {
      guard let key = try? EthereumPrivateKey(hexPrivateKey: walletKeyHex) else {
          return nil
      }
    $userAdressKeyHex.withLock { $0 = key.hex() }
    return key.address.hex(eip55: true)
  }

  func copyWalletAddressTapped() {
    UIPasteboard.general.string = walletAddress
      print(walletAddress)
  }

  func generateNewAddressTapped() {
    guard let key = try? EthereumPrivateKey() else { return }
    $walletKeyHex.withLock { $0 = key.hex() }
    $settings.withLock { $0.web3.userAddress = key.address.hex(eip55: true) }
  }
    
}
