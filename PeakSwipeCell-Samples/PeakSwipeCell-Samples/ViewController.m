//
//  ViewController.m
//  PeakSwipeCell-Samples
//
//  Created by conis on 9/14/13.
//  Copyright (c) 2013 conis. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()
@property (strong, nonatomic) IBOutlet UITableView *mainTable;
@end

@implementation ViewController
static NSInteger kTagTitle = 101;
static NSInteger kTagRemove = 102;

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
  return 10;
}

-(UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
  static NSString *kStaticCell = @"cell";
  PeakSwipeCell *cell = [tableView dequeueReusableCellWithIdentifier: kStaticCell];
  if (cell == nil) {
    cell = [[PeakSwipeCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:kStaticCell];
    cell.delegate = self;
    
    //添加文本的label，不能使用cell.titleLabel
    UILabel *label = [[UILabel alloc] initWithSize: CGSizeMake(320, 44)];
    label.tag = kTagTitle;
    cell.activeLength = 80;
    [cell.bodyPanel addSubview: label];
    
    //添加删除按钮
    UIButton *btnRemove = [UIButton buttonWithType: UIButtonTypeCustom];
    [btnRemove setImage:[UIImage imageNamed:@"remove_25"] forState:UIControlStateNormal];
    btnRemove.frame = CGRectMake(10, 10, 25, 25);
    btnRemove.userInteractionEnabled = NO;
    btnRemove.tag = kTagRemove;
    [cell.rightPanel addSubview: btnRemove];
    
    //[cell attachFollower: btnRemove];
  }
  
  UILabel *lblTitle = (UILabel*)[cell.bodyPanel viewWithTag: kTagTitle];
  lblTitle.text = [NSString stringWithFormat:@"This is cell %d", indexPath.row];
  return cell;
}

#pragma mark PeakSwipeCell的委托
-(BOOL) peakSwipeCell:(PeakSwipeCell *)cell swipeShouldBeginWithDirection:(PeakSwipeDirection)direction{
  //只允许向右划动
  return direction == PeakSwipeDirectionRight;
}

-(BOOL) peakSwipeCell:(PeakSwipeCell *)cell swipingWithDirection:(PeakSwipeDirection)direction length:(CGFloat)length{
  if(direction == PeakSwipeDirectionRight){
    UIView *view = [cell.rightPanel viewWithTag: kTagRemove];
    [cell followSwipe:view length:length direction:direction offset: -10];
  }
  
  return direction == PeakSwipeDirectionRight;
}

-(void) peakSwipeCell:(PeakSwipeCell *)cell swipeDidFinish:(PeakSwipeDirection)direction length:(CGFloat)length{
  if(length > cell.activeLength){
    NSLog(@"删除这一条");
  }
}
@end
