//
//  Network_UtilityApp.swift
//  Network Utility
//
//  Created by Brad Dougherty on 4/16/22.
//

import SwiftUI

private final class NetworkUtilityAppDelegate: NSObject, NSApplicationDelegate, ObservableObject {
	func applicationShouldTerminateAfterLastWindowClosed(_ sender: NSApplication) -> Bool { true }
}

@main
struct Network_UtilityApp: App {
	@NSApplicationDelegateAdaptor private var appDelegate: NetworkUtilityAppDelegate
	
    var body: some Scene {
        WindowGroup {
            ContentView()
				.onAppear {
					NSWindow.allowsAutomaticWindowTabbing = false
				}
        }
		.commands {
			CommandGroup(replacing: .newItem) {}
			CommandGroup(replacing: .undoRedo) {}
		}
    }
}
