import 'dart:convert';

import 'package:dbus/dbus.dart';

import 'models.dart';

class NetworkdLink {
  NetworkdLink(this._object);
  final DBusRemoteObject _object;

  static final interfaceName = 'org.freedesktop.network1.Link';

  Future<String> get operationalState async {
    return _object
        .getProperty(interfaceName, 'OperationalState',
            signature: DBusSignature('s'))
        .then((result) => result.asString());
  }

  Future<String> get carrierState async {
    return _object
        .getProperty(interfaceName, 'CarrierState',
            signature: DBusSignature('s'))
        .then((result) => result.asString());
  }

  Future<String> get addressState async {
    return _object
        .getProperty(interfaceName, 'AddressState',
            signature: DBusSignature('s'))
        .then((result) => result.asString());
  }

  Future<String> get ipv4AddressState async {
    return _object
        .getProperty(interfaceName, 'IPv4AddressState',
            signature: DBusSignature('s'))
        .then((result) => result.asString());
  }

  Future<String> get ipv6AddressState async {
    return _object
        .getProperty(interfaceName, 'IPv6AddressState',
            signature: DBusSignature('s'))
        .then((result) => result.asString());
  }

  Future<String> get onlineState async {
    return _object
        .getProperty(interfaceName, 'OnlineState',
            signature: DBusSignature('s'))
        .then((result) => result.asString());
  }

  Future<String> get administrativeState async {
    return _object
        .getProperty(interfaceName, 'AdministrativeState',
            signature: DBusSignature('s'))
        .then((result) => result.asString());
  }

  Future<List<int>> get bitRates async {
    return _object
        .getProperty(interfaceName, 'BitRates',
            signature: DBusSignature('(tt)'))
        .then((result) => result.asStruct().map((e) => e.asUint64()).toList());
  }

  Future<void> setNTP(List<String> servers,
      {bool noAutoStart = false,
      bool allowInteractiveAuthorization = false}) async {
    await _object.callMethod(
        interfaceName, 'SetNTP', [DBusArray.string(servers)],
        replySignature: DBusSignature(''),
        noAutoStart: noAutoStart,
        allowInteractiveAuthorization: allowInteractiveAuthorization);
  }

  // TODO implement address model
  Future<void> setDNS(List<DBusStruct> addresses,
      {bool noAutoStart = false,
      bool allowInteractiveAuthorization = false}) async {
    await _object.callMethod(interfaceName, 'SetDNS',
        [DBusArray(DBusSignature('(iay)'), addresses.map((child) => child))],
        replySignature: DBusSignature(''),
        noAutoStart: noAutoStart,
        allowInteractiveAuthorization: allowInteractiveAuthorization);
  }

  // TODO implement address model
  Future<void> setDNSEx(List<DBusStruct> addresses,
      {bool noAutoStart = false,
      bool allowInteractiveAuthorization = false}) async {
    await _object.callMethod(interfaceName, 'SetDNSEx',
        [DBusArray(DBusSignature('(iayqs)'), addresses.map((child) => child))],
        replySignature: DBusSignature(''),
        noAutoStart: noAutoStart,
        allowInteractiveAuthorization: allowInteractiveAuthorization);
  }

  // TODO implement domain model
  Future<void> setDomains(List<DBusStruct> domains,
      {bool noAutoStart = false,
      bool allowInteractiveAuthorization = false}) async {
    await _object.callMethod(interfaceName, 'SetDomains',
        [DBusArray(DBusSignature('(sb)'), domains.map((child) => child))],
        replySignature: DBusSignature(''),
        noAutoStart: noAutoStart,
        allowInteractiveAuthorization: allowInteractiveAuthorization);
  }

  Future<void> setDefaultRoute(bool enable,
      {bool noAutoStart = false,
      bool allowInteractiveAuthorization = false}) async {
    await _object.callMethod(
        interfaceName, 'SetDefaultRoute', [DBusBoolean(enable)],
        replySignature: DBusSignature(''),
        noAutoStart: noAutoStart,
        allowInteractiveAuthorization: allowInteractiveAuthorization);
  }

