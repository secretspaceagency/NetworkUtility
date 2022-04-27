//
//  WhoisView.swift
//  Network Utility
//
//  Created by Brad Dougherty on 4/17/22.
//

import SwiftUI

struct WhoisView: View {
	enum WhoisServer: String, CaseIterable, Identifiable {
		case automatic = "Automatic"
		case arin = "American Registry for Internet Numbers (ARIN)"
		case apnic = "Asia/Pacific Network Information Center (APNIC)"
		case abuse = "Network Abuse Clearinghouse"
		case afrinic = "African Network Information Centre (AfriNIC)"
		case usmil = "US non-military federal government"
		case internic = "Network Information Center (InterNIC)"
		case iana = "Internet Assigned Numbers Authority (IANA)"
		case krnic = "National Internet Development Agency of Korea (KRNIC)"
		case lacnic = "Latin American and Caribbean IP address Regional Registry (LACNIC)"
		case radb = "Route Arbiter Database (RADB)"
		case peering = "PeeringDB database of AS numbers"
		case ripe = "Réseaux IP Européens (RIPE)"
		
		var id: Self { self }
		
		var flag: String {
			switch self {
			case .arin:
				return "-a"
			case .apnic:
				return "-A"
			case .abuse:
				return "-b"
			case .afrinic:
				return "-f"
			case .usmil:
				return "-g"
			case .internic:
				return "-i"
			case .iana:
				return "-I"
			case .krnic:
				return "-k"
			case .lacnic:
				return "-l"
			case .radb:
				return "-m"
			case .peering:
				return "-P"
			case .ripe:
				return "-r"
			default:
				return ""
			}
		}
	}
	
	let command = "/usr/bin/whois"
	
	@State private var input = ""
	@State private var server: WhoisServer = .automatic
	
	@State private var running = false
	@State private var output = ""
	@State private var task: Process? = nil
	
	func getArguments() -> [String] {
		if server == .automatic {
			return [input]
		}
		
		return [server.flag, input]
	}
	
	func whois() {
		runCommand(path: command, arguments: getArguments(), name: "Whois", task: $task, running: $running) { line, append in
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
			Text("Enter a domain address to look up its “whois” information:")
			
			HStack {
				TextField("", text: $input)
					.frame(width: 175.0)
				Text("(ex. www.example.com)")
					.font(.callout)
			}
			
			HStack(alignment: .bottom) {
				VStack(alignment: .leading) {
					Text("Enter or select a whois server to search.")
					Picker("Enter or select a whois server to search:", selection: $server) {
						ForEach(WhoisServer.allCases) { server in
							Text(server.rawValue).tag(server)
						}
					}
					.pickerStyle(.menu)
					.labelsHidden()
				}
				
				Spacer()
				
				ProgressView()
					.scaleEffect(0.5, anchor: .center)
					.opacity(running ? 1 : 0)
				Button(running ? "Stop" : "Whois", action: whois)
					.keyboardShortcut(.defaultAction)
			}
			.padding(.vertical)
			
			OutputLog(output: output, command: command, arguments: getArguments())
		}
		.padding()
	}
}

struct WhoisView_Previews: PreviewProvider {
    static var previews: some View {
		Group {
			WhoisView().preferredColorScheme(.light)
			WhoisView().preferredColorScheme(.dark)			
		}
    }
}
