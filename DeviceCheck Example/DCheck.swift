//
//  DCheck.swift
//  DeviceCheck Example
//
//  Created by D.B. Galeli on 2/19/23.
//

#error("Don't forget to register your Bundle ID with Apple!")
/// Register your Bundle ID with Apple at https://developer.apple.com/account/resources/identifiers/list/bundleId and set your server address below
/// For more information see https://github.com/thattridentdude/DeviceCheckExample

import DeviceCheck

class DCheck: ObservableObject {
	let currentDevice = DCDevice.current
	let primaryHost = "http://10.0.0.1:9889" // Change this to your server address
	static let sharedInstance = DCheck()
	@Published var localBit0: Bool = false
	@Published var localBit1: Bool = false
	@Published var localLastUpdated: String = ""
	@Published var status: String = ""
	
	init() {
		queryBits()
	}
	
	func queryBits() {
		self.status = "Processing…"
		if currentDevice.isSupported {
			currentDevice.generateToken { (token, error) in
				if let data = token {
					let session = URLSession(configuration: .default)
					var request = URLRequest(url: URL(string:self.primaryHost+"/querybits")!)
					request.addValue("application/json", forHTTPHeaderField: "Content-Type")
					request.httpMethod = "POST"
					let data = try! JSONSerialization.data(withJSONObject: ["token": data.base64EncodedString()], options: [])
					request.httpBody = data
					let dataTask = session.dataTask(with: request, completionHandler: { (data, response, error) in
						if let data = data,
						   let json = String(data: data, encoding: .utf8) {
							print("JSON Output: \(json)")
							DispatchQueue.main.sync {
								if json.contains("\"status\":200") {
									self.status = "Success"
								} else {
									self.status = "Failed"
								}
								self.updateLocalBits(with: data)
							}
						}
						
						if let error = error {
							print("Connection Error: \(error.localizedDescription)")
							DispatchQueue.main.sync {
								self.status = "Connection Error"
							}
						}
					})
					
					dataTask.resume()
				}
				if let error = error {
					print("Error: \(error.localizedDescription)")
					self.status = "Error"
				}
			}
		} else {
			print("Device not supported, is this a real device?")
			self.status = "Device not supported"
		}
	}
	
	
	func updateLocalBits(with data: Data) {
		do {
			let json = try JSONSerialization.jsonObject(with: data, options: []) as! [String: Any]
			if let bit0 = json["bit0"] as? Bool,
			   let bit1 = json["bit1"] as? Bool
			{
				self.localBit0 = bit0
				self.localBit1 = bit1
				print("local 0: \(bit0)")
				print("local 1: \(bit1)")
			}
			if let lastUpdated = json["lastUpdated"] as? String
			{
				self.localLastUpdated = lastUpdated
			}
		} catch {
			print("Error: \(error.localizedDescription)")
		}
	}
	
	
	func updateRemoteBits() {
		self.status = "Processing…"
		if currentDevice.isSupported {
			currentDevice.generateToken { [self] (token, error) in
				if let data = token {
					let session = URLSession(configuration: .default)
					var request = URLRequest(url: URL(string:self.primaryHost+"/updatebits")!)
					request.addValue("application/json", forHTTPHeaderField: "Content-Type")
					request.httpMethod = "POST"
					DispatchQueue.main.sync {
						print("local 0: \(self.localBit0)")
						print("local 1: \(self.localBit1)")
						let bit0 = self.localBit0
						let bit1 = self.localBit1
						let data = try! JSONSerialization.data(withJSONObject: ["token": data.base64EncodedString(), "bit0": bit0, "bit1": bit1] as [String : Any], options: [])
						request.httpBody = data
						let dataTask = session.dataTask(with: request, completionHandler: { (data, response, error) in
							if let data = data,
							   let json = String(data: data, encoding: .utf8) {
								print("JSON Output: \(json)")
								DispatchQueue.main.sync {
									if json.contains("\"status\":200") {
										self.status = "Success"
									} else {
										self.status = "Failed"
									}
									self.updateLocalBits(with: data)
								}
							}
							if let error = error {
								print("Connection Error: \(error.localizedDescription)")
								DispatchQueue.main.sync {
									self.status = "Connection Error"
								}
								
							}
						})
						dataTask.resume()
					}
				}
				if let error = error {
					print("Error: \(error.localizedDescription)")
					self.status = "Error"
				}
			}
		} else {
			print("Device not supported, is this a real device?")
			self.status = "Device not supported"
		}
	}
}
