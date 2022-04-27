//
//  OutputLog.swift
//  Network Utility
//
//  Created by Brad Dougherty on 4/17/22.
//

import SwiftUI

struct OutputLog: View {
	var output: String
	var command: String
	var arguments: [String]
	
    var body: some View {
		VStack(alignment: .leading) {
			ScrollViewReader { proxy in
				ScrollView {
					VStack(alignment: .leading) {
						HStack {
							Text(output)
								.textSelection(.enabled)
								.font(.system(size: 12, design: .monospaced))
								.id("outputText")
							Spacer()
						}
					}
					.padding(4)
				}
				.background(.background)
				.border(.separator)
				.onChange(of: output) { _ in
					proxy.scrollTo("outputText", anchor: .bottom)
				}
			}
			
			HStack(alignment: .firstTextBaseline, spacing: 0) {
				Text("Command: ")
					.font(.caption)
				Text(try! AttributedString(markdown: "`\(command) \(arguments.joined(separator: " "))`"))
					.font(.caption)
					.textSelection(.enabled)
			}
		}
    }
}

struct OutputLog_Previews: PreviewProvider {
    static var previews: some View {
		OutputLog(output: "", command: "/usr/bin/cmd", arguments: [])
    }
}
