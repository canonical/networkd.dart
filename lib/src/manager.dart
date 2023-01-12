import 'dart:async';

import 'package:dbus/dbus.dart';
import 'package:meta/meta.dart';
import 'package:networkd/src/link.dart';

import 'util.dart';

class NetworkdManager {
  NetworkdManager({
    DBusClient? bus,
    @visibleForTesting DBusRemoteObject? object,
  })  : _bus = bus,
        _object = object ?? _createRemoteObject(bus);

  static DBusRemoteObject _createRemoteObject(DBusClient? bus) {
    return DBusRemoteObject(
      bus ?? DBusClient.system(),
      name: busName,
      path: DBusObjectPath(objectPath),
    );
  }

  static final String busName = 'org.freedesktop.network1';
  static final String interfaceName = 'org.freedesktop.network1.Manager';
  static final String objectPath = '/org/freedesktop/network1';

  final DBusClient? _bus;
  final DBusRemoteObject _object;
  final _properties = <String, DBusValue>{};
  final _propertyController = StreamController<List<String>>.broadcast();
  StreamSubscription? _propertySubscription;

  /// Stream of property names as they change.
  Stream<List<String>> get propertiesChanged => _propertyController.stream;

  T _getProperty<T>(String name, T defaultValue) {
    return _properties.get(name) ?? defaultValue;
  }

  void _updateProperties(Map<String, DBusValue> properties) {
    _properties.addAll(properties);
    _propertyController.add(properties.keys.toList());
  }

  /// Connects to the service.
  Future<void> connect() async {
    // Already connected
    if (_propertySubscription != null) {
      return;
    }
    _propertySubscription ??= _object.propertiesChanged.listen((signal) {
      if (signal.propertiesInterface == interfaceName) {
        _updateProperties(signal.changedProperties);
      }
    });
    return _object.getAllProperties(interfaceName).then(_updateProperties);
  }

  /// Closes connection to the service.
  Future<void> close() async {
    await _propertySubscription?.cancel();
    _propertySubscription = null;
    if (_bus == null) {
      await _object.client.close();
    }
  }

  String get operationalState => _getProperty('OperationalState', '');
  String get carrierState => _getProperty('CarrierState', '');
  String get addressState => _getProperty('AddressState', '');
  String get ipv4AddressState => _getProperty('IPv4AddressState', '');
  String get ipv6AddressState => _getProperty('IPv6AddressState', '');
  String get onlineState => _getProperty('OnlineState', '');
  int get namespaceId => _getProperty('NamespaceId', -1);

  Future<List<NetworkdLink>> listLinks(
      {bool noAutoStart = false,
      bool allowInteractiveAuthorization = false}) async {
    return _object
        .callMethod(interfaceName, 'ListLinks', [],
            replySignature: DBusSignature('a(iso)'),
            noAutoStart: noAutoStart,
            allowInteractiveAuthorization: allowInteractiveAuthorization)
        .then(
          (response) => response.values.first
              .asArray()
              .map(
                (e) => NetworkdLink(
                  DBusRemoteObject(
                    _object.client,
                    name: busName,
                    path: e.asStruct()[2].asObjectPath(),
                  ),
                ),
              )
              .toList(),
        );
  }

  Future<NetworkdLink> getLinkByName(String name,
      {bool noAutoStart = false,
      bool allowInteractiveAuthorization = false}) async {
    return _object
        .callMethod(interfaceName, 'GetLinkByName', [DBusString(name)],
            replySignature: DBusSignature('io'),
            noAutoStart: noAutoStart,
            allowInteractiveAuthorization: allowInteractiveAuthorization)
        .then(
          (result) => NetworkdLink(
            DBusRemoteObject(
              _object.client,
              name: busName,
              path: result.returnValues[1].asObjectPath(),
            ),
          ),
        );
  }

  Future<NetworkdLink> getLinkByIndex(int ifindex,
      {bool noAutoStart = false,
      bool allowInteractiveAuthorization = false}) async {
    return _object
        .callMethod(interfaceName, 'GetLinkByIndex', [DBusInt32(ifindex)],
            replySignature: DBusSignature('so'),
            noAutoStart: noAutoStart,
            allowInteractiveAuthorization: allowInteractiveAuthorization)
        .then(
          (result) => NetworkdLink(
            DBusRemoteObject(
              _object.client,
              name: busName,
              path: result.returnValues[1].asObjectPath(),
            ),
          ),
        );
  }

