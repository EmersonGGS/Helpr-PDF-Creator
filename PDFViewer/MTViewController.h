//
//  MTViewController.h
//  PDFViewer
//
//  Created by C. A. Beninati on 5/21/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ReaderViewController.h"

@interface MTViewController : UIViewController <ReaderViewControllerDelegate>
- (IBAction)didClickOpenPDF;
- (IBAction)didClickMakePDF;

@end
