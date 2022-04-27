//
//  PingView.swift
//  Network Utility
//
//  Created by Brad Dougherty on 4/16/22.
//

import SwiftUI

struct PingView: View {
	enum PingType: String, CaseIterable, Identifiable {
		case infinite, limited
		var id: Self { self }
	}
	
	let command = "/sbin/ping"
	
	@State private var input = ""
	@State private var pingType: PingType = .limited
	@State private var count = 10
	
	@State private var running = false
	@State private var output = ""
	@State private var task: Process? = nil
	
	func getArguments() -> [String] {
		if pingType == .infinite {
			return [input]
		}
		
		return ["-c", String(count), input]
	}
	
	func ping() {
		runCommand(path: command, arguments: getArguments(), name: "Ping", task: $task, running: $running) { line, append in
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
			Text("Enter the network address to ping.")
			
			HStack {
				TextField("", text: $input)
					.frame(width: 175.0)
				Text("(ex. 10.0.2.1 or www.example.com)")
					.font(.callout)
			}
			
			HStack(alignment: .bottom) {
				Picker("", selection: $pingType) {
					Text("Send an unlimited number of pings")
						.tag(PingType.infinite)
					HStack {
						Text("Send only")
						Stepper(value: $count, in: 1...100) {
							TextField("", value: $count, formatter: NumberFormatter())
								.frame(width: 50)
								.labelsHidden()
						}
						Text("pings")
					}
					.tag(PingType.limited)
				}
				.pickerStyle(.radioGroup)
				.labelsHidden()
				
				Spacer()
				
				ProgressView()
					.scaleEffect(0.5, anchor: .bottom)
					.opacity(running ? 1 : 0)
				Button(running ? "Stop" : "Ping", action: ping)
					.keyboardShortcut(.defaultAction)
			}
			.padding(.vertical)
			
			OutputLog(output: output, command: command, arguments: getArguments())
		}
		.padding()
	}
}

struct PingView_Previews: PreviewProvider {
    static var previews: some View {
		Group {
			PingView().preferredColorScheme(.light)
			PingView().preferredColorScheme(.dark)			
		}
    }
}
