//
//  ZXSDHomeLoanInfo.m
//  ZXSDSmile
//
//  Created by chrislos on 2020/7/10.
//  Copyright © 2020 Smile Financial. All rights reserved.
//

#import "ZXSDHomeLoanInfo.h"

@implementation ZXSDHomeLoanInfo

+ (NSDictionary *)modelCustomPropertyMapper {
    return @{
        @"actionModel" :@"buttonVO",
        @"nextActionModel" : @"newIndexButtonVO",
        @"loanModel" :@"creditVO",
        @"extraInfo" :@"parameter",
        @"note" : @"body",
    };
}


+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{
        @"nextActionModel" : ZXSDHomeLoanActionModel.class,
    };
}

- (ZXSDCertifiedStatus)currentCertifiedStatus
{
    ZXSDCertifiedStatus status = ZXSDCertifiedStatusNone;
    if (self.extraInfo.isCertified) {
        status = ZXSDCertifiedStatusDone;
    } else if (self.actionModel.tips.length > 0) {
        status = ZXSDCertifiedStatusDoing;
    }
    return status;
}

- (NSArray *)allPartners
{
    if (!self.partnerMap) {
        return @[];
    }
    
    NSMutableArray *list = [NSMutableArray new];
    NSArray *sorted = [[self.partnerMap allKeys] sortedArrayUsingSelector:@selector(compare:)];
    for (NSString *key in sorted) {
        ZXSDHomePartnerModel *model = [ZXSDHomePartnerModel new];
        model.name = key;
        model.icon = [self.partnerMap objectForKey:key];
        [list addObject:model];
    }
    
    return list;
}

@end

@implementation ZXSDHomeLoanActionModel

@end

@implementation ZXSDHomeCreditItem

@end

@implementation ZXSDHomeExtendCalculation

@end

@implementation ZXSDHomeOverdueCalculation

@end

@implementation ZXSDHomeLoanDataModel

+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{
        @"creditLimitList" : NSNumber.class,
        @"creditUnitList" : ZXSDHomeCreditItem.class,
    };
}

@end

@implementation ZXSDHomeLoanExtraInfo

@end

@implementation ZXSDHomeCollegeModel

- (NSArray *)collegeModelItems{
    if (!_collegeModelItems) {
        ZXSDHomeCollegeModel *college1 = [ZXSDHomeCollegeModel new];
        college1.title = @"哪些人可以申请预支工资的服务";
        college1.detailURL = [NSString stringWithFormat:@"%@%@", H5_WEB, @"/app/faq-detail?type=hot&id=client"];
        college1.hexColor = 0xE9F3FF;
        college1.btnColor = 0x6B9CFF;
        college1.iconName = @"home_college_icon_1";
        
        ZXSDHomeCollegeModel *college2 = [ZXSDHomeCollegeModel new];
        college2.title = @"为何会被拒绝，拒绝后能否再申请";
        college2.detailURL = [NSString stringWithFormat:@"%@%@", H5_WEB, @"/app/faq-detail?type=common&id=reject"];
        college2.hexColor = 0xE5FBE6;
        college2.btnColor = 0x00D663;
        college2.iconName = @"home_college_icon_2";
        
        _collegeModelItems = @[college1,college2];
    }
    
    return _collegeModelItems;
}

@end


@implementation ZXSDHomeQuestionModel

- (NSArray *)questionItems{
    
    if (!_questionItems) {
        
        ZXSDHomeQuestionModel *question0 = [ZXSDHomeQuestionModel new];
        question0.avatar = @"home_question_avatar0";
        question0.phone = @"171****2233";
        question0.title = @"会员费续费的时间周期是怎么计算的？";
        question0.desc = @"用户选择会员期续费的，则参考用户购买当日的用户当前发薪日，在已有会员期的时间基础上往后延对应期数；目前会有以下三种情况：";
        question0.readNumber = @"1400+";
        question0.detailURL = [NSString stringWithFormat:@"%@%@", H5_WEB, @"/app/faq-detail?type=common&id=member_fee"];

        ZXSDHomeQuestionModel *question1 = [ZXSDHomeQuestionModel new];
        question1.avatar = @"home_question_avatar1";
        question1.phone = @"170****5239";
        question1.title = @"我上传的工资明细何时会过期？";
        question1.desc = @"如果您在会员期内，则工资明细上传后3个月才会过期；如果您不在会员期内，则1个月就会过期，比如您的会员期是....";
        question1.readNumber = @"1500+";
        question1.detailURL = [NSString stringWithFormat:@"%@%@", H5_WEB, @"/app/faq-detail?type=common&id=record_expired"];

        ZXSDHomeQuestionModel *question2 = [ZXSDHomeQuestionModel new];
        question2.avatar = @"home_question_avatar0";
        question2.phone = @"171****2233";
        question2.title = @"如何上传银行收支明细 / 微信支付收支明细 ?";
        question2.desc = @"进入银行流水/微信支付收支明细认证，按照引导图文的指引，打开卡号对应的银行/微信APP，一步一步的操作，发送至... ";
        question2.readNumber = @"1700+";
        question2.detailURL = [NSString stringWithFormat:@"%@%@", H5_WEB, @"/app/faq-detail?type=hot&id=upload_flow_details"];
        

        _questionItems = @[question0,question1,question2];
    }
    
    return _questionItems;
}

@end

@implementation ZXSDHomePartnerModel

@end