  Future<void> setLLMNR(String mode,
      {bool noAutoStart = false,
      bool allowInteractiveAuthorization = false}) async {
    await _object.callMethod(interfaceName, 'SetLLMNR', [DBusString(mode)],
        replySignature: DBusSignature(''),
        noAutoStart: noAutoStart,
        allowInteractiveAuthorization: allowInteractiveAuthorization);
  }

  Future<void> setMulticastDNS(String mode,
      {bool noAutoStart = false,
      bool allowInteractiveAuthorization = false}) async {
    await _object.callMethod(
        interfaceName, 'SetMulticastDNS', [DBusString(mode)],
        replySignature: DBusSignature(''),
        noAutoStart: noAutoStart,
        allowInteractiveAuthorization: allowInteractiveAuthorization);
  }

  Future<void> setDNSOverTLS(String mode,
      {bool noAutoStart = false,
      bool allowInteractiveAuthorization = false}) async {
    await _object.callMethod(interfaceName, 'SetDNSOverTLS', [DBusString(mode)],
        replySignature: DBusSignature(''),
        noAutoStart: noAutoStart,
        allowInteractiveAuthorization: allowInteractiveAuthorization);
  }

  Future<void> setDNSSEC(String mode,
      {bool noAutoStart = false,
      bool allowInteractiveAuthorization = false}) async {
    await _object.callMethod(interfaceName, 'SetDNSSEC', [DBusString(mode)],
        replySignature: DBusSignature(''),
        noAutoStart: noAutoStart,
        allowInteractiveAuthorization: allowInteractiveAuthorization);
  }

  Future<void> setDNSSECNegativeTrustAnchors(List<String> names,
      {bool noAutoStart = false,
      bool allowInteractiveAuthorization = false}) async {
    await _object.callMethod(interfaceName, 'SetDNSSECNegativeTrustAnchors',
        [DBusArray.string(names)],
        replySignature: DBusSignature(''),
        noAutoStart: noAutoStart,
        allowInteractiveAuthorization: allowInteractiveAuthorization);
  }

  Future<void> revertNTP(
      {bool noAutoStart = false,
      bool allowInteractiveAuthorization = false}) async {
    await _object.callMethod(interfaceName, 'RevertNTP', [],
        replySignature: DBusSignature(''),
        noAutoStart: noAutoStart,
        allowInteractiveAuthorization: allowInteractiveAuthorization);
  }

  Future<void> revertDNS(
      {bool noAutoStart = false,
      bool allowInteractiveAuthorization = false}) async {
    await _object.callMethod(interfaceName, 'RevertDNS', [],
        replySignature: DBusSignature(''),
        noAutoStart: noAutoStart,
        allowInteractiveAuthorization: allowInteractiveAuthorization);
  }

  Future<void> renew(
      {bool noAutoStart = false,
      bool allowInteractiveAuthorization = false}) async {
    await _object.callMethod(interfaceName, 'Renew', [],
        replySignature: DBusSignature(''),
        noAutoStart: noAutoStart,
        allowInteractiveAuthorization: allowInteractiveAuthorization);
  }

  Future<void> forceRenew(
      {bool noAutoStart = false,
      bool allowInteractiveAuthorization = false}) async {
    await _object.callMethod(interfaceName, 'ForceRenew', [],
        replySignature: DBusSignature(''),
        noAutoStart: noAutoStart,
        allowInteractiveAuthorization: allowInteractiveAuthorization);
  }

  Future<void> reconfigure(
      {bool noAutoStart = false,
      bool allowInteractiveAuthorization = false}) async {
    await _object.callMethod(interfaceName, 'Reconfigure', [],
        replySignature: DBusSignature(''),
        noAutoStart: noAutoStart,
        allowInteractiveAuthorization: allowInteractiveAuthorization);
  }

  Future<NetworkdLinkDescription> describe(
      {bool noAutoStart = false,
      bool allowInteractiveAuthorization = false}) async {
    return _object
        .callMethod(interfaceName, 'Describe', [],
            replySignature: DBusSignature('s'),
            noAutoStart: noAutoStart,
            allowInteractiveAuthorization: allowInteractiveAuthorization)
        .then((result) => NetworkdLinkDescription.fromJson(
            json.decode(result.returnValues.first.asString())));
  }

  @override
  String toString() => 'NetworkdLink(${_object.path.value})';
}
