//
//  WebViewController.m
//  Flix
//
//  Created by Jamie Tan on 6/29/18.
//  Copyright © 2018 jamietan. All rights reserved.
//

#import "WebViewController.h"
#import <WebKit/WebKit.h>

@interface WebViewController ()
@property (weak, nonatomic) IBOutlet WKWebView *webView;
@property (strong, nonatomic) NSString *trailerURLString;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;
@property (weak, nonatomic) IBOutlet UIButton *closeButton;

@end

@implementation WebViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    // Convert the url String to a NSURL object.
    [self.activityIndicator startAnimating];
    [self fetchTrailer];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) fetchTrailer {
    NSString *getTrailerURlString = [NSString stringWithFormat:@"https://api.themoviedb.org/3/movie/%@/videos?api_key=a07e22bc18f5cb106bfe4cc1f83ad8ed&language=en-US", self.movieID];
    
    NSURL *apiURL = [NSURL URLWithString:getTrailerURlString];
    NSURLRequest *request = [NSURLRequest requestWithURL:apiURL cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:10.0];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration] delegate:nil delegateQueue:[NSOperationQueue mainQueue]];
    NSURLSessionDataTask *task = [session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        if (error != nil) {
            NSLog(@"%@", [error localizedDescription]);
            
        }
        else {
            NSDictionary *dataDictionary = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
            NSDictionary *trailer = dataDictionary[@"results"][0];
            self.trailerURLString = [@"https://www.youtube.com/watch?v=" stringByAppendingString: trailer[@"key"]];
            
            NSURL *trailerURL = [NSURL URLWithString:self.trailerURLString];
            
            // Place the URL in a URL Request.
            NSURLRequest *request = [NSURLRequest requestWithURL:trailerURL cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:10.0];
            // Load Request into WebView.
            [self.webView loadRequest:request];
            
            [self.activityIndicator stopAnimating];
        }
    }];
    
    [task resume];
}

-(IBAction)closeButton:(UIButton *)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
