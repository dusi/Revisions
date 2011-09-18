//
//  UIView+Extensions.m
//  Revisions
//
//  Created by Dušátko Pavel on 9/18/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "UIView+Extensions.h"

@implementation UIView (Extensions)

- (void)removeAllSubviews
{
    for (UIView *view in self.subviews)
        [view removeFromSuperview];
}

@end
