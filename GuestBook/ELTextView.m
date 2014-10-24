//
//  ELTextField.m
//  GuestBook
//
//  Created by Vaishakh on 10/21/14.
//  Copyright (c) 2014 GuestBook. All rights reserved.
//

#import "ELTextView.h"

@implementation ELTextView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}



- (id)initWithCoder:(NSCoder*)coder {
    self = [super initWithCoder:coder];
    
    if (self) {
        
        self.clipsToBounds = YES;
        
        UIView *extLeftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 24 , self.frame.size.height)];
        _leftImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"lefttexticon.png"]];
        _leftImageView.frame = CGRectMake(extLeftView.center.x, 25, 12, 12);
        [extLeftView addSubview:_leftImageView];
        [self addSubview:extLeftView];
        
        self.textColor = [UIColor lightGrayColor];
        [self setTextContainerInset:UIEdgeInsetsMake(24, 32, 0, 0)];
        //self.scrollEnabled = NO;
        
    }
    
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
