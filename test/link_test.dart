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

  test('link description', () async {
    final object = createMockRemoteObject();
    final link = NetworkdLink(object);
    final linkDescription = await link.describe();
    expect(linkDescription.activationPolicy, equals('up'));
    expect(linkDescription.addressState, equals('routable'));
    expect(linkDescription.administrativeState, equals('configured'));
    expect(linkDescription.carrierState, equals('carrier'));
    expect(linkDescription.flags, equals(69699));
    expect(linkDescription.flagsString,
        equals('up,broadcast,running,multicast,lower-up'));
    expect(linkDescription.hardwareAddress, equals([0, 22, 62, 163, 99, 178]));
    expect(linkDescription.index, equals(22));
    expect(linkDescription.ipv4AddressState, equals('routable'));
    expect(linkDescription.ipv6AddressState, equals('degraded'));
    expect(
        linkDescription.ipv6LinkLocalAddress,
        equals(
            [254, 128, 0, 0, 0, 0, 0, 0, 2, 22, 62, 255, 254, 163, 99, 178]));
    expect(linkDescription.kernelOperationalState, equals(6));
    expect(linkDescription.kernelOperationalStateString, equals('up'));
    expect(linkDescription.kind, equals('veth'));
    expect(linkDescription.linkFile,
        equals('/usr/lib/systemd/network/99-default.link'));
    expect(linkDescription.maximumMTU, equals(65535));
    expect(linkDescription.minimumMTU, equals(68));
    expect(linkDescription.mtu, equals(1500));
    expect(linkDescription.name, equals('eth0'));
    expect(linkDescription.networkFile,
        equals('/run/systemd/network/10-netplan-eth0.network'));
    expect(linkDescription.onlineState, equals('online'));
    expect(linkDescription.operationalState, equals('routable'));
    expect(linkDescription.requiredFamilyForOnline, equals('any'));
    expect(linkDescription.requiredForOnline, equals(true));
    expect(linkDescription.type, equals('ether'));

    final address = linkDescription.addresses!.last;
    expect(address.address, equals([10, 196, 177, 163]));
    expect(address.broadcast, equals([10, 196, 177, 255]));
    expect(address.configProvider, equals([10, 196, 177, 1]));
    expect(address.configSource, equals('DHCPv4'));
    expect(address.configState, equals('configured'));
    expect(address.family, equals(2));
    expect(address.flags, equals(0));
    expect(address.preferredLifetimeUsec, equals(94103156803));
    expect(address.prefixLength, equals(24));
    expect(address.scope, equals(0));
    expect(address.validLifetimeUsec, equals(94103156803));

    final dns = linkDescription.dns!.first;
    expect(dns.address, equals([10, 196, 177, 1]));
    expect(dns.configProvider, equals([10, 196, 177, 1]));
    expect(dns.configSource, equals('DHCPv4'));
    expect(dns.family, equals(2));

    final route = linkDescription.routes!.first;
    expect(route.configProvider, equals(null));
    expect(route.configSource, equals('foreign'));
    expect(route.configState, equals('configured'));
    expect(route.destination, equals([10, 196, 177, 163]));
    expect(route.destinationPrefixLength, equals(32));
    expect(route.family, equals(2));
    expect(route.flags, equals(0));
    expect(route.preference, equals(0));
    expect(route.preferredSource, equals([10, 196, 177, 163]));
    expect(route.priority, equals(0));
    expect(route.protocol, equals(2));
    expect(route.protocolString, equals('kernel'));
    expect(route.scope, equals(254));
    expect(route.scopeString, equals('host'));
    expect(route.table, equals(255));
    expect(route.tableString, equals('local(255)'));
    expect(route.type, equals(2));
    expect(route.typeString, equals('local'));

    final searchDomain = linkDescription.searchDomains!.first;
    expect(searchDomain.configProvider, equals([10, 196, 177, 1]));
    expect(searchDomain.configSource, equals('DHCPv4'));
    expect(searchDomain.domain, equals('lxd'));
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

  when(() => object.callMethod(NetworkdLink.interfaceName, 'Describe', [],
          replySignature: DBusSignature('s')))
      .thenAnswer((_) async => DBusMethodSuccessResponse([
            DBusString(
              '{"Index":22,"Name":"eth0","Kind":"veth","Type":"ether","Flags":69699,"FlagsString":"up,broadcast,running,multicast,lower-up","KernelOperationalState":6,"KernelOperationalStateString":"up","MTU":1500,"MinimumMTU":68,"MaximumMTU":65535,"HardwareAddress":[0,22,62,163,99,178],"BroadcastAddress":[255,255,255,255,255,255],"IPv6LinkLocalAddress":[254,128,0,0,0,0,0,0,2,22,62,255,254,163,99,178],"AdministrativeState":"configured","OperationalState":"routable","CarrierState":"carrier","AddressState":"routable","IPv4AddressState":"routable","IPv6AddressState":"degraded","OnlineState":"online","NetworkFile":"/run/systemd/network/10-netplan-eth0.network","RequiredForOnline":true,"RequiredOperationalStateForOnline":["degraded","routable"],"RequiredFamilyForOnline":"any","ActivationPolicy":"up","LinkFile":"/usr/lib/systemd/network/99-default.link","DNS":[{"Family":2,"Address":[10,196,177,1],"ConfigSource":"DHCPv4","ConfigProvider":[10,196,177,1]}],"SearchDomains":[{"Domain":"lxd","ConfigSource":"DHCPv4","ConfigProvider":[10,196,177,1]}],"DNSSettings":[{"LLMNR":"yes","ConfigSource":"static"},{"MDNS":"no","ConfigSource":"static"}],"Addresses":[{"Family":10,"Address":[254,128,0,0,0,0,0,0,2,22,62,255,254,163,99,178],"PrefixLength":64,"Scope":253,"ScopeString":"link","Flags":128,"FlagsString":"permanent","ConfigSource":"foreign","ConfigState":"configured"},{"Family":2,"Address":[10,196,177,163],"Broadcast":[10,196,177,255],"PrefixLength":24,"Scope":0,"ScopeString":"global","Flags":0,"FlagsString":null,"PreferredLifetimeUsec":94103156803,"ValidLifetimeUsec":94103156803,"ConfigSource":"DHCPv4","ConfigState":"configured","ConfigProvider":[10,196,177,1]}],"Routes":[{"Family":2,"Destination":[10,196,177,163],"DestinationPrefixLength":32,"PreferredSource":[10,196,177,163],"Scope":254,"ScopeString":"host","Protocol":2,"ProtocolString":"kernel","Type":2,"TypeString":"local","Priority":0,"Table":255,"TableString":"local(255)","Preference":0,"Flags":0,"FlagsString":"","ConfigSource":"foreign","ConfigState":"configured"},{"Family":10,"Destination":[254,128,0,0,0,0,0,0,2,22,62,255,254,163,99,178],"DestinationPrefixLength":128,"Scope":0,"ScopeString":"global","Protocol":2,"ProtocolString":"kernel","Type":2,"TypeString":"local","Priority":0,"Table":255,"TableString":"local(255)","Preference":0,"Flags":0,"FlagsString":"","ConfigSource":"foreign","ConfigState":"configured"},{"Family":2,"Destination":[10,196,177,1],"DestinationPrefixLength":32,"PreferredSource":[10,196,177,163],"Scope":253,"ScopeString":"link","Protocol":16,"ProtocolString":"16","Type":1,"TypeString":"unicast","Priority":100,"Table":254,"TableString":"main(254)","Preference":0,"Flags":0,"FlagsString":"","ConfigSource":"DHCPv4","ConfigState":"configured","ConfigProvider":[10,196,177,1]},{"Family":10,"Destination":[254,128,0,0,0,0,0,0,0,0,0,0,0,0,0,0],"DestinationPrefixLength":64,"Scope":0,"ScopeString":"global","Protocol":2,"ProtocolString":"kernel","Type":1,"TypeString":"unicast","Priority":256,"Table":254,"TableString":"main(254)","Preference":0,"Flags":0,"FlagsString":"","ConfigSource":"foreign","ConfigState":"configured"},{"Family":10,"Destination":[255,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0],"DestinationPrefixLength":8,"Scope":0,"ScopeString":"global","Protocol":2,"ProtocolString":"kernel","Type":5,"TypeString":"multicast","Priority":256,"Table":255,"TableString":"local(255)","Preference":0,"Flags":0,"FlagsString":"","ConfigSource":"foreign","ConfigState":"configured"},{"Family":2,"Destination":[10,196,177,255],"DestinationPrefixLength":32,"PreferredSource":[10,196,177,163],"Scope":253,"ScopeString":"link","Protocol":2,"ProtocolString":"kernel","Type":3,"TypeString":"broadcast","Priority":0,"Table":255,"TableString":"local(255)","Preference":0,"Flags":0,"FlagsString":"","ConfigSource":"foreign","ConfigState":"configured"},{"Family":2,"Destination":[0,0,0,0],"DestinationPrefixLength":0,"Gateway":[10,196,177,1],"PreferredSource":[10,196,177,163],"Scope":0,"ScopeString":"global","Protocol":16,"ProtocolString":"16","Type":1,"TypeString":"unicast","Priority":100,"Table":254,"TableString":"main(254)","Preference":0,"Flags":0,"FlagsString":"","ConfigSource":"DHCPv4","ConfigState":"configured","ConfigProvider":[10,196,177,1]},{"Family":2,"Destination":[10,196,177,0],"DestinationPrefixLength":24,"PreferredSource":[10,196,177,163],"Scope":253,"ScopeString":"link","Protocol":2,"ProtocolString":"kernel","Type":1,"TypeString":"unicast","Priority":100,"Table":254,"TableString":"main(254)","Preference":0,"Flags":0,"FlagsString":"","ConfigSource":"foreign","ConfigState":"configured"}]}',
            )
          ]));

  return object;
}
