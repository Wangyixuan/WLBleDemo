//
//  PeriCell.h
//  WLBleDemo
//
//  Created by 王磊 on 2017/2/7.
//  Copyright © 2017年 com.WLTech. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreBluetooth/CoreBluetooth.h>

@interface PeriCell : UITableViewCell
@property (nonatomic, strong) CBPeripheral *Peri;
@end
