//
//  DeviceCheck_ExampleApp.swift
//  DeviceCheck Example
//
//  Created by D.B. Galeli on 2/19/23.
//

import SwiftUI

@main
struct DeviceCheck_ExampleApp: App {
	init(){
		let _ = DCheck.sharedInstance	
	}
	var body: some Scene {
		WindowGroup {
			ContentView(localBits: DCheck.sharedInstance)
		}
	}
}
