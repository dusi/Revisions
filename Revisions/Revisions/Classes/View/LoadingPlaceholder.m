//
//  LoadingPlaceholder.m
//  Revisions
//
//  Created by Dušátko Pavel on 9/18/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "LoadingPlaceholder.h"

@implementation LoadingPlaceholder

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        textLabel = [[UILabel alloc] init];
        textLabel.font = [UIFont boldSystemFontOfSize: 16];
        textLabel.textColor = [UIColor grayColor];
        textLabel.textAlignment = UITextAlignmentCenter;
        textLabel.text = NSLocalizedString(@"Loading...", nil);
        [self addSubview: textLabel];
        
        activityIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle: UIActivityIndicatorViewStyleGray];
        [activityIndicator startAnimating];
        [self addSubview: activityIndicator];
    }
    return self;
}

- (id)initWithText:(NSString *)text
{
    self = [super init];
    if (self)
    {
        if (text)
            textLabel.text = text;
    }
    return self;
}

- (void)dealloc
{
    [activityIndicator release];
    [textLabel release];
    
    [super dealloc];
}

#pragma mark - Layout

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    [textLabel sizeToFit];
    [activityIndicator sizeToFit];
    
    activityIndicator.frame = CGRectMake(round(self.frame.size.width / 2.0 - activityIndicator.frame.size.width / 2.0),
                                         round(self.frame.size.height / 2.0 - 15.0),
                                         activityIndicator.frame.size.width,
                                         activityIndicator.frame.size.height);
    
    textLabel.frame = CGRectMake(self.frame.origin.x,
                                 round(self.frame.size.height / 2.0 + 15.0),
                                 self.frame.size.width,
                                 20.0);
}

@end
