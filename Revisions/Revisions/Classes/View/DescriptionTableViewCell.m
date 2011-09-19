//
//  DescriptionTableViewCell.m
//  Revisions
//
//  Created by Dušátko Pavel on 9/18/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "DescriptionTableViewCell.h"

@implementation DescriptionTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        self.detailTextLabel.textAlignment = UITextAlignmentLeft;
        self.detailTextLabel.numberOfLines = 0;
        self.detailTextLabel.lineBreakMode = UILineBreakModeWordWrap;
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
}

#pragma mark - Layout

- (CGRect)frameForDescription:(NSString *)description
{
	CGFloat width = self.frame.size.width;
	
	CGSize constraint = CGSizeMake(width, NSIntegerMax);
	CGSize size = [description sizeWithFont:[UIFont systemFontOfSize:16.0] 
                          constrainedToSize:constraint];
    
	CGFloat height = MAX(20.0, size.height);
	
	return CGRectMake(10.0, 60.0, width - 20.0, height);
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    self.textLabel.frame = CGRectMake(10.0,
                                      0.0,
                                      self.frame.size.width - 20.0,
                                      60.0);
    
    self.detailTextLabel.frame = [self frameForDescription:self.detailTextLabel.text];
}

@end
