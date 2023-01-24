import 'dart:async';
import 'dart:convert';

import 'package:dbus/dbus.dart';
import 'package:meta/meta.dart';

import 'link.dart';
import 'models.dart';
import 'util.dart';

/// The networkd Manager object.
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

  /// The current operational state.
  String get operationalState => _getProperty('OperationalState', '');

  /// The current carrier state.
  String get carrierState => _getProperty('CarrierState', '');

  /// The current address state.
  String get addressState => _getProperty('AddressState', '');

  /// The current IPv4 address state.
  String get ipv4AddressState => _getProperty('IPv4AddressState', '');

  /// The current IPv6 address state.
  String get ipv6AddressState => _getProperty('IPv6AddressState', '');

  /// The current online state.
  String get onlineState => _getProperty('OnlineState', '');

  /// The namespace ID.
  int get namespaceId => _getProperty('NamespaceId', -1);

  /// Lists all managed links.
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

  /// Returns a link specified by its [name].
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

  /// Returns a link specified by its [ifindex].
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

  /// Sets a link's NTP servers.
  Future<void> setLinkNTP(int ifindex, List<String> servers,
      {bool noAutoStart = false,
      bool allowInteractiveAuthorization = false}) async {
    return _object
        .callMethod(interfaceName, 'SetLinkNTP',
            [DBusInt32(ifindex), DBusArray.string(servers)],
            replySignature: DBusSignature(''),
            noAutoStart: noAutoStart,
            allowInteractiveAuthorization: allowInteractiveAuthorization)
        .then((_) {});
  }

  /// Sets a link's DNS addresses.
  Future<void> setLinkDNS(int ifindex, List<DBusStruct> addresses,
      // TODO implement address model
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
        .then((_) {});
  }

  /// Sets a link's DNS addresses.
  Future<void> setLinkDNSEx(int ifindex, List<DBusStruct> addresses,
      // TODO implement address model
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
        .then((_) {});
  }

  /// Sets a link's domains.
  Future<void> setLinkDomains(int ifindex, List<DBusStruct> domains,
      // TODO implement domain model
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
        .then((_) {});
  }

  /// Sets a link's default route status.
  Future<void> setLinkDefaultRoute(int ifindex, bool enable,
      {bool noAutoStart = false,
      bool allowInteractiveAuthorization = false}) async {
    return _object
        .callMethod(interfaceName, 'SetLinkDefaultRoute',
            [DBusInt32(ifindex), DBusBoolean(enable)],
            replySignature: DBusSignature(''),
            noAutoStart: noAutoStart,
            allowInteractiveAuthorization: allowInteractiveAuthorization)
        .then((_) {});
  }

  /// Sets a link's LLMNR mode.
  Future<void> setLinkLLMNR(int ifindex, String mode,
      {bool noAutoStart = false,
      bool allowInteractiveAuthorization = false}) async {
    return _object
        .callMethod(interfaceName, 'SetLinkLLMNR',
            [DBusInt32(ifindex), DBusString(mode)],
            replySignature: DBusSignature(''),
            noAutoStart: noAutoStart,
            allowInteractiveAuthorization: allowInteractiveAuthorization)
        .then((_) {});
  }

  /// Sets a link's multicast DNS mode.
  Future<void> setLinkMulticastDNS(int ifindex, String mode,
      {bool noAutoStart = false,
      bool allowInteractiveAuthorization = false}) async {
    return _object
        .callMethod(interfaceName, 'SetLinkMulticastDNS',
            [DBusInt32(ifindex), DBusString(mode)],
            replySignature: DBusSignature(''),
            noAutoStart: noAutoStart,
            allowInteractiveAuthorization: allowInteractiveAuthorization)
        .then((_) {});
  }

  /// Sets a link's DNS over TLS mode.
  Future<void> setLinkDNSOverTLS(int ifindex, String mode,
      {bool noAutoStart = false,
      bool allowInteractiveAuthorization = false}) async {
    return _object
        .callMethod(interfaceName, 'SetLinkDNSOverTLS',
            [DBusInt32(ifindex), DBusString(mode)],
            replySignature: DBusSignature(''),
            noAutoStart: noAutoStart,
            allowInteractiveAuthorization: allowInteractiveAuthorization)
        .then((_) {});
  }

  /// Sets a link's DNSSEC mode.
  Future<void> setLinkDNSSEC(int ifindex, String mode,
      {bool noAutoStart = false,
      bool allowInteractiveAuthorization = false}) async {
    return _object
        .callMethod(interfaceName, 'SetLinkDNSSEC',
            [DBusInt32(ifindex), DBusString(mode)],
            replySignature: DBusSignature(''),
            noAutoStart: noAutoStart,
            allowInteractiveAuthorization: allowInteractiveAuthorization)
        .then((_) {});
  }

  /// Sets a link's DNSSEC NTAs.
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
        .then((_) {});
  }

  /// Reverts a link's NTP servers.
  Future<void> revertLinkNTP(int ifindex,
      {bool noAutoStart = false,
      bool allowInteractiveAuthorization = false}) async {
    return _object
        .callMethod(interfaceName, 'RevertLinkNTP', [DBusInt32(ifindex)],
            replySignature: DBusSignature(''),
            noAutoStart: noAutoStart,
            allowInteractiveAuthorization: allowInteractiveAuthorization)
        .then((_) {});
  }

  /// Reverts a link's DNS addresses.
  Future<void> revertLinkDNS(int ifindex,
      {bool noAutoStart = false,
      bool allowInteractiveAuthorization = false}) async {
    return _object
        .callMethod(interfaceName, 'RevertLinkDNS', [DBusInt32(ifindex)],
            replySignature: DBusSignature(''),
            noAutoStart: noAutoStart,
            allowInteractiveAuthorization: allowInteractiveAuthorization)
        .then((_) {});
  }

  /// Renews a link.
  Future<void> renewLink(int ifindex,
      {bool noAutoStart = false,
      bool allowInteractiveAuthorization = false}) async {
    return _object
        .callMethod(interfaceName, 'RenewLink', [DBusInt32(ifindex)],
            replySignature: DBusSignature(''),
            noAutoStart: noAutoStart,
            allowInteractiveAuthorization: allowInteractiveAuthorization)
        .then((_) {});
  }

  /// Forcibly renews a link.
  Future<void> forceRenewLink(int ifindex,
      {bool noAutoStart = false,
      bool allowInteractiveAuthorization = false}) async {
    return _object
        .callMethod(interfaceName, 'ForceRenewLink', [DBusInt32(ifindex)],
            replySignature: DBusSignature(''),
            noAutoStart: noAutoStart,
            allowInteractiveAuthorization: allowInteractiveAuthorization)
        .then((_) {});
  }

  /// Reconfigures a link.
  Future<void> reconfigureLink(int ifindex,
      {bool noAutoStart = false,
      bool allowInteractiveAuthorization = false}) async {
    return _object
        .callMethod(interfaceName, 'ReconfigureLink', [DBusInt32(ifindex)],
            replySignature: DBusSignature(''),
            noAutoStart: noAutoStart,
            allowInteractiveAuthorization: allowInteractiveAuthorization)
        .then((_) {});
  }

  /// Reload
  Future<void> reload(
      {bool noAutoStart = false,
      bool allowInteractiveAuthorization = false}) async {
    return _object
        .callMethod(interfaceName, 'Reload', [],
            replySignature: DBusSignature(''),
            noAutoStart: noAutoStart,
            allowInteractiveAuthorization: allowInteractiveAuthorization)
        .then((_) {});
  }

  /// Returns a link's description.
  Future<NetworkdLinkDescription> describeLink(int ifindex,
      {bool noAutoStart = false,
      bool allowInteractiveAuthorization = false}) async {
    return _object
        .callMethod(interfaceName, 'DescribeLink', [DBusInt32(ifindex)],
            replySignature: DBusSignature('s'),
            noAutoStart: noAutoStart,
            allowInteractiveAuthorization: allowInteractiveAuthorization)
        .then((result) => NetworkdLinkDescription.fromJson(
            json.decode(result.returnValues.first.asString())));
  }

  /// Returns the manager's description.
  Future<NetworkdManagerDescription> describe(
      {bool noAutoStart = false,
      bool allowInteractiveAuthorization = false}) async {
    return _object
        .callMethod(interfaceName, 'Describe', [],
            replySignature: DBusSignature('s'),
            noAutoStart: noAutoStart,
            allowInteractiveAuthorization: allowInteractiveAuthorization)
        .then((result) => NetworkdManagerDescription.fromJson(
            json.decode(result.returnValues.first.asString())));
  }
}
