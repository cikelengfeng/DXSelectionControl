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
/**
 *  @author DeanXu, 15-02-28 16:02:05
 *
 *  used for sorting selectables
 */
@property (nonatomic) NSInteger tag;

/**
 *  @author DeanXu, 15-02-28 15:02:37
 *
 *  it's selectable's duty to perform action on target while selectable wants to toggle 'selected' state
 *
 */
- (void)addUserInteractionTarget:(id)target action:(SEL)action;
- (void)removeUserInteractionTarget:(id)target action:(SEL)action;

@end
/**
 *  @author DeanXu, 15-02-28 16:02:17
 *
 *  UIControl supports DXSelectable interface
 *
 */
@interface UIControl (DXSelectable)<DXSelectable>

@end

@interface DXSelectionControl : NSObject<DXSelectionControlInterface>

@property (strong,nonatomic) IBOutletCollection(id) NSArray *selectables;
//redeclaration
- (void)deselectAllSelectablesExceptForSelectable:(id<DXSelectable>)obj;
- (void)deselectSelectable:(id<DXSelectable>)selectable;
- (void)selectSelectable:(id<DXSelectable>)obj;

@end
