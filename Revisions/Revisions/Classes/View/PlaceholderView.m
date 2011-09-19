//
//  PlaceholderView.m
//  Revisions
//
//  Created by Dušátko Pavel on 9/18/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "PlaceholderView.h"
#import "LoadingPlaceholder.h"
#import "NoDataPlaceholder.h"
#import "OfflinePlaceholder.h"
#import "UIView+Extensions.h"

@interface PlaceholderView ()
- (void)configureView;
@end

@implementation PlaceholderView

@synthesize type;
@synthesize text;

#pragma mark - Object lifecycle

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        type = PlaceholderTypeLoading;
        
        [self configureView];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self)
    {
        type = PlaceholderTypeLoading;
        
        [self configureView];
    }
    
    return self;
}

- (void)dealloc
{
    [text release];
    
    [super dealloc];
}

#pragma mark - View configuration

- (UIView *)placeholderOfType:(NSInteger)aType
{
    UIView *result = nil;
    
    switch (aType)
    {
        case PlaceholderTypeLoading:
        {
            result = [[LoadingPlaceholder alloc] init];
            
            break;
        }
        case PlaceholderTypeNoData:
        {
            result = [[NoDataPlaceholder alloc] initWithText:text];
            
            break;
        }
        case PlaceholderTypeOffline:
        {
            result = [[OfflinePlaceholder alloc] init];
            
            break;
        }
    }
    
    return [result autorelease];
}

- (void)configureView
{
    [self removeAllSubviews];
    
    UIView *placeholder = [self placeholderOfType:type];
    
    placeholder.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    placeholder.frame = CGRectMake(0.0,
                                   0.0,
                                   self.bounds.size.width,
                                   self.bounds.size.height);
    [self addSubview:placeholder];
}

#pragma mark - Accessors

- (void)setType:(NSInteger)aType
{
    if (type != aType)
    {
        type = aType;
        
        [self configureView];
    }
}

@end
