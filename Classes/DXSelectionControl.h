//
//  SelectionControl.h
//  recipeHD
//
//  Created by 徐 东 on 14-3-27.
//  Copyright (c) 2014年 RuidiInteractive. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol DXSelectionControlInterface <NSObject>

#pragma mark - get selection info
@property (strong,nonatomic,readonly) NSSet *selectedIndexes;

#pragma mark - configure
@property (strong,nonatomic) NSArray *selectables;
@property (assign,nonatomic) BOOL singleSelection;
@property (assign,nonatomic) BOOL canCancelSelection;
@property (assign,nonatomic) BOOL allowNoneSelection;
@property (copy,nonatomic) void(^selectionChangedBlock)(id<DXSelectionControlInterface> control, NSInteger index,BOOL selecting);

#pragma mark - handle selection
- (void)deselectAllSelectables;
- (void)deselectAllSelectablesExceptForIndex:(NSInteger)index;
- (void)deselectAllSelectablesExceptForSelectable:(id)obj;
- (void)deselectSelectable:(id)selectable;
- (void)deselectSelectableWithIndex:(NSInteger)index;
- (void)selectSelectable:(id)obj;
- (void)selectSelectableWithIndex:(NSUInteger)index;

@end

@protocol DXSelectable <NSObject>

@property (nonatomic,getter=isSelected) BOOL selected;
@property (nonatomic) NSInteger tag;

- (void)addUserInteractionTarget:(id)target action:(SEL)action;
- (void)removeUserInteractionTarget:(id)target action:(SEL)action;

@end

@interface UIControl (DXSelectable)<DXSelectable>

@end

@implementation UIControl (DXSelectable)

- (void)addUserInteractionTarget:(id)target action:(SEL)action
{
    [self addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
}

- (void)removeUserInteractionTarget:(id)target action:(SEL)action
{
    [self removeTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
}

@end

@interface DXSelectionControl : NSObject<DXSelectionControlInterface>

@property (strong,nonatomic) IBOutletCollection(UIControl) NSArray *selectables;
//redeclaration
- (void)deselectAllSelectablesExceptForSelectable:(id<DXSelectable>)obj;
- (void)deselectSelectable:(id<DXSelectable>)selectable;
- (void)selectSelectable:(id<DXSelectable>)obj;

@end
