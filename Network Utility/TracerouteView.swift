//
//  TracerouteView.swift
//  Network Utility
//
//  Created by Brad Dougherty on 4/16/22.
//

import SwiftUI

struct TracerouteView: View {
	let command = "/usr/sbin/traceroute"
	
	@State private var input = ""
	
	@State private var running = false
	@State private var output = ""
	@State private var task: Process? = nil
	
	func traceroute() {
		runCommand(path: command, arguments: [input], name: "Traceroute", task: $task, running: $running) { line, append in
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
			Text("Enter an Internet address to trace the route to:")
			
			HStack {
				TextField("", text: $input)
					.frame(width: 175.0)
				Text("(ex. 10.0.2.1 or www.example.com)")
					.font(.callout)
			}
			
			HStack(alignment: .bottom) {
				Spacer()
				ProgressView()
					.scaleEffect(0.5, anchor: .center)
					.opacity(running ? 1 : 0)
				Button(running ? "Stop" : "Traceroute", action: traceroute)
					.keyboardShortcut(.defaultAction)
			}
			.padding(.vertical)
			
			OutputLog(output: output, command: command, arguments: [input])
		}
		.padding()
    }
}

struct TracerouteView_Previews: PreviewProvider {
    static var previews: some View {
		Group {
			TracerouteView().preferredColorScheme(.light)
			TracerouteView().preferredColorScheme(.dark)
		}
    }
}
