//
//  ApplicationDefaults.h
//  Revisions
//
//  Created by Dušátko Pavel on 9/18/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface ApplicationDefaults : NSManagedObject {
@private
}
@property (nonatomic, retain) NSNumber * lastTabSelected;

@end
