//
//  RegexParser.m
//  RegexPractice
//
//  Created by Alex Makedonski on 9/14/19.
//  Copyright © 2019 Alex Makedonski. All rights reserved.
//

#import "RegexParser.h"
#import <NaturalLanguage/NaturalLanguage.h>
#import "RangeWord.h"

@interface RegexParser ()

@property (readonly)NLTokenizer* tokenizer;
@property (readonly) NSRange fullTextRange;
@property (readwrite) bool hasBeenTokenized;
@property (nonatomic,strong) NSMutableArray<RangeWord*>* rangeWords;

@end

@implementation RegexParser


static NSString*const modalRegexPattern = @"\\b((sh|c|w)ould((n't)|('ve))*)|(may('ve)*)|(might('ve)*)\\b";

NLTokenizer* _tokenizer;



-(id) initWith:(NSString*)text{
    
    self = [super init];
    
    if(self){
        _text = text;
        _rangeWords = [[NSMutableArray alloc] init];
    }
    
    return self;
}


- (NSMutableArray<RangeWord *> *)rangeWords{
    return _rangeWords;
}

/** Computed property that returns the range for the user-provided text sample **/
- (NSRange)fullTextRange{
    return NSMakeRange(0, _text.length);
}

/** An instance of NL tokenizer that breaks up a user-provided text into words **/

- (NLTokenizer *)tokenizer{
    if(_tokenizer){
        return _tokenizer;
    } else {
        _tokenizer = [[NLTokenizer alloc] initWithUnit:NLTokenUnitWord];
        [_tokenizer setString:_text];
        return _tokenizer;
    }
    
}

/** Given a set of tokens, this function will accept a set of tokens (i.e. an array of strings) and pass a modal word along with its index in said array into a completion handler**/

+(void)getModalsInTokenArray:(NSArray<NSString*>*)tokenArray withCompletionHandler:(void(^)(NSString*,int))completion{
    
        [self findModalsIn:tokenArray withPattern:modalRegexPattern andWithCompletionHandler:completion];
}



/** Helper function that accepts a set of word tokens (i.e. an array of strings) along with a RegEx pattern and a completion handler that allows the user to determine how to further handle matched words and their index in a given text **/

+(void)findModalsIn:(NSArray<NSString*>*)tokenArray withPattern:(NSString*)pattern andWithCompletionHandler: (void(^)(NSString*,int))completion{
    
      NSRegularExpression* regexExpression = [[NSRegularExpression alloc] initWithPattern:pattern options:NSRegularExpressionCaseInsensitive error:nil];
    
        for(int i=0; i<tokenArray.count; i++){
            
            NSString* token = [tokenArray objectAtIndex:i];
            
            NSTextCheckingResult* result = [regexExpression firstMatchInString:token options:NSMatchingReportCompletion range:NSMakeRange(0, [token length])];
            
            NSRange range = [result range];
            
            if(range.location != NSNotFound && range.length != 0){
                completion(token,i);
            }

        }
}





/* This method will tokenize the string and then pass into a closure any matched modals along their corresponding range*/
- (void)getModalsInText:(void(^)(NSString*,NSRange))completion{
    

    if(_hasBeenTokenized){
    
        [self findTokensWith:modalRegexPattern withCompletionHandler:completion];
    
    } else{
        
        [self tokenize];
        [self findTokensWith:modalRegexPattern withCompletionHandler:completion];
    }
}

/** Helper function that takes a RegEx pattern and then passes matched words along with their position index in a text sample into a closure **/


-(void)findTokensWith:(NSString*)pattern withCompletionHandler:(void(^)(NSString*,NSRange))completion{
    
    NSRegularExpression* regexExpression = [[NSRegularExpression alloc] initWithPattern:pattern options:NSRegularExpressionCaseInsensitive error:nil];
    
    NSArray<NSTextCheckingResult*>* results = [regexExpression matchesInString:_text options:NSMatchingReportCompletion range:NSMakeRange(0, [_text length])];
    
    
    for(NSTextCheckingResult*result in results){
        
        NSRange matchedRange = [result range];
        
        NSString* wordToken = [_text substringWithRange:matchedRange];
        
        completion(wordToken,matchedRange);
        
        
    }
}

/** Helper function that tokenizes a text.  This allows for indexing of the words in a text, which allows for calling functions to associate word index with other data, such as linguistic part-of-speech tags **/

-(void) tokenize{
    
    
    [self.tokenizer enumerateTokensInRange:self.fullTextRange usingBlock:^(NSRange tokenRange, NLTokenizerAttributes flags, BOOL * _Nonnull stop) {
            
            NSString* wordToken = [self->_text substringWithRange:tokenRange];
        
        
            RangeWord* newRangeWord = [[RangeWord alloc] initWith:wordToken andWithRange:tokenRange];
        
            [self->_rangeWords addObject:newRangeWord];
        }];
        
    
    
    _hasBeenTokenized = YES;
    
}

@end
