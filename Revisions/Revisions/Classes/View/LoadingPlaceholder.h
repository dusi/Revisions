//
//  LoadingPlaceholder.h
//  Revisions
//
//  Created by Dušátko Pavel on 9/18/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LoadingPlaceholder : UIView
{
    UIActivityIndicatorView *activityIndicator;
    UILabel *textLabel;
}

- (id)initWithText:(NSString *)text;

@end
