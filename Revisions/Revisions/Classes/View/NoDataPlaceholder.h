//
//  NoDataPlaceholder.h
//  Revisions
//
//  Created by Dušátko Pavel on 9/18/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NoDataPlaceholder : UIView
{
    UILabel *textLabel;
}

- (id)initWithText:(NSString *)text;

@end
