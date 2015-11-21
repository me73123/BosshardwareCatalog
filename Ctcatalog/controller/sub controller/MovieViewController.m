//
//  MovieViewController.m
//  Youngcatalog
//
//  Created by honlun on 2014/7/19.
//  Copyright (c) 2014年 honlun. All rights reserved.
//

#import "MovieViewController.h"
#import "MovieListDelegate.h"

@interface MovieViewController ()
@property (weak, nonatomic) IBOutlet UILabel *lb_title;
@property (weak, nonatomic) IBOutlet UITableView *tv_movie;

@end

@implementation MovieViewController{
    NSArray* movieAry;
    MovieListDelegate* movieListDelegate;
    LoadingViewController* loadingCtrl;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self loadString];
    movieAry = [[NSArray alloc] init];
    movieListDelegate = [[MovieListDelegate alloc] initWithController:self TableView:self.tv_movie list:movieAry];
    self.tv_movie.delegate = movieListDelegate;
    self.tv_movie.dataSource = movieListDelegate;
    //用全域變數,不然螢幕旋轉會有問題
    loadingCtrl = [LoadingViewController createLoadingViewController:NSLocalizedString(@"loading",nil)];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self getMovies];
}
#pragma mark - ui
-(void)loadString{
    [self setCommonText:self.lb_title text:NSLocalizedString(@"movie", nil)];
}

#pragma mark - api
-(void) getMovies{
    //顯示loading
    if(loadingCtrl != nil){
        [loadingCtrl close];
    }
    [loadingCtrl showLoadingView:self];
    id<MovieBusiness> movieBiz = [BusinessGetter getMovieBusiness];
    [movieBiz getMovies:^(ApiOutMovie *apiOut, NSError *error) {
        [loadingCtrl close];
        if(error==nil){
            if(apiOut!=nil && [apiOut.resultcode isEqualToString:@"200"]){
                if(apiOut.movieList!=nil){
                    movieAry = apiOut.movieList;
                    [movieListDelegate reloadDataWithTableView:self.tv_movie list:movieAry];
                }else{
                    NSLog(@"getMovies movieList is null");
                    [[[[iToast makeText:NSLocalizedString(@"toast_update_movie_fail",nil)] setGravity:iToastGravityBottom] setDuration:iToastDurationNormal] show];
                }
            }else{
                NSLog(@"getMovies apiOut is null or resultcode not 200");
                [[[[iToast makeText:NSLocalizedString(@"toast_update_movie_fail",nil)] setGravity:iToastGravityBottom] setDuration:iToastDurationNormal] show];
            }
        }else{
            NSLog(@"getMovies error:%@", error.localizedDescription);
            [[[[iToast makeText:NSLocalizedString(@"toast_update_movie_fail",nil)] setGravity:iToastGravityBottom] setDuration:iToastDurationNormal] show];
        }
    }];
}

#pragma mark - system
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}
@end
