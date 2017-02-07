//
//  ViewController.m
//  WLBleDemo
//
//  Created by 王磊 on 2017/2/6.
//  Copyright © 2017年 com.WLTech. All rights reserved.
//

#import "ViewController.h"
#import <CoreBluetooth/CoreBluetooth.h>
#import "PeriCell.h"

#define cellIdentifier @"PeriCell"

@interface ViewController ()<CBCentralManagerDelegate,CBPeripheralDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView1;

@property (nonatomic, strong) CBCentralManager *cbManager;
@property (nonatomic, strong) CBPeripheral *cbPer;
@property (nonatomic, strong) NSMutableArray *periArr;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.cbManager = [[CBCentralManager alloc]initWithDelegate:self queue:nil];
    self.periArr = [NSMutableArray array];
    [self.tableView1 registerNib:[UINib nibWithNibName:cellIdentifier bundle:nil] forCellReuseIdentifier:cellIdentifier];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - CBCentralManagerDelegate
- (void)centralManagerDidUpdateState:(CBCentralManager *)central{
    
    NSLog(@"central.state %zd",central.state);

    switch (central.state)
    {
        case CBCentralManagerStatePoweredOn:
            //discover what peripheral devices are available for your app to connect to
            //第一个参数为CBUUID的数组，需要搜索特点服务的蓝牙设备，只要每搜索到一个符合条件的蓝牙设备都会调用didDiscoverPeripheral代理方法
            [self.cbManager scanForPeripheralsWithServices:nil options:nil];
            break;
        case CBCentralManagerStatePoweredOff:

            [self.periArr removeAllObjects];
            [self.tableView1 reloadData];
            break;

        default:
            NSLog(@"Central Manager did change state");
            break;
    }
    
}
- (void)centralManager:(CBCentralManager *)central willRestoreState:(NSDictionary<NSString *, id> *)dict{
    
}
- (void)centralManager:(CBCentralManager *)central didDiscoverPeripheral:(CBPeripheral *)peripheral advertisementData:(NSDictionary<NSString *, id> *)advertisementData RSSI:(NSNumber *)RSSI{

    if (![peripheral.name isEqualToString:@"Mac"]&&peripheral.name.length>0&&![peripheral.name hasPrefix:@"KK"]) {
         NSLog(@"%@",[NSString stringWithFormat:@"已发现 peripheral: %@ rssi: %@, UUID: %@ advertisementData: %@ ", peripheral, RSSI, peripheral.identifier, advertisementData]);
        [self.periArr addObject:peripheral];
        [self.tableView1 reloadData];
    }
}
- (void)centralManager:(CBCentralManager *)central didConnectPeripheral:(CBPeripheral *)peripheral{
    peripheral.delegate = self;
    NSLog(@"连接成功%@",peripheral.name);
}
- (void)centralManager:(CBCentralManager *)central didFailToConnectPeripheral:(CBPeripheral *)peripheral error:(nullable NSError *)error{
      NSLog(@"连接失败%@",peripheral.name);
}
- (void)centralManager:(CBCentralManager *)central didDisconnectPeripheral:(CBPeripheral *)peripheral error:(nullable NSError *)error{
      NSLog(@"断开连接%@",peripheral.name);
}

#pragma mark - CBPeripheralDelegate



#pragma mark - tableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return self.periArr.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 55;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    PeriCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];
    if (self.periArr.count>indexPath.row) {
            cell.Peri = [self.periArr objectAtIndex:indexPath.row];
    }
    return cell;
    
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.cbPer) {
        [self.cbManager cancelPeripheralConnection:self.cbPer];
    }
    
    if (self.periArr.count>indexPath.row) {
        CBPeripheral *peri = [self.periArr objectAtIndex:indexPath.row];
        self.cbPer = peri;
        [self.cbManager connectPeripheral:peri options:nil];
    }
}
@end
