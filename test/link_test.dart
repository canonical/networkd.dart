import 'package:dbus/dbus.dart';
import 'package:mocktail/mocktail.dart';
import 'package:networkd/networkd.dart';
import 'package:test/test.dart';

class MockDBusClient extends Mock implements DBusClient {}

class MockDBusRemoteObject extends Mock implements DBusRemoteObject {}

void main() {
  test('get property', () async {
    final object = createMockRemoteObject();
    final link = NetworkdLink(object);

    expect(await link.operationalState, equals('routable'));
    expect(await link.carrierState, equals('carrier'));
    expect(await link.addressState, equals('routable'));
    expect(await link.ipv4AddressState, equals('routable'));
    expect(await link.ipv6AddressState, equals('degraded'));
    expect(await link.onlineState, equals('online'));
    expect(await link.administrativeState, equals('configured'));
    expect(await link.bitRates, equals([1, 2]));
  });
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

void verifyGetPropertyCall(MockDBusRemoteObject object, String propertyName) =>
    verify(() => object.getProperty(NetworkdLink.interfaceName, propertyName))
        .called(1);

MockDBusRemoteObject createMockRemoteObject() {
  final object = MockDBusRemoteObject();
  final properties = {
    'OperationalState': const DBusString('routable'),
    'CarrierState': const DBusString('carrier'),
    'AddressState': const DBusString('routable'),
    'IPv4AddressState': const DBusString('routable'),
    'IPv6AddressState': const DBusString('degraded'),
    'OnlineState': const DBusString('online'),
    'NamespaceId': const DBusUint64(1337),
    'AdministrativeState': const DBusString('configured'),
    'BitRates': DBusStruct([DBusUint64(1), DBusUint64(2)]),
  };

  when(() => object.propertiesChanged).thenAnswer((_) => const Stream.empty());
  when(() => object.getProperty(
          NetworkdLink.interfaceName, any(that: isA<String>()),
          signature: any(named: 'signature')))
      .thenAnswer((i) async => properties[i.positionalArguments[1]]!);
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
