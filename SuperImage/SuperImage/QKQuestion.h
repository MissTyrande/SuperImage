//
//  QKQuestion.h
//  SuperImage
//
//  Created by leaf_kai on 15/10/27.
//  Copyright © 2015年 leaf_kai. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface QKQuestion : NSObject

@property (nonatomic, copy) NSString *answer;

@property (nonatomic, copy) NSString *title;

@property (nonatomic, copy) NSString *icon;

@property (nonatomic, strong) NSArray *options;

-(instancetype)initwithDict:(NSDictionary *)dict;
+(instancetype)questionwithDict:(NSDictionary *)dict;

@end
