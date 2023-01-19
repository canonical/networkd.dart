import 'package:dbus/dbus.dart';
import 'package:mocktail/mocktail.dart';
import 'package:networkd/networkd.dart';
import 'package:test/test.dart';

class MockDBusClient extends Mock implements DBusClient {}

class MockDBusRemoteObject extends Mock implements DBusRemoteObject {}

void main() {
  test('invoke void methods', () async {
    final object = createMockRemoteObject();
    final link = NetworkdLink(object);

    await link.setNTP(['0.ubuntu.pool.ntp.org, 1.ubuntu.pool.ntp.org']);
    verifyVoidMethodCall(object, 'SetNTP', [
      DBusArray.string(['0.ubuntu.pool.ntp.org, 1.ubuntu.pool.ntp.org'])
    ]);

    await link.setDefaultRoute(true);
    verifyVoidMethodCall(object, 'SetDefaultRoute', [DBusBoolean(true)]);

    await link.setLLMNR('modeA');
    verifyVoidMethodCall(object, 'SetLLMNR', [DBusString('modeA')]);

    await link.setMulticastDNS('modeB');
    verifyVoidMethodCall(object, 'SetMulticastDNS', [DBusString('modeB')]);

    await link.setDNSOverTLS('modeC');
    verifyVoidMethodCall(object, 'SetDNSOverTLS', [DBusString('modeC')]);

    await link.setDNSSEC('modeD');
    verifyVoidMethodCall(object, 'SetDNSSEC', [DBusString('modeD')]);

    await link.setDNSSECNegativeTrustAnchors(['name1', 'name2']);
    verifyVoidMethodCall(object, 'SetDNSSECNegativeTrustAnchors', [
      DBusArray.string(['name1', 'name2'])
    ]);

    await link.revertNTP();
    verifyVoidMethodCall(object, 'RevertNTP', []);

    await link.revertDNS();
    verifyVoidMethodCall(object, 'RevertDNS', []);

    await link.renew();
    verifyVoidMethodCall(object, 'Renew', []);

    await link.forceRenew();
    verifyVoidMethodCall(object, 'ForceRenew', []);

    await link.reconfigure();
    verifyVoidMethodCall(object, 'Reconfigure', []);
  });
}

void verifyVoidMethodCall(MockDBusRemoteObject object, String methodName,
        Iterable<DBusValue> values) =>
    verify(() => object.callMethod(
        NetworkdLink.interfaceName, methodName, values,
        replySignature: DBusSignature(''))).called(1);

MockDBusRemoteObject createMockRemoteObject({
  Map<String, DBusValue>? properties,
}) {
  final object = MockDBusRemoteObject();

  when(() => object.propertiesChanged).thenAnswer((_) => const Stream.empty());
  when(() => object.getAllProperties(NetworkdLink.interfaceName))
      .thenAnswer((_) async => properties ?? {});
  const voidMethods = [
    'SetNTP',
    'SetDefaultRoute',
    'SetLLMNR',
    'SetMulticastDNS',
    'SetDNSOverTLS',
    'SetDNSSEC',
    'SetDNSSECNegativeTrustAnchors',
    'RevertNTP',
    'RevertDNS',
    'Renew',
    'ForceRenew',
    'Reconfigure',
  ];
  when(() => object.callMethod(
          NetworkdLink.interfaceName, any(that: isIn(voidMethods)), any(),
          replySignature: DBusSignature('')))
      .thenAnswer((_) async => DBusMethodSuccessResponse());

  return object;
}
