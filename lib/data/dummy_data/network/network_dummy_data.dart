import 'package:cengli/values/assets.dart';
import 'package:cengli/values/values.dart';
import 'package:kinetix/kinetix.dart';

class NetworkChain {
  final String image;
  final String title;

  NetworkChain(this.image, this.title);
}

List<NetworkChain> chains = [
  NetworkChain(IC_POLYGON, 'Polygon'),
  NetworkChain(IC_ETHEREUM, 'Ethereum')
];

List<KxSelectedListItem> walletItems = [
  KxSelectedListItem('Main Wallet', false),
  KxSelectedListItem('Secondary Wallet', false)
];
