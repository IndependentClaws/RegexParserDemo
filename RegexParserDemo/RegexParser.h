//
//  RegexParser.h
//  RegexPractice
//
//  Created by Alex Makedonski on 9/14/19.
//  Copyright © 2019 Alex Makedonski. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface RegexParser : NSObject

@property (nonatomic,strong) NSString* text;

-(id) initWith:(NSString*)text;

-(void)getModalsInText:(void(^)(NSString*,NSRange))completion;

+(void)getModalsInTokenArray:(NSArray<NSString*>*)tokenArray withCompletionHandler:(void(^)(NSString*,int))completion;

@end

NS_ASSUME_NONNULL_END
