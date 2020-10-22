//
//  PullDownRefreshHeader.h
//  EasyBilling
//
//  Created by QF on 16/11/3.
//  Copyright © 2016年 Qianfan. All rights reserved.
//

#import <MJRefresh/MJRefresh.h>

typedef void (^PullDownRefreshHeaderBlock)();

@interface PullDownRefreshHeader : MJRefreshGifHeader
@property (copy, nonatomic) PullDownRefreshHeaderBlock gifRefreshingBlock;
@end
