//
//  NoDataPlaceholder.m
//  Revisions
//
//  Created by Dušátko Pavel on 9/18/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "NoDataPlaceholder.h"

@implementation NoDataPlaceholder

#pragma mark - Object lifecycle

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        textLabel = [[UILabel alloc] init];
        textLabel.font = [UIFont boldSystemFontOfSize:16];
        textLabel.textColor = [UIColor grayColor];
        textLabel.textAlignment = UITextAlignmentCenter;
        textLabel.text = NSLocalizedString(@"No data", nil);
        [self addSubview:textLabel];
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
    [textLabel release];
    
    [super dealloc];
}

#pragma mark - Layout

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    [textLabel sizeToFit];
    
    textLabel.frame = CGRectMake(self.frame.origin.x,
                                 round(self.frame.size.height / 2.0),
                                 self.frame.size.width,
                                 20.0);
}

@end
