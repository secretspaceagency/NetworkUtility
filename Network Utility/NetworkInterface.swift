//
//  NetworkInterface.swift
//  Network Utility
//
//  Created by Brad Dougherty on 4/27/22.
//

import Foundation
import SystemConfiguration

func getStoreValue(interface: SCNetworkInterface, item: String) -> CFPropertyList? {
	guard let name = SCNetworkInterfaceGetBSDName(interface) else {
		return nil
	}
	
	let cfName = "New Network Utility" as CFString
	let dynamicStore = SCDynamicStoreCreate(nil, cfName, nil, nil)
	let key = "State:/Network/Interface/\(name)/\(item)" as CFString
	
	guard let plist = SCDynamicStoreCopyValue(dynamicStore, key) else {
		return nil
	}
	
	return plist
}

struct NetworkInterface: Identifiable, Hashable {
	var networkInterface: SCNetworkInterface
	
	static func getAll() -> [NetworkInterface] {
		let all = SCNetworkInterfaceCopyAll() as! [SCNetworkInterface]
		return all.map { NetworkInterface($0) }
		//		var filtered: [NetworkInterface] = []
		//
		//		for interface in all {
		//			let isEthernet = SCNetworkInterfaceGetInterfaceType(interface) == kSCNetworkInterfaceTypeEthernet;
		//
		//			if isEthernet {
		//				filtered.append(NetworkInterface(interface))
		//			}
		//		}
		//
		//		return filtered
	}
	
	init(_ interface: SCNetworkInterface) {
		networkInterface = interface
	}
	
	func hash(into hasher: inout Hasher) {
		hasher.combine(id)
	}
	
	var id: String {
		guard let name = SCNetworkInterfaceGetBSDName(networkInterface) else {
			return ""
		}
		
		return name as String
	}
	
	var name: String {
		if let name = SCNetworkInterfaceGetBSDName(networkInterface),
		   let displayName = SCNetworkInterfaceGetLocalizedDisplayName(networkInterface) {
			return "\(displayName) (\(name))"
		}
		
		return ""
	}
	
	var hardwareAddress: String {
		guard let address = SCNetworkInterfaceGetHardwareAddressString(networkInterface) else {
			return ""
		}
		
		return address as String
	}
	
	var ipAddress: String {
		guard let plist = getStoreValue(interface: networkInterface, item: "IPv4") else {
			return ""
		}
		
		if let addresses = plist[kSCPropNetIPv4Addresses] as? [String] {
			return addresses.joined(separator: ", ")
		}
		
		return ""
	}
	
	var linkSpeed: String {
		""
	}
	
	var linkStatus: String {
		guard let plist = getStoreValue(interface: networkInterface, item: "Link") else {
			return ""
		}
		
		return plist[kSCPropNetLinkActive] as! Int == 0 ? "Inactive" : "Active"
	}
	
	var vendor: String {
		""
	}
	
	var model: String {
		""
	}
}
