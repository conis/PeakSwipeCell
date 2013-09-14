//
//  UITask.m
//  Pastime
//
//  Created by conis on 7/1/13.
//  Copyright (c) 2013 conis. All rights reserved.
//

#import "PeakSwipeCell.h"
@interface PeakSwipeCell()
//开始划动
@property (nonatomic) CGFloat dragStart;
@end

@implementation PeakSwipeCell

#pragma mark 初始化
- (id)init
{
	self = [super init];
  if (self) {
		[self createComponent];
  }
  return self;
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
	self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
  if (self) {
		[self createComponent];
  }
  return self;
}

- (id)initWithFrame:(CGRect)frame
{
  self = [super initWithFrame:frame];
  if (self) {
    [self createComponent];
  }
  return self;
}

- (id) initWithCoder:(NSCoder *)aDecoder
{
  self = [super initWithCoder: aDecoder];
  if(self){
    [self createComponent];
  }
  return self;
}

-(void) layoutSubviews{
  [super layoutSubviews];
  self.leftPanel.frame = self.rightPanel.frame = self.bodyPanel.frame = self.menuPanel.frame = self.contentView.bounds;
  self.menuPanel.frameOriginX = - self.contentView.frameSizeWidth;
}

//设置默认值
-(void) setDefaults{
  self.responseInset = UIEdgeInsetsMake(-20, -20, -50, -50);
  self.menuPanelNormalColor = [UIColor whiteColor];
  self.menuPanelActiveColor = [UIColor whiteColor];
  self.leftPanelNormalColor = [UIColor grayColor];
  self.rightPanelNormalColor = [UIColor grayColor];
  self.leftPanelActiveColor = [UIColor orangeColor];
  self.rightPanelActiveColor = [UIColor redColor];
  self.padding = UIEdgeInsetsZero;
  self.activeLength = 50;
}

//创建按钮
-(void) createMenu{
  _menuPanel = [[UIView alloc] initWithSize: self.contentView.frameSize];
  self.menuPanel.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
  self.menuPanel.frameOriginX = -self.contentView.frameSizeWidth;
  self.menuPanel.frameSizeHeight = self.contentView.frameSizeHeight;
  [self.contentView addSubview: self.menuPanel];
}


//右划显示左panel
-(void) createRightPanel{
  UIView *panel = _rightPanel = [[UIView alloc] init];
  panel.hidden = YES;
  panel.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
  [self.contentView addSubview: panel];
}

//创建左划的panel
-(void) createLeftPanel{
  UIView *panel = _leftPanel = [[UIView alloc] init];
  panel.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
  panel.hidden = YES;
  [self.contentView addSubview: panel];
}

//创建组件
-(void) createComponent{
  //初始化值
  [self setDefaults];
  self.accessoryType = UITableViewCellAccessoryNone;
  self.selectionStyle = UITableViewCellSelectionStyleNone;
  
  //创建左右划动的panel，顺序很重要
  [self createLeftPanel];
  [self createRightPanel];
  
  //创建右边的内容区
  _bodyPanel = [[UIView alloc] init];
  self.bodyPanel.backgroundColor = [UIColor whiteColor];
  self.bodyPanel.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
  [self.contentView addSubview:self.bodyPanel];
  
  [self createMenu];
  
  //给self.bodyPanel添加点击的手势
  UITapGestureRecognizer* tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action: @selector(tapAction:)];
  [self.bodyPanel addGestureRecognizer:tapGesture];
  
  //给contentView添加划动的手式
  UIPanGestureRecognizer *panGesture=[[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(panAction:)];
  [self.bodyPanel addGestureRecognizer:panGesture];
  panGesture.delegate = self;
}

#pragma mark 调整布局
//显示按钮，子类可有必要可以重载
-(void) displayMenu:(BOOL)display{
  self.menuPanel.backgroundColor = display ? self.menuPanelActiveColor : self.menuPanelNormalColor;
  CGFloat left = display ? 0 : -self.contentView.frameSizeWidth;

  
  [UIView animateWithDuration:0.25 delay:0
                      options:UIViewAnimationOptionCurveLinear
                   animations:^{
                     self.menuPanel.center = CGPointMake(left, self.bodyPanel.center.y);
                     } completion:^(BOOL finished) {
                       //none
                   }];
}

#pragma mark 手势委托相关
//点击这个view的操作
-(void) tapAction:(UITapGestureRecognizer *)gesture{
  [self tapCell];
}

//开始划动
-(void) panAction:(UIPanGestureRecognizer *)gesture{
  //位置
  CGPoint translatedPoint = [gesture translationInView:self];
  CGPoint locationPoint = [gesture locationInView:self];
  
  //手势的状态
	switch (gesture.state)
	{
		case UIGestureRecognizerStatePossible:
			
			break;
      //开始
		case UIGestureRecognizerStateBegan:
      //记录开始的位置
			self.dragStart = gesture.view.center.x;
			break;
      //被改变
		case UIGestureRecognizerStateChanged:
      [self swiping:translatedPoint location: locationPoint];
			break;
		case UIGestureRecognizerStateEnded:
      //结束划动
      [self endSwipe:translatedPoint location: locationPoint];
      break;
		case UIGestureRecognizerStateCancelled:
			//NSLog(@"被取消");
			break;
		case UIGestureRecognizerStateFailed:
			
			break;
	}
}

