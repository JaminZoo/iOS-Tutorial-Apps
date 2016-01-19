//
//  PhotoCollectionViewCell.m
//  
//
//  Created by Ben Zhu on 11/10/2015.
//
//

#import "PhotoCollectionViewCell.h"

#define IMAGEVIEW_BORDER_LENGTH 5

@implementation PhotoCollectionViewCell

-(id)initWithFrame: (CGRect)frame {
    
    self = [super initWithFrame:frame];
    
    if (self) {
        [self setup];
    }
    return self;
}

// Called by our Storyboard
-(id)initWithCoder:(NSCoder *)aDecoder {
    
    self = [super initWithCoder:aDecoder];
    
    if (self) {
        [self setup];
    }
    return self;
}

-(void)setup {
    
    // Change default bounds from 50 by 50 to custom size
    self.bounds = CGRectMake(0, 0, 155, 155);
    
    self.imageView = [[UIImageView alloc] initWithFrame:CGRectInset(self.bounds, IMAGEVIEW_BORDER_LENGTH, IMAGEVIEW_BORDER_LENGTH)];
    
    [self.contentView addSubview:self.imageView];
}

@end
