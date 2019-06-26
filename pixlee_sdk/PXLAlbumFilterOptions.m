//
//  PXLAlbumFilterOptions.m
//  pixlee-ios-sdk
//
//  Created by Tim Shi on 4/30/15.
//
//

#import "PXLAlbumFilterOptions.h"

@implementation PXLAlbumFilterOptions

- (NSString *)urlParamString {
    NSMutableDictionary *options = @{}.mutableCopy;
    
    options[@"min_instagram_followers"] = @(self.minInstagramFollowers);
    options[@"min_twitter_followers"] = @(self.minTwitterFollowers);
    options[@"denied_photos"] = @(self.deniedPhotos);
    options[@"starred_photos"] = @(self.starredPhotos);
    options[@"deleted_photos"] = @(self.deletedPhotos);
    options[@"flagged_photos"] = @(self.flaggedPhotos);
    options[@"has_permission"] = @(self.hasPermission);
    options[@"has_product"] = @(self.hasProduct);
    options[@"in_stock_only"] = @(self.inStockOnly);
    
    if (self.contentSource) {
        options[@"content_source"] = self.contentSource;
    }
    if (self.contentType) {
        options[@"content_type"] = self.contentType;
    }
    if (self.filterBySubcaption) {
        options[@"filter_by_subcaption"] = self.filterBySubcaption;
    }
    options[@"has_action_link"] = @(self.hasActionLink);
    if (self.submittedDateStart) {
        options[@"submitted_date_start"] = @([self.submittedDateStart timeIntervalSince1970] * 1000);
    }
    if (self.submittedDateEnd) {
        options[@"submitted_date_end"] = @([self.submittedDateEnd timeIntervalSince1970] * 1000);
    }
    if(self.inCategories){
        options[@"in_categories"] = self.inCategories;
    }
    if(self.computerVision){
        NSError * err;
        NSData * jsonDataComputerVision = [NSJSONSerialization dataWithJSONObject:self.computerVision options:0 error:&err];
        options[@"computer_vision"] = [[NSString alloc] initWithData:jsonDataComputerVision encoding:NSUTF8StringEncoding];
    }
    if(self.filterByLocation){
        NSError * err;
        NSData * jsonDataFilterLocation = [NSJSONSerialization dataWithJSONObject:self.filterByLocation options:0 error:&err];
        options[@"filter_by_location"] = [[NSString alloc] initWithData:jsonDataFilterLocation encoding:NSUTF8StringEncoding];
    }
    if(self.filterByUserhandle){
        NSError * err;
        NSData * jsonData = [NSJSONSerialization dataWithJSONObject:self.filterByUserhandle options:0 error:&err];
        options[@"filter_by_location"] = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    }
    if(self.filterByRadius){
        options[@"filter_by_radius"] = self.filterByRadius;
    }
    
    
    NSData *optionsData = [NSJSONSerialization dataWithJSONObject:options options:0 error:nil];
    NSString *optionsString = [[NSString alloc] initWithData:optionsData encoding:NSUTF8StringEncoding];
    return optionsString;
}

@end