//划动中
-(void) swiping: (CGPoint) point location: (CGPoint) location{
  CGFloat length = fabs(point.x);
  PeakSwipeDirection direction = [self gestureDirection:point.x];
  
  //请问委托是否可以继续划动
  if(self.delegate && [self.delegate respondsToSelector:@selector(peakSwipeCell:swipingWithDirection:length:)]){
    if(![self.delegate peakSwipeCell:self swipingWithDirection:direction length:length]) return;
  }
  //移动contentPanel
  self.bodyPanel.center = CGPointMake(self.dragStart + point.x, self.bodyPanel.center.y);
  
  //判断显示哪一个层
  [self swiping: length
      direction:direction
     availRange:[self inMaxRange:location]];
}

//划动中
-(void) swiping:(CGFloat)length direction:(PeakSwipeDirection)direction availRange:(BOOL)availRange{
  //设置背景及颜色
  self.leftPanel.backgroundColor = length < self.activeLength ? self.leftPanelNormalColor : self.leftPanelActiveColor;
  self.rightPanel.backgroundColor = length < self.activeLength ? self.rightPanelNormalColor : self.rightPanelActiveColor;
  self.rightPanel.hidden = direction == PeakSwipeDirectionLeft;
  self.leftPanel.hidden = direction == PeakSwipeDirectionRight;
}

//划动的时候，跟随view
-(void) followSwipe:(UIView *)follower length:(CGFloat)length direction:(PeakSwipeDirection)direction offset:(CGFloat)offset{
  BOOL isLeft = direction == PeakSwipeDirectionLeft;
    
  CGFloat left, minLeft;
  if(isLeft){
    left = self.contentView.frameSizeWidth - length + offset;
    minLeft = self.contentView.frameSizeWidth;
    left = fminf(left, minLeft);
  }else{
    minLeft = offset;
    left = length - follower.frameSizeWidth + offset;
    //left = fmaxf(left, minLeft);
  }
  
  follower.frameOriginX = left;
}

//是否在最大范围
-(BOOL) inMaxRange: (CGPoint) location{
  //x与y是否在允许的范围内
  CGRect maxRect = UIEdgeInsetsInsetRect(self.contentView.bounds, self.responseInset);
  //NSLog(NSStringFromCGRect(maxRect));
  return CGRectContainsPoint(maxRect, location);
}

//划动完成
-(void) endSwipe: (CGPoint) point location:(CGPoint) location{
  CGFloat length = fabs(point.x);
  BOOL availRange = [self inMaxRange:location];
  //撤消
  if(availRange){
    PeakSwipeDirection direction = [self gestureDirection: point.x];
    //回滚
    [self rollback:length direction:direction];
    //调用划动完成
    [self swiped:length direction: direction availRange:availRange];
  }else{
    [self cancelSwipe:length direction:[self gestureDirection:point.x]];
  }
}

//结束划动
-(void) swiped:(CGFloat)length direction:(PeakSwipeDirection)direction availRange:(BOOL)availRange{
  if(self.delegate && [self.delegate respondsToSelector:@selector(peakSwipeCell:swipeDidFinish:length:)]){
    [self.delegate peakSwipeCell:self swipeDidFinish:direction length:length];
  }
}

//获取划动的方向
-(PeakSwipeDirection) gestureDirection: (CGFloat) x{
  return x > 0 ? PeakSwipeDirectionRight : PeakSwipeDirectionLeft;
}

//将要划动
- (BOOL)gestureRecognizerShouldBegin:(UIPanGestureRecognizer *)gestureRecognizer
{
  //非UIPanGestureRecognizer，都返回YES
  if (![gestureRecognizer isKindOfClass:[UIPanGestureRecognizer class]])
		return YES;
  
  UIView *view = [gestureRecognizer view];
  CGPoint translation = [gestureRecognizer translationInView:[view superview]];
  //NSLog(@"x: %0f, y: %0f", translation.x, translation.y);
  CGFloat absX = fabsf(translation.x), absY = fabsf(translation.y);
  //检查是否为垂直划动
  if (absX <= absY) return NO;
  
	return [self swipeShouldBegin: fabs(translation.x)
                      direction:[self gestureDirection: translation.x ]];
}


//是否能划动开始，子类重载处理
-(BOOL) swipeShouldBegin:(CGFloat)length direction:(PeakSwipeDirection)direction{
  if(self.delegate && [self.delegate respondsToSelector:@selector(peakSwipeCell:swipeShouldBeginWithDirection:)]){
    return [self.delegate peakSwipeCell:self swipeShouldBeginWithDirection:direction];
  }
  return YES;
}

//撤消划动
-(void) cancelSwipe:(CGFloat)length direction:(PeakSwipeDirection)direction{
  //回滚
  [self rollback:length direction:direction];
}

//回滚
-(void) rollback:(CGFloat)length direction:(PeakSwipeDirection)direction{
  [UIView animateWithDuration:0.25 delay:0
                      options:UIViewAnimationOptionCurveLinear
                   animations:^{
                     self.bodyPanel.center = CGPointMake(self.dragStart, self.contentView.center.y);
                   } completion:^(BOOL finished) {
                     if(finished){
                       //self.dragStart = CGFLOATself.MIN;
                       self.leftPanel.alpha = 1;
                       self.rightPanel.alpha = 1;
                       self.leftPanel.hidden = YES;
                       self.rightPanel.hidden = YES;
                     }
                   }];
}

@end
