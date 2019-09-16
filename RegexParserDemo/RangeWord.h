//
//  RangeWord.h
//  RegexPractice
//
//  Created by Alex Makedonski on 9/15/19.
//  Copyright © 2019 Alex Makedonski. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface RangeWord : NSObject

@property (nonatomic,strong)NSString*wordToken;
@property NSRange wordRange;

-(id)initWith:(NSString*)wordToken andWithRange: (NSRange)rangeInText;

@end

NS_ASSUME_NONNULL_END