  Future<void> setLinkNTP(int ifindex, List<String> servers,
      {bool noAutoStart = false,
      bool allowInteractiveAuthorization = false}) async {
    return _object
        .callMethod(interfaceName, 'SetLinkNTP',
            [DBusInt32(ifindex), DBusArray.string(servers)],
            replySignature: DBusSignature(''),
            noAutoStart: noAutoStart,
            allowInteractiveAuthorization: allowInteractiveAuthorization)
        .then((result) => result.returnValues);
  }

  // TODO implement address model
  Future<void> setLinkDNS(int ifindex, List<DBusStruct> addresses,
      {bool noAutoStart = false,
      bool allowInteractiveAuthorization = false}) async {
    return _object
        .callMethod(
            interfaceName,
            'SetLinkDNS',
            [
              DBusInt32(ifindex),
              DBusArray(DBusSignature('(iay)'), addresses.map((child) => child))
            ],
            replySignature: DBusSignature(''),
            noAutoStart: noAutoStart,
            allowInteractiveAuthorization: allowInteractiveAuthorization)
        .then((result) => result.returnValues);
  }

  // TODO implement address model
  Future<void> setLinkDNSEx(int ifindex, List<DBusStruct> addresses,
      {bool noAutoStart = false,
      bool allowInteractiveAuthorization = false}) async {
    return _object
        .callMethod(
            interfaceName,
            'SetLinkDNSEx',
            [
              DBusInt32(ifindex),
              DBusArray(
                  DBusSignature('(iayqs)'), addresses.map((child) => child))
            ],
            replySignature: DBusSignature(''),
            noAutoStart: noAutoStart,
            allowInteractiveAuthorization: allowInteractiveAuthorization)
        .then((result) => result.returnValues);
  }

  // TODO implement domain model
  Future<void> setLinkDomains(int ifindex, List<DBusStruct> domains,
      {bool noAutoStart = false,
      bool allowInteractiveAuthorization = false}) async {
    return _object
        .callMethod(
            interfaceName,
            'SetLinkDomains',
            [
              DBusInt32(ifindex),
              DBusArray(DBusSignature('(sb)'), domains.map((child) => child))
            ],
            replySignature: DBusSignature(''),
            noAutoStart: noAutoStart,
            allowInteractiveAuthorization: allowInteractiveAuthorization)
        .then((result) => result.returnValues);
  }

  Future<void> setLinkDefaultRoute(int ifindex, bool enable,
      {bool noAutoStart = false,
      bool allowInteractiveAuthorization = false}) async {
    return _object
        .callMethod(interfaceName, 'SetLinkDefaultRoute',
            [DBusInt32(ifindex), DBusBoolean(enable)],
            replySignature: DBusSignature(''),
            noAutoStart: noAutoStart,
            allowInteractiveAuthorization: allowInteractiveAuthorization)
        .then((result) => result.returnValues);
  }

  Future<void> setLinkLLMNR(int ifindex, String mode,
      {bool noAutoStart = false,
      bool allowInteractiveAuthorization = false}) async {
    return _object
        .callMethod(interfaceName, 'SetLinkLLMNR',
            [DBusInt32(ifindex), DBusString(mode)],
            replySignature: DBusSignature(''),
            noAutoStart: noAutoStart,
            allowInteractiveAuthorization: allowInteractiveAuthorization)
        .then((result) => result.returnValues);
  }

  Future<void> setLinkMulticastDNS(int ifindex, String mode,
      {bool noAutoStart = false,
      bool allowInteractiveAuthorization = false}) async {
    return _object
        .callMethod(interfaceName, 'SetLinkMulticastDNS',
            [DBusInt32(ifindex), DBusString(mode)],
            replySignature: DBusSignature(''),
            noAutoStart: noAutoStart,
            allowInteractiveAuthorization: allowInteractiveAuthorization)
        .then((result) => result.returnValues);
  }

  Future<void> setLinkDNSOverTLS(int ifindex, String mode,
      {bool noAutoStart = false,
      bool allowInteractiveAuthorization = false}) async {
    return _object
        .callMethod(interfaceName, 'SetLinkDNSOverTLS',
            [DBusInt32(ifindex), DBusString(mode)],
            replySignature: DBusSignature(''),
            noAutoStart: noAutoStart,
            allowInteractiveAuthorization: allowInteractiveAuthorization)
        .then((result) => result.returnValues);
  }

