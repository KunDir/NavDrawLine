//
//  FKAnnotation.h
//  07-导航画线
//
//  Created by kun on 15/2/6.
//  Copyright (c) 2015年 kun. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>
@interface FKAnnotation : NSObject <MKAnnotation>
@property (nonatomic, assign) CLLocationCoordinate2D coordinate;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *subtitle;

@end
