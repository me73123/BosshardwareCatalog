//
//  NewsListDelegate.m
//  Youngcatalog
//
//  Created by honlun on 2014/8/16.
//  Copyright (c) 2014年 honlun. All rights reserved.
//

#import "NewsListDelegate.h"
#import "News.h"
#import "iToast.h"

@implementation NewsListDelegate{
    NSDateFormatter *formatter;
}

-(id) initWithController:(UIViewController*)myContext TableView:(UITableView *)myTableView list:(NSArray*)mylist{
    self = [super initWithController:myContext TableView:myTableView list:mylist];
    if(!self) return self;
    formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:UPDATE_DATE_DATEFORMAT];
    return self;
}

//去除warning用
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"NewsCell"];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"MovieCell"];
    }
    News* vo = [self.list objectAtIndex:indexPath.row];
    UILabel* lb_title = (UILabel*) [cell viewWithTag:101];
    UILabel* lb_time = (UILabel*) [cell viewWithTag:102];

    lb_title.text = vo.title;
    lb_time.text = [formatter stringFromDate:vo.updateDate];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    News* vo = [self.list objectAtIndex:indexPath.row];
    if(![TextUtils isEmpty:vo.link]){
        if(![[UIApplication sharedApplication] openURL:[NSURL URLWithString:vo.link]]){
            [[[[iToast makeText:NSLocalizedString(@"toast_open_url_fail",nil)] setGravity:iToastGravityBottom] setDuration:iToastDurationNormal] show];
        }
    }
}
@end
