//
//  PlaceholderView.h
//  Revisions
//
//  Created by Dušátko Pavel on 9/18/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

enum kPlaceholderType {
    PlaceholderTypeLoading = 1,
    PlaceholderTypeNoData  = 2,
    PlaceholderTypeOffline = 3
};

@interface PlaceholderView : UIView

@property (nonatomic, readwrite) NSInteger type;
@property (nonatomic, retain) NSString *text;

@end
