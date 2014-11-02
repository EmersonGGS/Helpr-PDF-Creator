//
//  MTViewController.m
//  PDFViewer
//
//  Created by C. A. Beninati on 5/21/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "MTViewController.h"
#define kPadding 20

@interface MTViewController ()
{
    CGSize _pageSize;
}
@end

@implementation MTViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}

- (IBAction)didClickOpenPDF {
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *pdfPath = [documentsDirectory stringByAppendingPathComponent:@"NewPDF.pdf"];
    
    if([[NSFileManager defaultManager] fileExistsAtPath:pdfPath]) {
        
        ReaderDocument *document = [ReaderDocument withDocumentFilePath:pdfPath password:nil];
        
        if (document != nil)
        {
            ReaderViewController *readerViewController = [[ReaderViewController alloc] initWithReaderDocument:document];
            readerViewController.delegate = self;
            
            readerViewController.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
            readerViewController.modalPresentationStyle = UIModalPresentationFullScreen;
            
            [self presentModalViewController:readerViewController animated:YES];
        }
    }
}

- (IBAction)didClickMakePDF {
    [self setupPDFDocumentNamed:@"NewPDF" Width:2550 Height:3300];
    
    [self beginPDFPage];

    //header bg bar
    CGRect headerDivider = [self addLineWithFrame:CGRectMake(0, 0, _pageSize.width, 450)
                                       withColor:[UIColor colorWithRed:0.173 green:0.243 blue:0.314 alpha:1]];
    //header HELPR img
    UIImage *anImage = [UIImage imageNamed:@"helpr-logo.png"];
    CGRect imageRect = [self addImage:anImage
                              atPoint:CGPointMake((_pageSize.width/2)-(anImage.size.width/2), kPadding)];
    //School name
    CGRect schoolTitleRect = [self addText:@"Emerson George Stewart"
                                 withFrame:CGRectMake(kPadding+10, (imageRect.origin.y+imageRect.size.height+kPadding), (_pageSize.width/2), 150) fontSize:72.0f];
    //Student's name
    CGRect studentTitleRect = [self addText:@"Walkerton District Secondary School"
                                  withFrame:CGRectMake(kPadding+10, (schoolTitleRect.origin.y+schoolTitleRect.size.height+kPadding), (_pageSize.width/2), 150) fontSize:68.0f];
    //Hours title
    CGRect hoursTitleRect = [self addText:@"Volunteer Work Completed"
                                withFrame:CGRectMake((kPadding+10), (studentTitleRect.origin.y+studentTitleRect.size.height+kPadding+60), 400, 200) fontSize:62.0f];
    
    
    //TABLE HEADINGS
    //Job Heading
    CGRect jobsHeadingRect = [self addText:@"Job Title"
                                withFrame:CGRectMake((kPadding+120), (hoursTitleRect.origin.y+hoursTitleRect.size.height+kPadding+60), 100, 250) fontSize:62.0f];
    //Employer Heading
    CGRect employerHeadingRect = [self addText:@"Employer"
                                withFrame:CGRectMake((jobsHeadingRect.origin.x + jobsHeadingRect.size.width + 160), (hoursTitleRect.origin.y+hoursTitleRect.size.height+kPadding+80), 100, 250) fontSize:58.0f];
    //Hours Heading
    CGRect hoursHeadingRect = [self addText:@"Hours"
                                withFrame:CGRectMake((employerHeadingRect.origin.x + employerHeadingRect.size.width + 160), (hoursTitleRect.origin.y+hoursTitleRect.size.height+kPadding+80), 100, 250) fontSize:58.0f];
    //Date Heading
    CGRect dateHeadingRect = [self addText:@"Date"
                                withFrame:CGRectMake((hoursHeadingRect.origin.x + hoursHeadingRect.size.width + 160), (hoursTitleRect.origin.y+hoursTitleRect.size.height+kPadding+80), 100, 250) fontSize:58.0f];
    //Phone Heading
    CGRect phoneHeadingRect = [self addText:@"Phone Number"
                                 withFrame:CGRectMake((dateHeadingRect.origin.x + dateHeadingRect.size.width + 160), (hoursTitleRect.origin.y+hoursTitleRect.size.height+kPadding+80), 100, 250) fontSize:58.0f];
    //Signature Heading
    CGRect signatureHeadingRect = [self addText:@"Signature"
                                withFrame:CGRectMake((phoneHeadingRect.origin.x + phoneHeadingRect.size.width + 160), (hoursTitleRect.origin.y+hoursTitleRect.size.height+kPadding+80), 100, 250) fontSize:58.0f];
    
    //CGRect imageRect = [self addImage:anImage atPoint:CGPointMake((_pageSize.width/2)-(anImage.size.width/2), headerDivider.origin.y + headerDivider.size.height + kPadding)];
    
    [self finishPDF];

}

