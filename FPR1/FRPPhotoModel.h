//
//  FRPPhotoModel.h
//  FPR
//
//  Created by wdcew on 5/26/16.
//  Copyright © 2016 wdcew. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FRPPhotoModel : NSObject
@property (nonatomic, strong, nullable) NSString *photoName;
@property (nonatomic, strong, nullable) NSNumber *identifier;
@property (nonatomic, strong, nullable) NSString *photographerName;
@property (nonatomic, strong, nullable) NSNumber *rating;
@property (nonatomic, strong, nullable) NSString *thumbnailURL;
@property (nonatomic, strong, nullable) NSData *thumbnailData;
@property (nonatomic, strong, nullable) NSString *fullsizedURL;
@property (nonatomic, strong, nullable) NSData *fullsizedData;
@property (nonatomic, assign, getter = isVotedFor) BOOL votedFor;

@end
