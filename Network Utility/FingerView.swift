//
//  FingerView.swift
//  Network Utility
//
//  Created by Brad Dougherty on 4/17/22.
//

import SwiftUI

struct FingerView: View {
	let command = "/usr/bin/finger"
	
	@State private var input = ""
	
	@State private var running = false
	@State private var output = ""
	@State private var task: Process? = nil
	
	func lookup() {
		runCommand(path: command, arguments: [input], name: "Finger", task: $task, running: $running) { line, append in
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
			Text("Enter a user name and domain address to use finger to get information about that user:")
			
			HStack {
				TextField("", text: $input)
					.frame(width: 175.0)
				Text("(ex. user@example.com)")
					.font(.callout)
			}
			
			HStack(alignment: .bottom) {
				Spacer()
				
				ProgressView()
					.scaleEffect(0.5, anchor: .center)
					.opacity(running ? 1 : 0)
				Button(running ? "Stop" : "Finger", action: lookup)
					.keyboardShortcut(.defaultAction)
			}
			.padding(.vertical)
			
			OutputLog(output: output, command: command, arguments: [input])
		}
		.padding()
	}
}

struct FingerView_Previews: PreviewProvider {
    static var previews: some View {
		Group {
			FingerView().preferredColorScheme(.light)
			FingerView().preferredColorScheme(.dark)			
		}
    }
}
