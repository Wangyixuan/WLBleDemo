//
//  PeriCell.m
//  WLBleDemo
//
//  Created by 王磊 on 2017/2/7.
//  Copyright © 2017年 com.WLTech. All rights reserved.
//

#import "PeriCell.h"
@interface PeriCell()

@property (weak, nonatomic) IBOutlet UILabel *infoLab;

@end

@implementation PeriCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)setPeri:(CBPeripheral *)Peri{
    _Peri = Peri;
    self.infoLab.text = Peri.name;
}
@end
