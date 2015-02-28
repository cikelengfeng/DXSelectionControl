//
//  SelectionControl.m
//  recipeHD
//
//  Created by 徐 东 on 14-3-27.
//  Copyright (c) 2014年 RuidiInteractive. All rights reserved.
//

#import "DXSelectionControl.h"

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

@interface DXSelectionControl ()

@property (strong,nonatomic) NSMutableSet *selectedIndexes;

- (void)setup;

@end

@implementation DXSelectionControl

@synthesize selectables = _selectables;
@synthesize selectionChangedBlock;
@synthesize selectedIndexes = _selectedIndexes;
@synthesize singleSelection = _singleSelection;
@synthesize canCancelSelection = _canCancelSelection;
@synthesize allowNoneSelection = _allowNoneSelection;

- (id)init
{
    self = [super init];
    if (self) {
        [self setup];
    }
    return self;
}

- (void)setup
{
    _selectables = [_selectables sortedArrayUsingComparator:^NSComparisonResult(id<DXSelectable> obj1, id<DXSelectable> obj2) {
        NSInteger result = obj1.tag - obj2.tag;
        return result == 0 ? NSOrderedSame : result / ABS(result);
    }];
    [_selectables enumerateObjectsUsingBlock:^(id<DXSelectable> obj, NSUInteger idx, BOOL *stop) {
        [self trackTouchedInsideEventForControl:obj];
    }];
    _selectedIndexes = [NSMutableSet setWithCapacity:_selectables.count];
}

- (void)setSelectables:(NSArray *)selectables
{
    if (_selectables != selectables) {
        _selectables = selectables;
        [self setup];
    }
}


- (void)trackTouchedInsideEventForControl:(id<DXSelectable>)selectable
{
    [self untrackTouchedInsideEventForControl:selectable];
    [selectable addUserInteractionTarget:self action:@selector(onUserInteractWithSelectable:)];
}
- (void)untrackTouchedInsideEventForControl:(id<DXSelectable>)selectable
{
    [selectable removeUserInteractionTarget:self action:@selector(onUserInteractWithSelectable:)];
}
- (void)onUserInteractWithSelectable:(id<DXSelectable>)selectable
{
    if (selectable.selected) {
        [self deselectSelectable:selectable];
    }else {
        [self selectSelectable:selectable];
    }
}

- (void)notifySelectionChangedWithIndex:(NSUInteger)index
{
    if (self.selectionChangedBlock) {
        self.selectionChangedBlock(self,index,[self.selectedIndexes containsObject:@(index)]);
    }
}

#pragma mark - public API

- (void)deselectAllSelectables
{
    [self.selectables enumerateObjectsUsingBlock:^(id<DXSelectable>obj, NSUInteger idx, BOOL *stop) {
        [self deselectSelectableWithIndex:idx];
    }];
}

- (void)deselectAllSelectablesExceptForIndex:(NSInteger)index
{
    [self.selectables enumerateObjectsUsingBlock:^(id<DXSelectable>obj, NSUInteger idx, BOOL *stop) {
        if (index != idx) {
            [self deselectSelectableWithIndex:idx];
        }
    }];
}

- (void)deselectAllSelectablesExceptForSelectable:(id<DXSelectable>)selectable
{
    [self.selectables enumerateObjectsUsingBlock:^(id<DXSelectable>obj, NSUInteger idx, BOOL *stop) {
        if (![selectable isEqual:obj]) {
            [self deselectSelectableWithIndex:idx];
        }
    }];
}

- (void)deselectSelectable:(id)selectable
{
    NSUInteger index = [self.selectables indexOfObject:selectable];
    [self deselectSelectableWithIndex:index];
}

- (void)deselectSelectableWithIndex:(NSInteger)index
{
    if ([self.selectedIndexes containsObject:@(index)] && (self.selectedIndexes.count > 1 || self.allowNoneSelection)) {
        [self.selectedIndexes removeObject:@(index)];
        [self.selectables[index] setSelected:NO];
        [self notifySelectionChangedWithIndex:index];
    }
}

- (void)selectSelectable:(id<DXSelectable> )obj
{
    NSInteger foundResult = [self.selectables indexOfObject:obj];
    if (foundResult != NSNotFound) {
        [self selectSelectableWithIndex:foundResult];
    }else {
        NSLog(@"selectable %@ is not found",obj);
    }
}

- (void)selectSelectableWithIndex:(NSUInteger)index
{
    if (index < self.selectables.count) {
        id<DXSelectable> obj = self.selectables[index];
        obj.selected = YES;
        [self.selectedIndexes addObject:@(index)];
        if (self.singleSelection) {
            [self deselectAllSelectablesExceptForIndex:index];
        }
        [self notifySelectionChangedWithIndex:index];
    }else {
        NSLog(@"index %lx is out of bounds , we will do nothing",(unsigned long)index);
    }
}


@end
