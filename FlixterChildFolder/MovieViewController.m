//
//  MovieViewController.m
//  Flixter
//
//  Created by Nikolas Georgaklis on 6/15/22.
//

#import "MovieViewController.h"
#import "MovieTableViewCell.h"
#import "MovieCell.h"
#import "UIImageView+AFNetworking.h"
#import "DetailsViewController.h"

@interface MovieViewController () <UITableViewDataSource, UITableViewDelegate >
@property (weak, nonatomic) IBOutlet UITableView *TableView;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *loadingState;
@property (nonatomic, strong) NSArray *myArray;

@end

@implementation MovieViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    UIRefreshControl *refreshControl = [[UIRefreshControl alloc] init];
    [refreshControl addTarget:self action:@selector(beginRefresh:) forControlEvents:UIControlEventValueChanged];
    [self.TableView insertSubview:refreshControl atIndex:0];

    self.TableView.dataSource = self;
    self.TableView.delegate = self;
     
    // Do any additional setup after loading the view.
    [self.loadingState startAnimating];
    //Create URL
    NSURL *url = [NSURL URLWithString:@"https://api.themoviedb.org/3/movie/now_playing?api_key=5f523bf7408765f7b6896198ddd95c17"];
    
    //create request
    NSURLRequest *request = [NSURLRequest requestWithURL:url cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:10.0];
    
    //create session
    NSURLSession *session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration] delegate:nil delegateQueue:[NSOperationQueue mainQueue]];
    
    //Create session task
    NSURLSessionDataTask *task = [session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
           if (error != nil) {
               NSLog(@"%@", [error localizedDescription]);
               UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"Cannot Get Movies" message:@"The Internet connection appears to be offline." preferredStyle:(UIAlertControllerStyleAlert)];
               UIAlertAction *retryAction = [UIAlertAction actionWithTitle:@"Try Again" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action){
                   [self viewDidLoad];
               }];
               [alert addAction:retryAction];
               [self presentViewController:alert animated:YES completion:^{}];
           }
           else {
               NSDictionary *dataDictionary = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
               
               //Store movie results in myArray
               self.myArray = dataDictionary[@"results"];
               
//               NSLog(@"%@", myArray);// log an object with the %@ formatter.

               [self.TableView reloadData];
               [self.loadingState stopAnimating];
               // TODO: Get the array of movies
               // TODO: Store the movies in a property to use elsewhere
               // TODO: Reload your table view data
           }
       }];
    [task resume];

}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.myArray.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *) indexPath{
    
    MovieCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MovieCell"];
    
    NSDictionary *movie = self.myArray[indexPath.row];
    cell.titleLabel.text = movie[@"title"];
    cell.synopsisLabel.text = movie[@"overview"];
    
    NSString *baseURLString = @"https://image.tmdb.org/t/p/w500";
    NSString *posterURLString = movie[@"poster_path"];
    NSString *fullPosterURLString = [baseURLString stringByAppendingString:posterURLString];
    
    NSURL *posterURL =[NSURL URLWithString:fullPosterURLString];
    [cell.posterView setImageWithURL:posterURL];
    
    return cell;
}

- (void)beginRefresh:(UIRefreshControl *)refreshControl {

        // Create NSURL and NSURLRequest
    
    //Create URL
    NSURL *url = [NSURL URLWithString:@"https://api.themoviedb.org/3/movie/now_playing?api_key=5f523bf7408765f7b6896198ddd95c17"];
    
    //create request
    NSURLRequest *request = [NSURLRequest requestWithURL:url cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:10.0];

    NSURLSession *session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]
                                                              delegate:nil
                                                         delegateQueue:[NSOperationQueue mainQueue]];
        session.configuration.requestCachePolicy = NSURLRequestReloadIgnoringLocalCacheData;
    
    //Create session task
    NSURLSessionDataTask *task = [session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
           if (error != nil) {
               NSLog(@"%@", [error localizedDescription]);
           }
           else {
               NSDictionary *dataDictionary = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
               //NSLog(@"%@", dataDictionary);// log an object with the %@ formatter.
               
               //Store movie results in myArray
               self.myArray = dataDictionary[@"results"];
               
//               NSLog(@"%@", myArray);// log an object with the %@ formatter.
               
               // Reload the tableView now that there is new data
               [self.TableView reloadData];
               // TODO: Get the array of movies
               // TODO: Store the movies in a property to use elsewhere
               // TODO: Reload your table view data
           }
      
    
           // ... Use the new data to update the data source ...


           // Tell the refreshControl to stop spinning
            [refreshControl endRefreshing];

        }];
    
        [task resume];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    NSIndexPath *index = [self.TableView indexPathForCell:sender];
    NSDictionary *movie = self.myArray[index.row];
    DetailsViewController *detailsVC = [segue destinationViewController];
    detailsVC.movie = movie;
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
