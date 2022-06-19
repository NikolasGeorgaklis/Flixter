//
//  GridViewController.m
//  Flixter
//
//  Created by Nikolas Georgaklis on 6/19/22.
//

#import "GridCell.h"
#import "UIImageView+AFNetworking.h"
#import "DetailsViewController.h"
#import "GridViewController.h"

@interface GridViewController () <UICollectionViewDataSource, UICollectionViewDelegate>
@property (strong, nonatomic) IBOutlet UICollectionView *gridView;
@property (strong, nonatomic) NSArray *myArray;
@end

@implementation GridViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    UIRefreshControl *refreshControl = [[UIRefreshControl alloc] init];
    [refreshControl addTarget:self action:@selector(beginRefresh:) forControlEvents:UIControlEventValueChanged];
    [self.gridView insertSubview:refreshControl atIndex:0];

    self.gridView.dataSource = self;
    self.gridView.delegate = self;
     
    // Do any additional setup after loading the view.
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

               [self.gridView reloadData];
               // TODO: Get the array of movies
               // TODO: Store the movies in a property to use elsewhere
               // TODO: Reload your table view data
           }
       }];
    [task resume];

}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.myArray.count;
}


- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    GridCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"GridCell" forIndexPath:indexPath];
    
    NSDictionary *movie = self.myArray[indexPath.row];
    
    NSString *baseURLString = @"https://image.tmdb.org/t/p/w500";
    NSString *posterURLString = movie[@"poster_path"];
    NSString *fullPosterURLString = [baseURLString stringByAppendingString:posterURLString];
    
    NSURL *posterURL =[NSURL URLWithString:fullPosterURLString];
    [cell.posterImg setImageWithURL:posterURL];
    
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
               [self.gridView reloadData];
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
    NSIndexPath *index = [self.gridView indexPathForCell:sender];
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
