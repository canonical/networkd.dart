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

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (interfaces != null) {
      data['Interfaces'] = interfaces!.map((v) => v.toJson()).toList();
    }
    if (routingPolicyRules != null) {
      data['RoutingPolicyRules'] =
          routingPolicyRules!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

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

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['Index'] = index;
    data['Name'] = name;
    data['Type'] = type;
    data['Flags'] = flags;
    data['FlagsString'] = flagsString;
    data['KernelOperationalState'] = kernelOperationalState;
    data['KernelOperationalStateString'] = kernelOperationalStateString;
    data['MTU'] = mtu;
    data['MinimumMTU'] = minimumMTU;
    data['MaximumMTU'] = maximumMTU;
    data['AdministrativeState'] = administrativeState;
    data['OperationalState'] = operationalState;
    data['CarrierState'] = carrierState;
    data['AddressState'] = addressState;
    data['IPv4AddressState'] = ipv4AddressState;
    data['IPv6AddressState'] = ipv6AddressState;
    data['OnlineState'] = onlineState;
    if (addresses != null) {
      data['Addresses'] = addresses!.map((v) => v.toJson()).toList();
    }
    if (routes != null) {
      data['Routes'] = routes!.map((v) => v.toJson()).toList();
    }
    data['Kind'] = kind;
    data['HardwareAddress'] = hardwareAddress;
    data['BroadcastAddress'] = broadcastAddress;
    data['IPv6LinkLocalAddress'] = ipv6LinkLocalAddress;
    data['NetworkFile'] = networkFile;
    data['RequiredForOnline'] = requiredForOnline;
    data['RequiredOperationalStateForOnline'] =
        requiredOperationalStateForOnline;
    data['RequiredFamilyForOnline'] = requiredFamilyForOnline;
    data['ActivationPolicy'] = activationPolicy;
    data['LinkFile'] = linkFile;
    if (dns != null) {
      data['DNS'] = dns!.map((v) => v.toJson()).toList();
    }
    if (searchDomains != null) {
      data['SearchDomains'] = searchDomains!.map((v) => v.toJson()).toList();
    }
    if (dnsSettings != null) {
      data['DNSSettings'] = dnsSettings!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

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

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['Family'] = family;
    data['Address'] = address;
    data['PrefixLength'] = prefixLength;
    data['Scope'] = scope;
    data['ScopeString'] = scopeString;
    data['Flags'] = flags;
    data['FlagsString'] = flagsString;
    data['ConfigSource'] = configSource;
    data['ConfigState'] = configState;
    data['Broadcast'] = broadcast;
    data['PreferredLifetimeUsec'] = preferredLifetimeUsec;
    data['ValidLifetimeUsec'] = validLifetimeUsec;
    data['ConfigProvider'] = configProvider;
    return data;
  }
}

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

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['Family'] = family;
    data['Destination'] = destination;
    data['DestinationPrefixLength'] = destinationPrefixLength;
    data['PreferredSource'] = preferredSource;
    data['Scope'] = scope;
    data['ScopeString'] = scopeString;
    data['Protocol'] = protocol;
    data['ProtocolString'] = protocolString;
    data['Type'] = type;
    data['TypeString'] = typeString;
    data['Priority'] = priority;
    data['Table'] = table;
    data['TableString'] = tableString;
    data['Preference'] = preference;
    data['Flags'] = flags;
    data['FlagsString'] = flagsString;
    data['ConfigSource'] = configSource;
    data['ConfigState'] = configState;
    data['Gateway'] = gateway;
    data['ConfigProvider'] = configProvider;
    return data;
  }
}

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

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['Family'] = family;
    data['Address'] = address;
    data['ConfigSource'] = configSource;
    data['ConfigProvider'] = configProvider;
    return data;
  }
}

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

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['Domain'] = domain;
    data['ConfigSource'] = configSource;
    data['ConfigProvider'] = configProvider;
    return data;
  }
}

class DNSSettings {
  String? lLMNR;
  String? configSource;
  String? mDNS;

  DNSSettings({this.lLMNR, this.configSource, this.mDNS});

  DNSSettings.fromJson(Map<String, dynamic> json) {
    lLMNR = json['LLMNR'];
    configSource = json['ConfigSource'];
    mDNS = json['MDNS'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['LLMNR'] = lLMNR;
    data['ConfigSource'] = configSource;
    data['MDNS'] = mDNS;
    return data;
  }
}

class RoutingPolicyRule {
  int? family;
  int? protocol;
  String? protocolString;
  int? tOS;
  int? type;
  String? typeString;
  int? iPProtocol;
  String? iPProtocolString;
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
    this.tOS,
    this.type,
    this.typeString,
    this.iPProtocol,
    this.iPProtocolString,
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
    tOS = json['TOS'];
    type = json['Type'];
    typeString = json['TypeString'];
    iPProtocol = json['IPProtocol'];
    iPProtocolString = json['IPProtocolString'];
    priority = json['Priority'];
    firewallMark = json['FirewallMark'];
    firewallMask = json['FirewallMask'];
    table = json['Table'];
    tableString = json['TableString'];
    invert = json['Invert'];
    configSource = json['ConfigSource'];
    configState = json['ConfigState'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['Family'] = family;
    data['Protocol'] = protocol;
    data['ProtocolString'] = protocolString;
    data['TOS'] = tOS;
    data['Type'] = type;
    data['TypeString'] = typeString;
    data['IPProtocol'] = iPProtocol;
    data['IPProtocolString'] = iPProtocolString;
    data['Priority'] = priority;
    data['FirewallMark'] = firewallMark;
    data['FirewallMask'] = firewallMask;
    data['Table'] = table;
    data['TableString'] = tableString;
    data['Invert'] = invert;
    data['ConfigSource'] = configSource;
    data['ConfigState'] = configState;
    return data;
  }
}