/// Description of a Manager object.
class NetworkdManagerDescription {
  List<NetworkdLinkDescription>? interfaces;
  List<RoutingPolicyRule>? routingPolicyRules;

  NetworkdManagerDescription({this.interfaces, this.routingPolicyRules});

  NetworkdManagerDescription.fromJson(Map<String, dynamic> json) {
    if (json['Interfaces'] != null) {
      interfaces = <NetworkdLinkDescription>[];
      json['Interfaces'].forEach((v) {
        interfaces!.add(NetworkdLinkDescription.fromJson(v));
      });
    }
    if (json['RoutingPolicyRules'] != null) {
      routingPolicyRules = <RoutingPolicyRule>[];
      json['RoutingPolicyRules'].forEach((v) {
        routingPolicyRules!.add(RoutingPolicyRule.fromJson(v));
      });
    }
  }
}

/// Description of a Link object.
class NetworkdLinkDescription {
  int? index;
  String? name;
  String? type;
  int? flags;
  String? flagsString;
  int? kernelOperationalState;
  String? kernelOperationalStateString;
  int? mtu;
  int? minimumMTU;
  int? maximumMTU;
  String? administrativeState;
  String? operationalState;
  String? carrierState;
  String? addressState;
  String? ipv4AddressState;
  String? ipv6AddressState;
  String? onlineState;
  List<Address>? addresses;
  List<Route>? routes;
  String? kind;
  List<int>? hardwareAddress;
  List<int>? broadcastAddress;
  List<int>? ipv6LinkLocalAddress;
  String? networkFile;
  bool? requiredForOnline;
  List<String>? requiredOperationalStateForOnline;
  String? requiredFamilyForOnline;
  String? activationPolicy;
  String? linkFile;
  List<DNS>? dns;
  List<SearchDomain>? searchDomains;
  List<DNSSettings>? dnsSettings;

  NetworkdLinkDescription({
    this.index,
    this.name,
    this.type,
    this.flags,
    this.flagsString,
    this.kernelOperationalState,
    this.kernelOperationalStateString,
    this.mtu,
    this.minimumMTU,
    this.maximumMTU,
    this.administrativeState,
    this.operationalState,
    this.carrierState,
    this.addressState,
    this.ipv4AddressState,
    this.ipv6AddressState,
    this.onlineState,
    this.addresses,
    this.routes,
    this.kind,
    this.hardwareAddress,
    this.broadcastAddress,
    this.ipv6LinkLocalAddress,
    this.networkFile,
    this.requiredForOnline,
    this.requiredOperationalStateForOnline,
    this.requiredFamilyForOnline,
    this.activationPolicy,
    this.linkFile,
    this.dns,
    this.searchDomains,
    this.dnsSettings,
  });

  NetworkdLinkDescription.fromJson(Map<String, dynamic> json) {
    index = json['Index'];
    name = json['Name'];
    type = json['Type'];
    flags = json['Flags'];
    flagsString = json['FlagsString'];
    kernelOperationalState = json['KernelOperationalState'];
    kernelOperationalStateString = json['KernelOperationalStateString'];
    mtu = json['MTU'];
    minimumMTU = json['MinimumMTU'];
    maximumMTU = json['MaximumMTU'];
    administrativeState = json['AdministrativeState'];
    operationalState = json['OperationalState'];
    carrierState = json['CarrierState'];
    addressState = json['AddressState'];
    ipv4AddressState = json['IPv4AddressState'];
    ipv6AddressState = json['IPv6AddressState'];
    onlineState = json['OnlineState'];
    if (json['Addresses'] != null) {
      addresses = <Address>[];
      json['Addresses'].forEach((v) {
        addresses!.add(Address.fromJson(v));
      });
    }
    if (json['Routes'] != null) {
      routes = <Route>[];
      json['Routes'].forEach((v) {
        routes!.add(Route.fromJson(v));
      });
    }
    kind = json['Kind'];
    hardwareAddress = json['HardwareAddress']?.cast<int>();
    broadcastAddress = json['BroadcastAddress']?.cast<int>();
    ipv6LinkLocalAddress = json['IPv6LinkLocalAddress']?.cast<int>();
    networkFile = json['NetworkFile'];
    requiredForOnline = json['RequiredForOnline'];
    requiredOperationalStateForOnline =
        json['RequiredOperationalStateForOnline']?.cast<String>();
    requiredFamilyForOnline = json['RequiredFamilyForOnline'];
    activationPolicy = json['ActivationPolicy'];
    linkFile = json['LinkFile'];
    if (json['DNS'] != null) {
      dns = <DNS>[];
      json['DNS'].forEach((v) {
        dns!.add(DNS.fromJson(v));
      });
    }
    if (json['SearchDomains'] != null) {
      searchDomains = <SearchDomain>[];
      json['SearchDomains'].forEach((v) {
        searchDomains!.add(SearchDomain.fromJson(v));
      });
    }
    if (json['DNSSettings'] != null) {
      dnsSettings = <DNSSettings>[];
      json['DNSSettings'].forEach((v) {
        dnsSettings!.add(DNSSettings.fromJson(v));
      });
    }
  }
}

/// A network address.
class Address {
  int? family;
  List<int>? address;
  int? prefixLength;
  int? scope;
  String? scopeString;
  int? flags;
  String? flagsString;
  String? configSource;
  String? configState;
  List<int>? broadcast;
  int? preferredLifetimeUsec;
  int? validLifetimeUsec;
  List<int>? configProvider;

