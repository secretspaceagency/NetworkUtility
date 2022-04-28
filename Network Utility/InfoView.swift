//
//  InfoView.swift
//  Network Utility
//
//  Created by Brad Dougherty on 4/17/22.
//

import SwiftUI

extension HorizontalAlignment {
	private enum FormAlignment: AlignmentID {
		static func defaultValue(in context: ViewDimensions) -> CGFloat {
			context[.trailing]
		}
	}
	static let interfaceInformation = HorizontalAlignment(FormAlignment.self)
	static let transferStatistics = HorizontalAlignment(FormAlignment.self)
}

struct InfoView: View {
	enum InterfaceInformation: String, CaseIterable, Identifiable {
		case hardwareAddress = "Hardware Address"
		case ipAddress = "IP Address"
		case linkSpeed = "Link Speed"
		case linkStatus = "Link Status"
		case vendor = "Vendor"
		case model = "Model"
		
		var id: Self { self }
	}
	
	enum TransferStatistics: String, CaseIterable, Identifiable {
		case sentPackets = "Sent Packets"
		case sendErrors = "Send Errors"
		case recvPackets = "Recv Packets"
		case recvErrors = "Recv Errors"
		case collisions = "Collisions"
		
		var id: Self { self }
	}
	
	let interfaces = NetworkInterface.getAll()
	
	@State private var selectedInterface = ""
	
	func getInterfaceInfo(_ datapoint: InterfaceInformation) -> String {
		guard let interface = interfaces.first(where: { $0.id == selectedInterface }) else {
			return ""
		}
		
		switch datapoint {
		case .hardwareAddress:
			return interface.hardwareAddress
		case .ipAddress:
			return interface.ipAddress
		case .linkSpeed:
			return interface.linkSpeed
		case .linkStatus:
			return interface.linkStatus
		case .vendor:
			return interface.vendor
		case .model:
			return interface.model
		}
	}
	
	func getTransferStatistics(_ datapoint: TransferStatistics) -> String {
		switch datapoint {
		default:
			return "0"
		}
	}
	
    var body: some View {
		VStack(alignment: .leading) {
			Text("Select a network interface for information:")
			
			Picker("Select a network interface for information", selection: $selectedInterface) {
				ForEach(interfaces, id: \.self) { interface in
					Text(interface.name).tag(interface.id)
				}
			}
			.labelsHidden()
			.frame(maxWidth: 300)
			
			HStack(alignment: .top, spacing: 15) {
				GroupBox(label: Text("Interface Information")) {
					HStack {
						VStack(alignment: .interfaceInformation, spacing: 5) {
							ForEach(InterfaceInformation.allCases) { type in
								HStack(alignment: .top) {
									Text("\(type.rawValue):")
										.alignmentGuide(.interfaceInformation) { d in d[HorizontalAlignment.trailing] }
									Text(getInterfaceInfo(type))
										.textSelection(.enabled)
								}
							}
						}
						Spacer()
					}
					.frame(maxWidth: .infinity)
					.padding(10)
					Spacer()
				}
				
				GroupBox(label: Text("Transfer Statistics")) {
					HStack {
						VStack(alignment: .transferStatistics, spacing: 5) {
							ForEach(TransferStatistics.allCases) { type in
								HStack {
									Text("\(type.rawValue):")
										.alignmentGuide(.transferStatistics) { d in d[HorizontalAlignment.trailing] }
									Text(getTransferStatistics(type))
										.textSelection(.enabled)
								}
							}
						}
						Spacer()
					}
					.frame(maxWidth: 300)
					.padding(10)
					Spacer()
				}
			}
		}
		.padding()
		.onAppear {
			selectedInterface = interfaces.first?.id ?? ""
		}
    }
	
}

struct InfoView_Previews: PreviewProvider {
    static var previews: some View {
		Group {
			InfoView().preferredColorScheme(.light)
			InfoView().preferredColorScheme(.dark)
		}
    }
}
