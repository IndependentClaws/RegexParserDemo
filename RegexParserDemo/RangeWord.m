//
//  RangeWord.m
//  RegexPractice
//
//  Created by Alex Makedonski on 9/15/19.
//  Copyright © 2019 Alex Makedonski. All rights reserved.
//

#import "RangeWord.h"

@implementation RangeWord

-(id)initWith:(NSString*)wordToken andWithRange: (NSRange)rangeInText{
    self = [super init];
    
    if(self){
        
        _wordToken = wordToken;
        _wordRange = rangeInText;
    }
    
    return self;
}
@end
