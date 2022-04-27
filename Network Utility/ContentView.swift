//
//  ContentView.swift
//  Network Utility
//
//  Created by Brad Dougherty on 4/16/22.
//

import SwiftUI

struct ContentView: View {	
    var body: some View {
		TabView() {
			InfoView().tag(1).tabItem {
				Text("Info")
			}
			NetstatView().tag(2).tabItem {
				Text("Netstat")
			}
			PingView().tag(3).tabItem {
				Text("Ping")
			}
			LookupView().tag(4).tabItem {
				Text("Lookup")
			}
			TracerouteView().tag(5).tabItem {
				Text("Traceroute")
			}
			WhoisView().tag(6).tabItem {
				Text("Whois")
			}
			FingerView().tag(7).tabItem {
				Text("Finger")
			}
//			PortScanView().tag(8).tabItem {
//				Text("Port Scan")
//			}
		}
		.padding()
		.frame(minWidth: 650, idealWidth: 650, minHeight: 350, idealHeight: 450)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
		Group {
			ContentView().preferredColorScheme(.light)
			ContentView().preferredColorScheme(.dark)
		}
    }
}