  Future<void> setLinkDNSSEC(int ifindex, String mode,
      {bool noAutoStart = false,
      bool allowInteractiveAuthorization = false}) async {
    return _object
        .callMethod(interfaceName, 'SetLinkDNSSEC',
            [DBusInt32(ifindex), DBusString(mode)],
            replySignature: DBusSignature(''),
            noAutoStart: noAutoStart,
            allowInteractiveAuthorization: allowInteractiveAuthorization)
        .then((result) => result.returnValues);
  }

  Future<void> setLinkDNSSECNegativeTrustAnchors(
      int ifindex, List<String> names,
      {bool noAutoStart = false,
      bool allowInteractiveAuthorization = false}) async {
    return _object
        .callMethod(interfaceName, 'SetLinkDNSSECNegativeTrustAnchors',
            [DBusInt32(ifindex), DBusArray.string(names)],
            replySignature: DBusSignature(''),
            noAutoStart: noAutoStart,
            allowInteractiveAuthorization: allowInteractiveAuthorization)
        .then((result) => result.returnValues);
  }

  Future<void> revertLinkNTP(int ifindex,
      {bool noAutoStart = false,
      bool allowInteractiveAuthorization = false}) async {
    return _object
        .callMethod(interfaceName, 'RevertLinkNTP', [DBusInt32(ifindex)],
            replySignature: DBusSignature(''),
            noAutoStart: noAutoStart,
            allowInteractiveAuthorization: allowInteractiveAuthorization)
        .then((result) => result.returnValues);
  }

  Future<void> revertLinkDNS(int ifindex,
      {bool noAutoStart = false,
      bool allowInteractiveAuthorization = false}) async {
    return _object
        .callMethod(interfaceName, 'RevertLinkDNS', [DBusInt32(ifindex)],
            replySignature: DBusSignature(''),
            noAutoStart: noAutoStart,
            allowInteractiveAuthorization: allowInteractiveAuthorization)
        .then((result) => result.returnValues);
  }

  Future<void> renewLink(int ifindex,
      {bool noAutoStart = false,
      bool allowInteractiveAuthorization = false}) async {
    return _object
        .callMethod(interfaceName, 'RenewLink', [DBusInt32(ifindex)],
            replySignature: DBusSignature(''),
            noAutoStart: noAutoStart,
            allowInteractiveAuthorization: allowInteractiveAuthorization)
        .then((result) => result.returnValues);
  }

  Future<void> forceRenewLink(int ifindex,
      {bool noAutoStart = false,
      bool allowInteractiveAuthorization = false}) async {
    return _object
        .callMethod(interfaceName, 'ForceRenewLink', [DBusInt32(ifindex)],
            replySignature: DBusSignature(''),
            noAutoStart: noAutoStart,
            allowInteractiveAuthorization: allowInteractiveAuthorization)
        .then((result) => result.returnValues);
  }

  Future<void> reconfigureLink(int ifindex,
      {bool noAutoStart = false,
      bool allowInteractiveAuthorization = false}) async {
    return _object
        .callMethod(interfaceName, 'ReconfigureLink', [DBusInt32(ifindex)],
            replySignature: DBusSignature(''),
            noAutoStart: noAutoStart,
            allowInteractiveAuthorization: allowInteractiveAuthorization)
        .then((result) => result.returnValues);
  }

  Future<void> reload(
      {bool noAutoStart = false,
      bool allowInteractiveAuthorization = false}) async {
    return _object
        .callMethod(interfaceName, 'Reload', [],
            replySignature: DBusSignature(''),
            noAutoStart: noAutoStart,
            allowInteractiveAuthorization: allowInteractiveAuthorization)
        .then((result) => result.returnValues);
  }

  Future<String> describeLink(int ifindex,
      {bool noAutoStart = false,
      bool allowInteractiveAuthorization = false}) async {
    return _object
        .callMethod(interfaceName, 'DescribeLink', [DBusInt32(ifindex)],
            replySignature: DBusSignature('s'),
            noAutoStart: noAutoStart,
            allowInteractiveAuthorization: allowInteractiveAuthorization)
        .then((result) => result.returnValues.first.asString());
  }

  Future<String> describe(
      {bool noAutoStart = false,
      bool allowInteractiveAuthorization = false}) async {
    return _object
        .callMethod(interfaceName, 'Describe', [],
            replySignature: DBusSignature('s'),
            noAutoStart: noAutoStart,
            allowInteractiveAuthorization: allowInteractiveAuthorization)
        .then((result) => result.returnValues.first.asString());
  }
}
