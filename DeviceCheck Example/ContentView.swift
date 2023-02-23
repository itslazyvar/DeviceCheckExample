//
//  ContentView.swift
//  DeviceCheck Example
//
//  Created by D.B. Galeli on 2/19/23.
//

import SwiftUI

struct ContentView: View {
	@ObservedObject var localBits: DCheck

	
	var body: some View {
		List{
			Section {
				Toggle("bit0", isOn: $localBits.localBit0)
				Toggle("bit1", isOn: $localBits.localBit1)
				Text("Last updated: " + localBits.localLastUpdated)
				HStack {
					Text("Status: ")
					Text(localBits.status)
				}
		}
			Section {
				Button("Query Bits") {
					DCheck.sharedInstance.queryBits()
				}
				
				Button("Send Bits") {
					DCheck.sharedInstance.updateRemoteBits()
				}
			}
	}
		.environmentObject(localBits)
}
}

struct ContentView_Previews: PreviewProvider {
	static var previews: some View {
		ContentView(localBits: DCheck.sharedInstance)
	}
}
