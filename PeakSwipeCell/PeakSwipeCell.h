//
//  UITask.h
//  Pastime
//
//  Created by conis on 7/1/13.
//  Copyright (c) 2013 conis. All rights reserved.
//

/*
划动的cell
 */
#import <UIKit/UIKit.h>
#import "UIView+Helpers.h"


@protocol PeakSwipeCellDelegate;

typedef enum {
  PeakSwipeDirectionLeft,
  PeakSwipeDirectionRight
}PeakSwipeDirection;

@interface PeakSwipeCell : UITableViewCell<UIGestureRecognizerDelegate>

//委托
@property (nonatomic, weak) id<PeakSwipeCellDelegate> delegate;
//右划
@property (nonatomic, strong, readonly) UIView *rightPanel;
//左划
@property (nonatomic, strong, readonly) UIView *leftPanel;
//内容的panel
@property (nonatomic, strong, readonly) UIView *bodyPanel;
//菜单的Panel
@property (nonatomic, strong, readonly) UIView *menuPanel;
//激活时rightPanel的颜色
@property (nonatomic, strong) UIColor *rightPanelActiveColor;
//默认rightPanel的颜色
@property (nonatomic, strong) UIColor *rightPanelNormalColor;
//激活时leftPanel的颜色
@property (nonatomic, strong) UIColor *leftPanelActiveColor;
//默认leftPanel的颜色
@property (nonatomic, strong) UIColor *leftPanelNormalColor;
//默认的菜单颜色
@property (nonatomic, strong) UIColor *menuPanelNormalColor;
//显示菜单的背景色
@property (nonatomic, strong) UIColor *menuPanelActiveColor;
//设置单元格的padding
@property (nonatomic) UIEdgeInsets padding;
//触发的大小
@property (nonatomic) UIEdgeInsets responseInset;
//最小触发需要划动的长度
@property (nonatomic) CGFloat activeLength;

//============================方法
//划动中
-(void) swiping: (CGFloat) length direction: (PeakSwipeDirection) direction availRange: (BOOL) availRange;
//划动结束
-(void) swiped: (CGFloat) length direction: (PeakSwipeDirection) direction availRange: (BOOL) availRange;
//将要划动
-(BOOL) swipeShouldBegin: (CGFloat) length direction: (PeakSwipeDirection) direction;
//取消划动
-(void) cancelSwipe: (CGFloat) length direction: (PeakSwipeDirection)direction;
//将一个uiView跟随划动
-(void) followSwipe: (UIView *) follower length: (CGFloat) length direction: (PeakSwipeDirection) direction offset: (CGFloat) offset;
//给划动添加一个follower，同时只能有一个folloer
-(void) attachFollower: (UIView *) follower;
//释放掉follower
-(void) detachFollower;
//显示/隐藏按钮
-(void) displayMenu: (BOOL) display;
//创建组件
-(void) createComponent;
//回滚到初始状态
-(void) rollback: (CGFloat) length direction: (PeakSwipeDirection) direction;
//单元格被点击
-(void) tapCell;
@end


//委托
@protocol PeakSwipeCellDelegate <NSObject>
//点击
-(void) peakSwipeCellDidTap: (PeakSwipeCell *) cell;
//划动结束
@end
