import 'package:dbus/dbus.dart';
import 'package:mocktail/mocktail.dart';
import 'package:networkd/networkd.dart';
import 'package:test/test.dart';

class MockDBusClient extends Mock implements DBusClient {}

class MockDBusRemoteObject extends Mock implements DBusRemoteObject {}

void main() {
  test('connect and close', () async {
    final object = createMockRemoteObject();
    final bus = object.client as MockDBusClient;

    final manager = NetworkdManager(object: object);
    await manager.connect();
    verify(() => object.getAllProperties(NetworkdManager.interfaceName))
        .called(1);

    await manager.close();
    verify(bus.close).called(1);
  });

  test('read properties', () async {
    final object = createMockRemoteObject(properties: {
      'OperationalState': const DBusString('routable'),
      'CarrierState': const DBusString('carrier'),
      'AddressState': const DBusString('routable'),
      'IPv4AddressState': const DBusString('routable'),
      'IPv6AddressState': const DBusString('degraded'),
      'OnlineState': const DBusString('online'),
      'NamespaceId': const DBusUint64(1337),
    });

    final manager = NetworkdManager(object: object);
    await manager.connect();
    addTearDown(() async => await manager.close());

    expect(manager.operationalState, equals('routable'));
    expect(manager.carrierState, equals('carrier'));
    expect(manager.addressState, equals('routable'));
    expect(manager.ipv4AddressState, equals('routable'));
    expect(manager.ipv6AddressState, equals('degraded'));
    expect(manager.onlineState, equals('online'));
    expect(manager.namespaceId, equals(1337));
  });

  test('invoke void methods', () async {
    final object = createMockRemoteObject();
    final manager = NetworkdManager(object: object);
    await manager.connect();
    addTearDown(() async => await manager.close());

    await manager
        .setLinkNTP(1, ['0.ubuntu.pool.ntp.org, 1.ubuntu.pool.ntp.org']);
    verifyVoidMethodCall(object, 'SetLinkNTP', [
      DBusInt32(1),
      DBusArray.string(['0.ubuntu.pool.ntp.org, 1.ubuntu.pool.ntp.org'])
    ]);

    await manager.setLinkDefaultRoute(1, true);
    verifyVoidMethodCall(
        object, 'SetLinkDefaultRoute', [DBusInt32(1), DBusBoolean(true)]);

    await manager.setLinkLLMNR(2, 'modeA');
    verifyVoidMethodCall(
        object, 'SetLinkLLMNR', [DBusInt32(2), DBusString('modeA')]);

    await manager.setLinkMulticastDNS(3, 'modeB');
    verifyVoidMethodCall(
        object, 'SetLinkMulticastDNS', [DBusInt32(3), DBusString('modeB')]);

    await manager.setLinkDNSOverTLS(4, 'modeC');
    verifyVoidMethodCall(
        object, 'SetLinkDNSOverTLS', [DBusInt32(4), DBusString('modeC')]);

    await manager.setLinkDNSSEC(5, 'modeD');
    verifyVoidMethodCall(
        object, 'SetLinkDNSSEC', [DBusInt32(5), DBusString('modeD')]);

    await manager.setLinkDNSSECNegativeTrustAnchors(6, ['name1', 'name2']);
    verifyVoidMethodCall(object, 'SetLinkDNSSECNegativeTrustAnchors', [
      DBusInt32(6),
      DBusArray.string(['name1', 'name2'])
    ]);

    await manager.revertLinkNTP(7);
    verifyVoidMethodCall(object, 'RevertLinkNTP', [DBusInt32(7)]);

    await manager.revertLinkDNS(8);
    verifyVoidMethodCall(object, 'RevertLinkDNS', [DBusInt32(8)]);

    await manager.renewLink(9);
    verifyVoidMethodCall(object, 'RenewLink', [DBusInt32(9)]);

    await manager.forceRenewLink(10);
    verifyVoidMethodCall(object, 'ForceRenewLink', [DBusInt32(10)]);

    await manager.reconfigureLink(11);
    verifyVoidMethodCall(object, 'ReconfigureLink', [DBusInt32(11)]);

    await manager.reload();
    verifyVoidMethodCall(object, 'Reload', []);
  });
}

void verifyVoidMethodCall(MockDBusRemoteObject object, String methodName,
        Iterable<DBusValue> values) =>
    verify(() => object.callMethod(
        NetworkdManager.interfaceName, methodName, values,
        replySignature: DBusSignature(''))).called(1);

MockDBusRemoteObject createMockRemoteObject({
  Map<String, DBusValue>? properties,
}) {
  final dbus = MockDBusClient();
  final object = MockDBusRemoteObject();

  when(() => object.client).thenReturn(dbus);
  when(() => object.propertiesChanged).thenAnswer((_) => const Stream.empty());
  when(() => object.getAllProperties(NetworkdManager.interfaceName))
      .thenAnswer((_) async => properties ?? {});
  const voidMethods = [
    'SetLinkNTP',
    'SetLinkDefaultRoute',
    'SetLinkLLMNR',
    'SetLinkMulticastDNS',
    'SetLinkDNSOverTLS',
    'SetLinkDNSSEC',
    'SetLinkDNSSECNegativeTrustAnchors',
    'RevertLinkNTP',
    'RevertLinkDNS',
    'RenewLink',
    'ForceRenewLink',
    'ReconfigureLink',
    'Reload',
  ];
  when(() => object.callMethod(
          NetworkdManager.interfaceName, any(that: isIn(voidMethods)), any(),
          replySignature: DBusSignature('')))
      .thenAnswer((_) async => DBusMethodSuccessResponse());
  when(dbus.close).thenAnswer((_) async {});

  return object;
}
