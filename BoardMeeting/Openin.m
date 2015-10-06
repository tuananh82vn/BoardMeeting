//
//  Openin.m
//  002ADPXYIET(open_in)
//
//  Created by JNYJ on 14-11-12.
//  Copyright (c) 2014年 JNYJ. All rights reserved.
//

#import "Openin.h"

@implementation Openin


- (void)setParentViewController:(id)aViewController rectInView:(CGRect)aRect
{
	if (nil != self.viewController_parent) {
	}
	if (aViewController) {
		self.viewController_parent = (UIViewController *)aViewController;
	}else{
		self.bool_failed = true;
		return;
	}
	self.rect_inView = aRect;
}

- (BOOL)selectApp4Openin:(NSURL *)aUrl
{
	if (self.bool_failed) {
		return NO;
	}
	if (nil == self.document_controller) {
		self.document_controller = [UIDocumentInteractionController interactionControllerWithURL:aUrl];
		self.document_controller.delegate = (id)self.viewController_parent;
	} else {
		[self.document_controller setURL:aUrl];
	}
	if ([self.document_controller presentOpenInMenuFromRect:self.rect_inView
													 inView:self.viewController_parent.view animated:YES]) {
		return YES;
	}
	else {
		return NO;
	}
}
- (void)dismiss
{
	[self.document_controller dismissMenuAnimated:YES];
}
@end
