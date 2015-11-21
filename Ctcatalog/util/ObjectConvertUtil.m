//
//  ObjectConvertUtil.m
//  Youngcatalog
//
//  Created by honlun on 2014/8/23.
//  Copyright (c) 2014年 honlun. All rights reserved.
//

#import "ObjectConvertUtil.h"
#import "AppDelegate.h"
#import <objc/message.h>
#import "JSONModel.h"
#import "JSONModelError.h"
#import "Album.h"

@implementation ObjectConvertUtil
+(NSMutableArray*)convertTOManagedobjectWithJsonStr:(NSArray*)ary class:(Class)managedClass{
    AppDelegate* appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    NSManagedObjectContext* managedObjectContext = [appDelegate managedObjectContext];
    NSEntityDescription *entity = [NSEntityDescription entityForName:NSStringFromClass(managedClass.class) inManagedObjectContext:managedObjectContext];
    
    return [self updateWithDictionary:ary class:managedClass.class entity:entity];
}


+(NSMutableArray*)updateWithDictionary:(NSArray*)ary class:(Class)managedClass entity:(NSEntityDescription*)entity{
    //introspect managed object
    Class class = managedClass;//[self class];
    NSMutableDictionary* moProperties = [@{} mutableCopy];
    
    while (class != [NSManagedObject class]) {
        unsigned int propertyCount;
        objc_property_t *properties = class_copyPropertyList(class, &propertyCount);
        
        //loop over the class properties
        for (unsigned int i = 0; i < propertyCount; i++) {
            objc_property_t property = properties[i];
            const char *propertyName = property_getName(property);
            
            const char *attrs = property_getAttributes(property);
            NSString* propertyAttributes = [NSString stringWithUTF8String:attrs];
            NSScanner* scanner = [NSScanner scannerWithString: propertyAttributes];
            NSString* propertyType = nil;
            [scanner scanUpToString:@"T" intoString: nil];
            [scanner scanString:@"T" intoString:nil];
            
            //check if the property is an instance of a class
            if ([scanner scanString:@"@\"" intoString: &propertyType]) {
                
                [scanner scanUpToCharactersFromSet:[NSCharacterSet characterSetWithCharactersInString:@"\"<"]
                                        intoString:&propertyType];
            }
            
            moProperties[[NSString stringWithUTF8String:propertyName]] = NSClassFromString(propertyType);
        }
        
        free(properties);
        class = [class superclass];
    }
    
    
    //read the json
    NSMutableArray* managedObjectAry = [[NSMutableArray alloc] init];
    for(id dictionary in ary){
        NSManagedObject* managedObject = [[managedClass alloc] initWithEntity:entity insertIntoManagedObjectContext:nil];
//    JSONModelError* initError = nil;   
//        id dictionary = [NSJSONSerialization JSONObjectWithData:[jsonStr dataUsingEncoding:NSUTF8StringEncoding]
//                                                 options:kNilOptions
//                                                   error:&initError];
        
        NSError* error;
        //validate dictionary keys
        NSArray* dictionaryKeys = [dictionary allKeys];
        for (NSString* key in [moProperties allKeys]) {
            if (![dictionaryKeys containsObject:key]) {
                //unmatched key
                if (error) {
    //                *error = [JSONModelError errorInvalidDataWithTypeMismatch:[NSString stringWithFormat: @"Key \"%@\" not found in manged object's property list", key]];
                    NSLog(@"error:%@", error.localizedDescription);
                }
//                return NO;
            }
        }

        //copy values over
        for (NSString* key in [moProperties allKeys]) {
            id value = dictionary[key];
            NSLog(@"class: %@", moProperties[key]);
            //exception classes - for core data should be NSDate by default
            if ([[moProperties[key]class] isEqual:[NSDate class]]) {
                if ([self respondsToSelector:@selector(NSDateFromNSString:)]) {
    #pragma clang diagnostic push
    #pragma clang diagnostic ignored "-Warc-performSelector-leaks"
                    //transform the value
                    value = [self performSelector:@selector(NSDateFromNSString:) withObject:dictionary[key]];
    #pragma clang diagnostic pop
                } else {
                    value = [self __NSDateFromNSString: dictionary[key]];
                }
            }
            
            //copy the value to the managed object
            [managedObject setValue:value forKey:key];
        }
        [managedObjectAry addObject:managedObject];
    }
    
    return managedObjectAry;
}

#pragma mark - string <-> date
+(NSDate*)__NSDateFromNSString:(NSString*)string
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    string = [string stringByReplacingOccurrencesOfString:@":" withString:@""]; // this is such an ugly code, is this the only way?
    [dateFormatter setDateFormat:@"yyyy-MM-dd'T'HHmmssZZZZ"];
    
    return [dateFormatter dateFromString: string];
}

@end
