//
//  NetstatView.swift
//  Network Utility
//
//  Created by Brad Dougherty on 4/17/22.
//

import SwiftUI

struct NetstatView: View {
	enum NetstatType: String, CaseIterable, Identifiable {
		case routingTable = "Display routing table information"
		case statistics = "Display comprehensive network statistics for each protocol"
		case multicast = "Display multicast information"
		case sockets = "Display the state of all current socket connections"
		
		var id: Self { self }
		
		var flags: [String] {
			switch self {
			case .routingTable:
				return ["-n", "-r"]
			case .statistics:
				return ["-s"]
			case .multicast:
				return ["-g", "-s"]
			case .sockets:
				return ["-n", "-a"]
			}
		}
	}
	
	let command = "/usr/sbin/netstat"
	
	@State private var netstatType: NetstatType = .routingTable
	
	@State private var running = false
	@State private var output = ""
	@State private var task: Process? = nil
	
	func netstat() {
		runCommand(path: command, arguments: netstatType.flags, name: "Netstat", task: $task, running: $running) { line, append in
			if append {
				output.append(line)
			}
			else {
				output = line
			}
		}
	}
	
    var body: some View {
		VStack(alignment: .leading) {
			Picker("", selection: $netstatType) {
				ForEach(NetstatType.allCases) { type in
					Text(type.rawValue).tag(type)
				}
			}
			.labelsHidden()
			.pickerStyle(.radioGroup)
			
			HStack(alignment: .center) {
				Spacer()
				
				ProgressView()
					.scaleEffect(0.5, anchor: .center)
					.opacity(running ? 1 : 0)
				
				Button(running ? "Stop" : "Netstat", action: netstat)
					.keyboardShortcut(.defaultAction)
			}
			.padding(.vertical, 2)
			
			OutputLog(output: output, command: command, arguments: netstatType.flags)
		}
		.padding()
    }
}

struct NetstatView_Previews: PreviewProvider {
    static var previews: some View {
		Group {
			NetstatView().preferredColorScheme(.light)
			NetstatView().preferredColorScheme(.dark)			
		}
    }
}
