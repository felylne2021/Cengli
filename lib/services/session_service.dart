import 'dart:convert';
import 'package:cengli/utils/signer.dart';
import 'package:cengli/services/push_protocol/push_restapi_dart.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:ethers/signers/wallet.dart' as ethers;

enum PrefKey {
  walletAddress("wallet-address"),
  commeth("cometh-connect-"),
  isLoggedIn("is_logged_in"),
  isFirstInstall("is_first_install"),
  encryptedPrivateKey("encrypted_private_key"),
  pin("pin"),
  username("username"),
  ;

  final String key;

  const PrefKey(this.key);
}

class SessionService {
  // Session
  static Future<bool> isLoggedIn() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(PrefKey.isLoggedIn.key) ?? false;
  }

  static void setLogin(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setBool(PrefKey.isLoggedIn.key, value);
  }

  static Future<bool> isFirstInstall() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(PrefKey.isFirstInstall.key) ?? true;
  }

  static void setFirstInstall(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setBool(PrefKey.isFirstInstall.key, value);
  }

  // Pin
  static void setPin(String value) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString(PrefKey.pin.key, value);
  }

  static Future<bool> isPinValid(String value) async {
    final prefs = await SharedPreferences.getInstance();
    final String pin = prefs.getString(PrefKey.pin.key) ?? "";
    return pin == value;
  }

  // Username
  static void setUsername(String value) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString(PrefKey.username.key, value);
  }

  static Future<String> getUsername() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(PrefKey.username.key) ?? "";
  }

  // Wallet
  static Future<String> getWalletAddress() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(PrefKey.walletAddress.key) ?? "";
  }

  static Future<String> getSignerAddress(String walletAddress) async {
    final prefs = await SharedPreferences.getInstance();
    final storedData = prefs.getString('${PrefKey.commeth.key}$walletAddress');
    return jsonDecode(storedData ?? "")["signerAddress"];
  }

  static void setEncryptedPrivateKey(String value) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString(PrefKey.encryptedPrivateKey.key, value);
  }

  static Future<String> getEncryptedPrivateKey() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(PrefKey.encryptedPrivateKey.key) ?? "";
  }

  static Future<String> getPgpPrivateKey() async {
    final walletAddress = await getWalletAddress();
    final encryptedPrivateKey = await getEncryptedPrivateKey();
    final signerAddress = await getSignerAddress(walletAddress);

    return await decryptPGPKey(
      encryptedPGPPrivateKey: encryptedPrivateKey,
      wallet: getWallet(
        signer: EthersSigner(
            ethersWallet: ethers.Wallet.fromPrivateKey(signerAddress),
            address: walletAddress),
      ),
    );
  }
}
