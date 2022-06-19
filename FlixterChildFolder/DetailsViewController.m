//
//  DetailsViewController.m
//  Flixter
//
//  Created by Nikolas Georgaklis on 6/17/22.
//

#import "DetailsViewController.h"
#import "MovieViewController.h"
#import "MovieTableViewCell.h"
#import "MovieCell.h"
#import "UIImageView+AFNetworking.h"
#import "DetailsViewController.h"

@interface DetailsViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *poster;
@property (weak, nonatomic) IBOutlet UIImageView *backdrop;
@property (weak, nonatomic) IBOutlet UILabel *movieTitle;
@property (weak, nonatomic) IBOutlet UILabel *synopsis;

@end

@implementation DetailsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.movieTitle.text = self.movie[@"title"];
    self.synopsis.text = self.movie[@"overview"];

    
    NSString *baseURLString = @"https://image.tmdb.org/t/p/w500";
    NSString *posterURLString = self.movie[@"poster_path"];
    NSString *fullPosterURLString = [baseURLString stringByAppendingString:posterURLString];
    
    NSURL *posterURL =[NSURL URLWithString:fullPosterURLString];
    [self.poster setImageWithURL:posterURL];
    
    NSString *backdropURLString = self.movie[@"backdrop_path"];
    NSString *fullbackdropURLString = [baseURLString stringByAppendingString:backdropURLString];
    
    NSURL *backdropURL =[NSURL URLWithString:fullbackdropURLString];
    [self.backdrop setImageWithURL:backdropURL];
    // Do any additional setup after loading the view.
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
