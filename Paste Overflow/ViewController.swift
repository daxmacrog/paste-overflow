//
//  ViewController.swift
//  Paste Overflow
//
//  Created by Dax Mackenzie Roggio on 6/12/23.
//

import Cocoa

class ViewController: NSViewController {

	@IBOutlet weak var licenseKeyField1: NSTextField!
	@IBOutlet weak var licenseKeyField2: NSTextField!
	@IBOutlet weak var licenseKeyField3: NSTextField!
	@IBOutlet weak var licenseKeyField4: NSTextField!

	override func viewDidLoad() {
		super.viewDidLoad()

		NotificationCenter.default.addObserver(forName: Notification.Name("Successful License Activation"), object: nil, queue: OperationQueue.main) { _ in
			self.view.window?.close()
		}
		
		NotificationCenter.default.addObserver(forName: NSTextField.textDidChangeNotification, object: nil, queue: OperationQueue.main) { _ in
			let fields = [self.licenseKeyField1, self.licenseKeyField2, self.licenseKeyField3, self.licenseKeyField4]
			
			for (index, licenseKeyField) in fields.enumerated() {
				if licenseKeyField?.currentEditor() != nil {
					licenseKeyField!.stringValue = licenseKeyField!.stringValue.replacingOccurrences(of: "-", with: "").replacingOccurrences(of: " ", with: "").uppercased() /// remove  hyphens; make uppercase (case insensitive)
					if licenseKeyField!.stringValue.count == 4 { /// user has typed 4th character or pasted 4 characters in current field
						if index < 3 {
							let nextField = fields[index+1]
							nextField!.becomeFirstResponder()
						} else { /// last field filled
							licenseKeyField!.abortEditing()
						}
					} else if licenseKeyField!.stringValue.count > 4 { /// user has pasted more than 4 characters
						if index > 0 { /// if it’s not the 1st field, just chop off everything beyond 4 characters
							licenseKeyField!.stringValue = String(licenseKeyField!.stringValue.prefix(4))
							if index < 2 { /// 2nd or 3rd field filled
								let nextField = fields[index+1]
								nextField!.becomeFirstResponder()
							} else { /// last field filled
								licenseKeyField!.abortEditing()
							}
						} else { /// first field overflowing (presumably from paste)
							let overflowFromField1 = licenseKeyField!.stringValue.dropFirst(4)
							let overflowFromField2 = overflowFromField1.dropFirst(4)
							let overflowFromField3 = overflowFromField2.dropFirst(4)
							
							self.licenseKeyField1.stringValue = String(licenseKeyField!.stringValue.prefix(4))
							self.licenseKeyField2.becomeFirstResponder()
							self.licenseKeyField2.stringValue = String(overflowFromField1.prefix(4))
							self.licenseKeyField3.becomeFirstResponder()
							if overflowFromField2 != "" {
								self.licenseKeyField3.stringValue = String(overflowFromField2.prefix(4))
								self.licenseKeyField4.becomeFirstResponder()
							}
							if overflowFromField3 != "" {
								self.licenseKeyField4.stringValue = String(overflowFromField3.prefix(4))
								if self.licenseKeyField4.stringValue.count == 4 {
									self.licenseKeyField4.abortEditing()
								}
							}
						}
					}
				}
			}
		}
	}

	override var representedObject: Any? {
		didSet {
		// Update the view, if already loaded.
		}
	}


}

