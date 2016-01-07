//
//  ZlbUILabel.m
//  zhulebei
//
//  Created by vernon^3^ on 15/12/18.
//  Copyright © 2015年 haoqidai. All rights reserved.
//

#import "CBAutoSizeLabel.h"
#import <libkern/OSAtomic.h>

@interface CBAutoSizeLabel (){
    OSSpinLock lock;
    BOOL alreadySet;
}

@end

@implementation CBAutoSizeLabel

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    if (alreadySet) {
        [super drawRect:rect];
    }
    OSSpinLockLock(&lock);
    if(!alreadySet){
        alreadySet=YES;
        __weak typeof(self) weakself=self;
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 60*NSEC_PER_MSEC), dispatch_get_main_queue(), ^{
            float scaleStep = [UIScreen mainScreen].scale==3?1.2:1.0;
            if (scaleStep>1.0) {
                weakself.font=[UIFont fontWithName:self.font.fontName size:self.font.pointSize*scaleStep];
            }
            [weakself setNeedsDisplay];
        });
    }
    OSSpinLockUnlock(&lock);
}

@end