- (void)setupPDFDocumentNamed:(NSString*)name Width:(float)width Height:(float)height {
    _pageSize = CGSizeMake(width, height);
    
    NSString *newPDFName = [NSString stringWithFormat:@"%@.pdf", name];
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    
    NSString *pdfPath = [documentsDirectory stringByAppendingPathComponent:newPDFName];
    
    UIGraphicsBeginPDFContextToFile(pdfPath, CGRectZero, nil);
}

- (void)beginPDFPage {
    UIGraphicsBeginPDFPageWithInfo(CGRectMake(0, 0, _pageSize.width, _pageSize.height), nil);
}

- (void)finishPDF {
    UIGraphicsEndPDFContext();
}

- (CGRect)addText:(NSString*)text withFrame:(CGRect)frame fontSize:(float)fontSize {
    UIFont *font = [UIFont systemFontOfSize:fontSize];
    
	CGSize stringSize = [text sizeWithFont:font constrainedToSize:CGSizeMake(_pageSize.width - 2*20-2*20, _pageSize.height - 2*20 - 2*20) lineBreakMode:UILineBreakModeWordWrap];
    
	float textWidth = frame.size.width;
    
    if (textWidth < stringSize.width)
        textWidth = stringSize.width;
    if (textWidth > _pageSize.width)
        textWidth = _pageSize.width - frame.origin.x;
    
    CGRect renderingRect = CGRectMake(frame.origin.x, frame.origin.y, textWidth, stringSize.height);
    
    [text drawInRect:renderingRect 
            withFont:font
       lineBreakMode:UILineBreakModeWordWrap
           alignment:UITextAlignmentLeft];
    
    frame = CGRectMake(frame.origin.x, frame.origin.y, textWidth, stringSize.height);
    
    return frame;
}

- (CGRect)addLineWithFrame:(CGRect)frame withColor:(UIColor*)color {
    CGContextRef currentContext = UIGraphicsGetCurrentContext();
    
    CGContextSetStrokeColorWithColor(currentContext, color.CGColor);
    
    // this is the thickness of the line
    CGContextSetLineWidth(currentContext, frame.size.height);
    
    CGPoint startPoint = frame.origin;
    CGPoint endPoint = CGPointMake(frame.origin.x + frame.size.width, frame.origin.y);

    CGContextBeginPath(currentContext);
    CGContextMoveToPoint(currentContext, startPoint.x, startPoint.y);
    CGContextAddLineToPoint(currentContext, endPoint.x, endPoint.y);
    
    CGContextClosePath(currentContext);    
    CGContextDrawPath(currentContext, kCGPathFillStroke);
    
    return frame;
}

- (CGRect)addImage:(UIImage*)image atPoint:(CGPoint)point {
    CGRect imageFrame = CGRectMake(point.x, point.y, image.size.width, image.size.height);
    [image drawInRect:imageFrame];
    
    return imageFrame;
}

- (void)dismissReaderViewController:(ReaderViewController *)viewController {
    [self dismissModalViewControllerAnimated:YES];
}

@end
