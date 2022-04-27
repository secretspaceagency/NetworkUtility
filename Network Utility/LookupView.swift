//
//  LookupView.swift
//  Network Utility
//
//  Created by Brad Dougherty on 4/17/22.
//

import SwiftUI

struct LookupView: View {
	enum LookupType: String, CaseIterable, Identifiable {
		case macOS = "/usr/bin/dscacheutil"
		case unix = "/usr/bin/dig"
		var id: Self { self }
	}
	
	@State private var input = ""
	@State private var lookupType: LookupType = .macOS
	
	@State private var running = false
	@State private var output = ""
	@State private var task: Process? = nil
	
	func getArguments() -> [String] {
		if lookupType == .macOS {
			return ["-q", "host", "-a", "name", input]
		}
		
		return ["+short", input]
	}
	
	func lookup() {
		runCommand(path: lookupType.rawValue, arguments: getArguments(), name: "Lookup", task: $task, running: $running) { line, append in
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
			Text("Enter an Internet address to look up:")
			
			HStack {
				TextField("", text: $input)
					.frame(width: 175.0)
				Text("(ex. 10.0.2.1 or www.example.com)")
					.font(.callout)
			}
			
			HStack(alignment: .bottom) {
				Form {
					Picker("Use:", selection: $lookupType) {
						VStack(alignment: .leading) {
							Text(try! AttributedString(markdown: "macOS Directory Service (`dscacheutil`)"))
							Text("Used by Safari most Apple apps and services")
								.font(.subheadline)
						}
						.tag(LookupType.macOS)
						Text(try! AttributedString(markdown: "UNIX (`dig`)"))
							.tag(LookupType.unix)
					}
					.pickerStyle(.radioGroup)
				}
				.onSubmit(lookup)
				
				Spacer()
				
				ProgressView()
					.scaleEffect(0.5, anchor: .center)
					.opacity(running ? 1 : 0)
				
				Button(running ? "Stop" : "Look up", action: lookup)
					.keyboardShortcut(.defaultAction)
			}
			.padding(.vertical)
			
			OutputLog(output: output, command: lookupType.rawValue, arguments: getArguments())
		}
		.padding()
    }
}

struct LookupView_Previews: PreviewProvider {
    static var previews: some View {
		Group {
			LookupView().preferredColorScheme(.light)
			LookupView().preferredColorScheme(.dark)			
		}
    }
}
