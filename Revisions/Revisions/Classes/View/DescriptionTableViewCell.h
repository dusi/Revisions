//
//  DescriptionTableViewCell.h
//  Revisions
//
//  Created by Dušátko Pavel on 9/18/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DescriptionTableViewCell : UITableViewCell

@property (nonatomic, retain) NSString *detailText;
@property (nonatomic, retain) UIWebView *webView;

@end
