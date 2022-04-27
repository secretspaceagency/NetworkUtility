//
//  Run.swift
//  Network Utility
//
//  Created by Brad Dougherty on 4/16/22.
//

import Foundation
import SwiftUI

func runCommand(path: String, arguments: [String], name: String, task: Binding<Process?>, running: Binding<Bool>, outputHandler: @escaping (String, Bool) -> Void) {
	guard task.wrappedValue == nil else {
		task.wrappedValue?.interrupt()
		task.wrappedValue = nil
		return
	}

	let standardOutput = Pipe()
	standardOutput.fileHandleForReading.readabilityHandler = { pipe in
		if let line = String(data: pipe.availableData, encoding: String.Encoding.utf8) {
			outputHandler(line, true)
		}
	}

	let standardError = Pipe()
	standardError.fileHandleForReading.readabilityHandler = { pipe in
		if let line = String(data: pipe.availableData, encoding: String.Encoding.utf8) {
			outputHandler(line, true)
		}
	}

	let internalTask = Process()
	internalTask.executableURL = URL(fileURLWithPath: path)
	internalTask.arguments = arguments
	internalTask.standardOutput = standardOutput
	internalTask.standardError = standardError
	internalTask.terminationHandler = { _ in
		running.wrappedValue = false
		task.wrappedValue = nil
	}

	DispatchQueue.global().async {
		do {
			running.wrappedValue = true
			task.wrappedValue = internalTask
			outputHandler("\(name) has started…\n\n", false)

			try internalTask.run()
		}
		catch {
			print("Error: \(error).")
		}
	}
}
