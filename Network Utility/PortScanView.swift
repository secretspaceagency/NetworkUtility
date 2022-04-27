//
//  PortScanView.swift
//  Network Utility
//
//  Created by Brad Dougherty on 4/17/22.
//

import SwiftUI

struct PortScanView: View {
    var body: some View {
		VStack {
			Text("Port Scan")
		}
		.padding()
    }
}

struct PortScanView_Previews: PreviewProvider {
    static var previews: some View {
		Group {
			PortScanView().preferredColorScheme(.light)
			PortScanView().preferredColorScheme(.dark)			
		}
    }
}
