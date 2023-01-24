import 'package:networkd/networkd.dart';

void main() async {
  final client = NetworkdManager();
  await client.connect();
  print(client.onlineState);
  await client.close();
}