  Address({
    this.family,
    this.address,
    this.prefixLength,
    this.scope,
    this.scopeString,
    this.flags,
    this.flagsString,
    this.configSource,
    this.configState,
    this.broadcast,
    this.preferredLifetimeUsec,
    this.validLifetimeUsec,
    this.configProvider,
  });

  Address.fromJson(Map<String, dynamic> json) {
    family = json['Family'];
    address = json['Address']?.cast<int>();
    prefixLength = json['PrefixLength'];
    scope = json['Scope'];
    scopeString = json['ScopeString'];
    flags = json['Flags'];
    flagsString = json['FlagsString'];
    configSource = json['ConfigSource'];
    configState = json['ConfigState'];
    broadcast = json['Broadcast']?.cast<int>();
    preferredLifetimeUsec = json['PreferredLifetimeUsec'];
    validLifetimeUsec = json['ValidLifetimeUsec'];
    configProvider = json['ConfigProvider']?.cast<int>();
  }
}

/// A network route.
class Route {
  int? family;
  List<int>? destination;
  int? destinationPrefixLength;
  List<int>? preferredSource;
  int? scope;
  String? scopeString;
  int? protocol;
  String? protocolString;
  int? type;
  String? typeString;
  int? priority;
  int? table;
  String? tableString;
  int? preference;
  int? flags;
  String? flagsString;
  String? configSource;
  String? configState;
  List<int>? gateway;
  List<int>? configProvider;

  Route({
    this.family,
    this.destination,
    this.destinationPrefixLength,
    this.preferredSource,
    this.scope,
    this.scopeString,
    this.protocol,
    this.protocolString,
    this.type,
    this.typeString,
    this.priority,
    this.table,
    this.tableString,
    this.preference,
    this.flags,
    this.flagsString,
    this.configSource,
    this.configState,
    this.gateway,
    this.configProvider,
  });

  Route.fromJson(Map<String, dynamic> json) {
    family = json['Family'];
    destination = json['Destination']?.cast<int>();
    destinationPrefixLength = json['DestinationPrefixLength'];
    preferredSource = json['PreferredSource']?.cast<int>();
    scope = json['Scope'];
    scopeString = json['ScopeString'];
    protocol = json['Protocol'];
    protocolString = json['ProtocolString'];
    type = json['Type'];
    typeString = json['TypeString'];
    priority = json['Priority'];
    table = json['Table'];
    tableString = json['TableString'];
    preference = json['Preference'];
    flags = json['Flags'];
    flagsString = json['FlagsString'];
    configSource = json['ConfigSource'];
    configState = json['ConfigState'];
    gateway = json['Gateway']?.cast<int>();
    configProvider = json['ConfigProvider']?.cast<int>();
  }
}

/// A DNS address.
class DNS {
  int? family;
  List<int>? address;
  String? configSource;
  List<int>? configProvider;

  DNS({this.family, this.address, this.configSource, this.configProvider});

  DNS.fromJson(Map<String, dynamic> json) {
    family = json['Family'];
    address = json['Address']?.cast<int>();
    configSource = json['ConfigSource'];
    configProvider = json['ConfigProvider']?.cast<int>();
  }
}

/// A search domain.
class SearchDomain {
  String? domain;
  String? configSource;
  List<int>? configProvider;

  SearchDomain({this.domain, this.configSource, this.configProvider});

  SearchDomain.fromJson(Map<String, dynamic> json) {
    domain = json['Domain'];
    configSource = json['ConfigSource'];
    configProvider = json['ConfigProvider']?.cast<int>();
  }
}

/// DNS settings.
class DNSSettings {
  String? llmnr;
  String? configSource;
  String? mdns;

  DNSSettings({this.llmnr, this.configSource, this.mdns});

  DNSSettings.fromJson(Map<String, dynamic> json) {
    llmnr = json['LLMNR'];
    configSource = json['ConfigSource'];
    mdns = json['MDNS'];
  }
}

/// A routing policy rule.
class RoutingPolicyRule {
  int? family;
  int? protocol;
  String? protocolString;
  int? tos;
  int? type;
  String? typeString;
  int? ipProtocol;
  String? ipProtocolString;
  int? priority;
  int? firewallMark;
  int? firewallMask;
  int? table;
  String? tableString;
  bool? invert;
  String? configSource;
  String? configState;

  RoutingPolicyRule({
    this.family,
    this.protocol,
    this.protocolString,
    this.tos,
    this.type,
    this.typeString,
    this.ipProtocol,
    this.ipProtocolString,
    this.priority,
    this.firewallMark,
    this.firewallMask,
    this.table,
    this.tableString,
    this.invert,
    this.configSource,
    this.configState,
  });

  RoutingPolicyRule.fromJson(Map<String, dynamic> json) {
    family = json['Family'];
    protocol = json['Protocol'];
    protocolString = json['ProtocolString'];
    tos = json['TOS'];
    type = json['Type'];
    typeString = json['TypeString'];
    ipProtocol = json['IPProtocol'];
    ipProtocolString = json['IPProtocolString'];
    priority = json['Priority'];
    firewallMark = json['FirewallMark'];
    firewallMask = json['FirewallMask'];
    table = json['Table'];
    tableString = json['TableString'];
    invert = json['Invert'];
    configSource = json['ConfigSource'];
    configState = json['ConfigState'];
  }
}
