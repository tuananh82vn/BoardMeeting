//
//  Openin.h
//  002ADPXYIET(open_in)
//
//  Created by JNYJ on 14-11-12.
//  Copyright (c) 2014年 JNYJ. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface Openin : NSObject

@property (nonatomic, assign) CGRect rect_inView;
@property (nonatomic, strong) UIDocumentInteractionController *document_controller;
@property (nonatomic, strong) UIViewController *viewController_parent;
@property (nonatomic, assign) BOOL bool_failed;

- (void)setParentViewController:(id)aViewController rectInView:(CGRect)aRect;
- (BOOL)selectApp4Openin:(NSURL *)aUrl;
- (void)dismiss;

@end
