//
//  UIDevice+ProcessesAdditions.h
//  TaskGanGan
//
//  Created by zzheron on 11/27/15.
//  Copyright © 2015 zzheron. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIDevice (ProcessesAdditions)
-(NSArray *)runningProcesses;
+(NSString *)getCurrentDeviceModel;
@end
