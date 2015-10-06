//
//  Openin.swift
//  002ADPXYIET(open_in)
//
//  Created by JNYJ on 14-11-12.
//  Copyright (c) 2014年 JNYJ. All rights reserved.
//

import UIKit

class Openin: NSObject {

	var rect_inView : CGRect!
	var document_controller : UIDocumentInteractionController!
	var viewController_parent : MainViewController!

	var bool_failed : Bool

	override init() {
		//
		bool_failed = false
		//
		rect_inView = nil
		document_controller = nil
		viewController_parent = nil
		super.init()
	}

	func setParentViewController(aViewController : MainViewController!, rectInView aRect : CGRect!){
		if let item = self.viewController_parent {
		}else{
			if let item = aViewController {
				self.viewController_parent = aViewController
			}else{
				bool_failed = true
				return
			}
			if let item = aRect {
				self.rect_inView = aRect
			}else{
				bool_failed = true
				return
			}
		}
	}

	func selectApp4Openin(aUrl : NSURL!) -> Bool{
		if bool_failed {
			return false;
		}
		if let item = self.document_controller {
			self.document_controller.URL = aUrl
		}else {
			self.document_controller = UIDocumentInteractionController(URL: aUrl)
			self.document_controller.delegate = self.viewController_parent
		}
		var bool_ : Bool = false
		bool_ = self.document_controller.presentOpenInMenuFromRect(self.rect_inView, inView: self.viewController_parent.view, animated: true)
		return bool_
	}
    
	func dismiss(){
		self.document_controller.dismissMenuAnimated(true)
	}
}
