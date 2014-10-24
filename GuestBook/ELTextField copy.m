//
//  ELTextField.m
//  GuestBook
//
//  Created by Vaishakh on 10/21/14.
//  Copyright (c) 2014 GuestBook. All rights reserved.
//

#import "ELTextField.h"

@implementation ELTextField

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
        [self setLeftViewMode:UITextFieldViewModeAlways];
        
        UIView *extLeftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 32 , self.frame.size.height)];
        _leftImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"lefttexticon.png"]];
        _leftImageView.frame = CGRectMake(extLeftView.center.x, 15, 12, 12);
        
        //leftImageView.center = CGPointMake(leftImageView.center.x, self.center.y);
        [extLeftView addSubview:_leftImageView];
        self.leftView = extLeftView ;
    }
    
    return self;
}

- (CGRect)textRectForBounds:(CGRect)bounds {
    return CGRectInset(bounds, 36, 10);
}

- (CGRect)editingRectForBounds:(CGRect)bounds {
    return CGRectInset(bounds, 36, 10);
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
