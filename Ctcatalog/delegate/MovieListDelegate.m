//
//  MovieListDelegate.m
//  Youngcatalog
//
//  Created by honlun on 2014/8/16.
//  Copyright (c) 2014年 honlun. All rights reserved.
//

#import "MovieListDelegate.h"
#import "Movie.h"
#import "MediaPlayer/MediaPlayer.h"
#import "iToast.h"

@implementation MovieListDelegate{
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
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MovieCell"];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"MovieCell"];
    }
    Movie* vo = [self.list objectAtIndex:indexPath.row];
    UILabel* lb_title = (UILabel*) [cell viewWithTag:101];
    UILabel* lb_time = (UILabel*) [cell viewWithTag:102];
    lb_title.text = vo.title;
    lb_time.text = [formatter stringFromDate:vo.updateDate];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    Movie* vo = [self.list objectAtIndex:indexPath.row];
    if(![TextUtils isEmpty:vo.videoid]){
        NSString* url = [NSString stringWithFormat:@"http://www.youtube.com/watch?v=%@", vo.videoid];
        if(![[UIApplication sharedApplication] openURL:[NSURL URLWithString:url]]){
            [[[[iToast makeText:NSLocalizedString(@"toast_open_url_fail",nil)] setGravity:iToastGravityBottom] setDuration:iToastDurationNormal] show];
        }
    }
    
//    MPMoviePlayerController *m_player;
//    MPVolumeView *m_volumeView;
//
//    MPMoviePlayerController *player = [[MPMoviePlayerController alloc] initWithContentURL:[NSURL URLWithString:url]];
//    player.scalingMode = MPMovieScalingModeAspectFit;  //適合營幕大小
//    m_player.repeatMode = MPMovieRepeatModeNone;  //重複
//    player.controlStyle = MPMovieControlStyleEmbedded;  //控制列
//    player.view.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
//
//    m_player.view.frame = CGRectMake(0, 0, self.context.view.frame.size.width, self.context.view.frame.size.height);
//    [self.context.view addSubview:m_player.view];
//    
//    //設定接收廣播通知,接收結束通知
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onMoviePlayBackDidFinish:) name:MPMoviePlayerPlaybackDidFinishNotification object:m_player];
//    
//    //準備影片
//    [m_player prepareToPlay];
//    [m_player play];
//    
//    //產生控制器
//    m_volumeView = [[MPVolumeView alloc] initWithFrame:CGRectMake(0, self.context.view.frame.size.height-60, self.context.view.frame.size.width, 40)];
//    m_volumeView.showsVolumeSlider = YES;
//    [self.context.view addSubview:m_volumeView];
}

//#pragma mark - Listener & CallBack
////----CallBack & Lestener--------------------------------------------------------------------
//-(void) onMoviePlayBackDidFinish:(NSNotification*)notification{
//    NSDictionary *userInfo = [notification userInfo];
//    int reason = [[userInfo objectForKey:@"MPMovieFinishReasonPlaybackError"] intValue];
//    if(reason == MPMovieFinishReasonPlaybackEnded){
//        NSLog(@"播放完畢");
//    }else if(reason == MPMovieFinishReasonPlaybackError){
//        NSLog(@"Error");
//    }else if(reason == MPMovieFinishReasonUserExited){
//        NSLog(@"按下螢幕的Done鈕結束影片");
//    }
//}
@end
