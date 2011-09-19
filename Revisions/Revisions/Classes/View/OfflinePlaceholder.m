//
//  OfflinePlaceholder.m
//  Revisions
//
//  Created by Dušátko Pavel on 9/18/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "OfflinePlaceholder.h"

@implementation OfflinePlaceholder

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        textLabel = [[UILabel alloc] init];
        textLabel.font = [UIFont boldSystemFontOfSize:16];
        textLabel.textColor = [UIColor grayColor];
        textLabel.textAlignment = UITextAlignmentCenter;
        textLabel.text = NSLocalizedString(@"No internet service", nil);
        [self addSubview:textLabel];
        
        detailTextLabel = [[UILabel alloc] init];
        detailTextLabel.font = [UIFont boldSystemFontOfSize:12];
        detailTextLabel.textColor = [UIColor grayColor];
        detailTextLabel.textAlignment = UITextAlignmentCenter;
        detailTextLabel.text = NSLocalizedString(@"You need to be connected to the Internet.", nil);
        [self addSubview:detailTextLabel];
    }
    return self;
}

- (void)dealloc
{
    [textLabel release];
    [detailTextLabel release];
    
    [super dealloc];
}

#pragma mark - Layout

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    [textLabel sizeToFit];
    [detailTextLabel sizeToFit];
    
    textLabel.frame = CGRectMake(self.frame.origin.x,
                                 round(self.frame.size.height / 2.0 - 15.0),
                                 self.frame.size.width,
                                 20.0);
    
    detailTextLabel.frame = CGRectMake(self.frame.origin.x,
                                       round(self.frame.size.height / 2.0 + 15.0),
                                       self.frame.size.width,
                                       20.0);
}

@end
