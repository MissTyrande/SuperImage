//
//  QKQuestion.m
//  SuperImage
//
//  Created by leaf_kai on 15/10/27.
//  Copyright © 2015年 leaf_kai. All rights reserved.
//

#import "QKQuestion.h"

@implementation QKQuestion

-(instancetype)initwithDict:(NSDictionary *)dict
{
    if (self == [self init]) {
        self.answer = dict[@"answer"];
        self.title = dict[@"title"];
        self.icon = dict[@"icon"];
        self.options = dict[@"options"];
    }
    return  self;
}

+(instancetype)questionwithDict:(NSDictionary *)dict
{
    return [[self alloc] initwithDict:dict];
}


@end
