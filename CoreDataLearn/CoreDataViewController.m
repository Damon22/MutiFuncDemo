//
//  CoreDataViewController.m
//  CoreDataLearn
//
//  Created by 高继鹏 on 16/5/26.
//  Copyright © 2016年 GaoJipeng. All rights reserved.
//

#import "CoreDataViewController.h"
#import "DBCell.h"
#import "Person.h"
#import "Card.h"
#import "AppDelegate.h"
#import <CoreData/CoreData.h>
#import <objc/runtime.h>

// 判断是不是iPad运行环境
#define IS_IPAD (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)

@interface CoreDataViewController ()<UITextFieldDelegate,UITableViewDelegate,UITableViewDataSource,NSFetchedResultsControllerDelegate>

@property (nonatomic, strong) UITextField *tempTF;

- (IBAction)addAction:(UIButton *)sender;
- (IBAction)deleteAction:(UIButton *)sender;
- (IBAction)changeAction:(UIButton *)sender;
- (IBAction)searchAction:(UIButton *)sender;

@property (weak, nonatomic) IBOutlet UITextField *nameTF;
@property (weak, nonatomic) IBOutlet UITextField *ageTF;
@property (weak, nonatomic) IBOutlet UITextField *genderTF;
@property (weak, nonatomic) IBOutlet UITextField *cardTF;
@property (weak, nonatomic) IBOutlet UITextField *idTF;

@property (weak, nonatomic) IBOutlet UITableView *showTableView;
@property (nonatomic, strong) NSMutableArray *dataSource;

@property (nonatomic, strong) NSManagedObjectContext *managedObjectContext;
@property (nonatomic, strong) NSFetchedResultsController *fetchedResultsController;
@property (nonatomic, strong) NSArray *TFArray;

@end

@implementation CoreDataViewController
{
    UIToolbar *toolBar;
}

- (void)viewDidLoad
{
    _TFArray = @[self.nameTF,self.ageTF,self.genderTF,self.cardTF,self.idTF];
    _dataSource = [NSMutableArray array];
    AppDelegate *app = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    self.managedObjectContext = app.managedObjectContext;
    [self initFetchedResultsController];
    NSError *error = nil;
    if (![[self fetchedResultsController] performFetch:&error]) {
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }
    
}

#pragma mark - keyBoardAction
- (void)clearText
{
    [_tempTF setText:@""];
}

- (void)resignKeyBoardMode
{
    [_tempTF resignFirstResponder];
}

- (UIToolbar *)accessoryView
{
    // Create toolbar with Clear and Done
    toolBar = [[UIToolbar alloc] initWithFrame:CGRectMake(0.0f, 0.0f, self.view.frame.size.width, 44.0f)];
    toolBar.tintColor = [UIColor darkGrayColor];
    
    // Set up the items as Clear - flexspace - Done
    NSMutableArray *items = [NSMutableArray array];
    [items addObject:[[UIBarButtonItem alloc] initWithTitle:@"清除" style:UIBarButtonItemStylePlain target:self action:@selector(clearText)]];
    // 添加间隔
    [items addObject:[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:self action:nil]];
    [items addObject:[[UIBarButtonItem alloc] initWithTitle:@"完成" style:UIBarButtonItemStylePlain target:self action:@selector(resignKeyBoardMode)]];
    toolBar.items = items;
    
    return toolBar;
}

#pragma mark - UITextFieldDelegate
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    _tempTF = textField;
    self.tempTF.inputAccessoryView = [self accessoryView];
    return YES;
}

#pragma mark - UITableViewDataSource
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    DBCell *dbCell = (DBCell *)[tableView dequeueReusableCellWithIdentifier:@"DBCell"];
    
    [self configureCell:dbCell atIndexPath:indexPath];
    
    return dbCell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSInteger numberOfRows = 0;
    
    if ([self.fetchedResultsController sections].count > 0) {
        id <NSFetchedResultsSectionInfo> sectionInfo = [[self.fetchedResultsController sections] objectAtIndex:section];
        numberOfRows = [sectionInfo numberOfObjects];
    }
    return numberOfRows;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    NSInteger count = [self.fetchedResultsController sections].count;
    
    if (count == 0) {
        count = 1;
    }
    return count;
}

#pragma mark - UITableViewDelegate
- (NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    return indexPath;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    Person *person = (Person *)[self.fetchedResultsController objectAtIndexPath:indexPath];
    Card *card = person.card;
    ((UITextField *)[self.view viewWithTag:100]).text = person.name;
    ((UITextField *)[self.view viewWithTag:101]).text = [NSString stringWithFormat:@"%@",person.age];
    ((UITextField *)[self.view viewWithTag:102]).text = [NSString stringWithFormat:@"%@",person.gender];
    ((UITextField *)[self.view viewWithTag:103]).text = card.no;
    ((UITextField *)[self.view viewWithTag:104]).text = [NSString stringWithFormat:@"%@",person.id];
}

- (void)configureCell:(DBCell *)cell atIndexPath:(NSIndexPath *)indexPath
{
    Person *person = (Person *)[self.fetchedResultsController objectAtIndexPath:indexPath];
    [cell showModel:person];
}

#pragma mark - 增删改查
- (IBAction)addAction:(UIButton *)sender {
    NSMutableArray *inputArr = [NSMutableArray arrayWithObjects:@"",@"",@"",@"",@"",nil];
    for (UITextField *tf in self.TFArray) {
        if (tf && [tf.text isEqualToString:@""]) {
            UIAlertController *alertC = [UIAlertController alertControllerWithTitle:@"没有填写完整" message:nil preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *action = [UIAlertAction actionWithTitle:@"知道了" style:UIAlertActionStyleCancel handler:nil];
            [alertC addAction:action];
            [self presentViewController:alertC animated:YES completion:nil];
            return;
        }
        [inputArr replaceObjectAtIndex:(tf.tag-100) withObject:tf.text];
    }
    NSLog(@"inputArr:%@",inputArr);
    Person *person = [NSEntityDescription insertNewObjectForEntityForName:@"Person" inManagedObjectContext:self.managedObjectContext];
    [person setName:inputArr[0]];
    [person setAge:@([[NSString stringWithFormat:@"%@",inputArr[1]] integerValue])];
    [person setGender:@([[NSString stringWithFormat:@"%@",inputArr[2]] integerValue])];
    [person setId:@([[NSString stringWithFormat:@"%@",inputArr[4]] integerValue])];
    
    Card *card = [NSEntityDescription insertNewObjectForEntityForName:@"Card" inManagedObjectContext:self.managedObjectContext];
    [card setNo:inputArr[3]];
    
    person.card = card;
    
    NSError *error;
    if (![self.managedObjectContext save:&error]) {
        // Replace this implementation with code to handle the error appropriately.
        // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }
    for (UITextField *tf in self.TFArray) {
        tf.text = @"";
    }
}

- (IBAction)deleteAction:(UIButton *)sender {
    NSString *name = ((UITextField *)[self.view viewWithTag:100]).text;
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Person" inManagedObjectContext:self.managedObjectContext];
    [fetchRequest setEntity:entity];
    // Specify criteria for filtering which objects to fetch
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"name = %@", name];
    [fetchRequest setPredicate:predicate];
    // Specify how the fetched objects should be sorted
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"name"
                                                                   ascending:YES];
    [fetchRequest setSortDescriptors:[NSArray arrayWithObjects:sortDescriptor, nil]];
    
    NSError *error = nil;
    NSArray *fetchedObjects = [self.managedObjectContext executeFetchRequest:fetchRequest error:&error];
    if (fetchedObjects == nil) {
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }
    
    __block Person * deletemp ;
    [fetchedObjects enumerateObjectsUsingBlock:^(Person * obj, NSUInteger idx, BOOL *stop) {
        if ([obj.name isEqualToString:name])
        {
            deletemp = obj;
            *stop = YES;
        }
    }];
    if (deletemp) {
        [self.managedObjectContext deleteObject:deletemp];
    }
    [self.managedObjectContext save:nil];
}

- (IBAction)changeAction:(UIButton *)sender {
    NSString *name = ((UITextField *)[self.view viewWithTag:100]).text;
    NSString *age = ((UITextField *)[self.view viewWithTag:101]).text;
    NSString *gender = ((UITextField *)[self.view viewWithTag:102]).text;
    NSString *no = ((UITextField *)[self.view viewWithTag:103]).text;
    NSString *id = ((UITextField *)[self.view viewWithTag:104]).text;
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Person" inManagedObjectContext:self.managedObjectContext];
    [fetchRequest setEntity:entity];
    // Specify criteria for filtering which objects to fetch
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"name = %@", name];
    [fetchRequest setPredicate:predicate];
    // Specify how the fetched objects should be sorted
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"name"
                                                                   ascending:YES];
    [fetchRequest setSortDescriptors:[NSArray arrayWithObjects:sortDescriptor, nil]];
    
    NSError *error = nil;
    NSArray *fetchedObjects = [self.managedObjectContext executeFetchRequest:fetchRequest error:&error];
    if (fetchedObjects == nil) {
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }
    
    __block Person * changeTemp ;
    [fetchedObjects enumerateObjectsUsingBlock:^(Person * obj, NSUInteger idx, BOOL *stop) {
        if ([obj.name isEqualToString:name])
        {
            changeTemp = obj;
            obj.name = name;
            obj.id = @([[NSString stringWithFormat:@"%@",id] integerValue]);
            obj.age = @([[NSString stringWithFormat:@"%@",age] integerValue]);
            obj.gender = @([[NSString stringWithFormat:@"%@",gender] integerValue]);
            Card *card = obj.card;
            card.no = no;
            
            *stop = YES;
        }
    }];
    if (changeTemp) {
        [self.managedObjectContext save:nil];
        // 控制内存方法，任何增删改查的地方都可以用
        [self.managedObjectContext refreshObject:changeTemp mergeChanges:YES];
    }
}

- (IBAction)searchAction:(UIButton *)sender {
    //判断查询类型
    NSString *name = ((UITextField *)[self.view viewWithTag:100]).text;
    NSString *card = ((UITextField *)[self.view viewWithTag:103]).text;
    NSString *caId = ((UITextField *)[self.view viewWithTag:104]).text;
    if (name.length == 0 && card.length == 0 && caId.length == 0) {
        [self initFetchedResultsController];
        [self executeFetchedResultsController];
        [self.showTableView reloadData];
        return;
    }
    
    if (name.length || caId.length) {
        NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
        NSEntityDescription *entity = [NSEntityDescription entityForName:@"Person" inManagedObjectContext:self.managedObjectContext];
        [fetchRequest setEntity:entity];
        fetchRequest.predicate = [NSPredicate predicateWithFormat:@"name = %@ OR id = %@",name,caId];
        NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"name" ascending:YES];
        NSArray *sortDes = [[NSArray alloc] initWithObjects:sortDescriptor, nil];
        [fetchRequest setSortDescriptors:sortDes];
        
        NSFetchedResultsController *aFetResController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest managedObjectContext:self.managedObjectContext sectionNameKeyPath:nil cacheName:@"RootName"];
        self.fetchedResultsController = aFetResController;
    }else{
        // 有问题，待改
        NSFetchRequest *fetch = [[NSFetchRequest alloc] init];
        NSEntityDescription *entity = [NSEntityDescription entityForName:@"Card" inManagedObjectContext:self.managedObjectContext];
        [fetch setEntity:entity];
        fetch.predicate = [NSPredicate predicateWithFormat:@"no = %@",card];
        NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"no" ascending:YES];
        NSArray *sortDes = [[NSArray alloc] initWithObjects:sortDescriptor, nil];
        [fetch setSortDescriptors:sortDes];
        
        
        NSArray *allPerson = [self.managedObjectContext executeFetchRequest:fetch error:NULL];
        for (Person *person in allPerson) {
            NSLog(@"allPerson:%@",person);
        }

        return;
    }
    NSError *error = nil;
    if (![[self fetchedResultsController] performFetch:&error]) {
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }
    [self.showTableView reloadData];
    
}

#pragma mark - CoreData
- (void)initFetchedResultsController {
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Person" inManagedObjectContext:self.managedObjectContext];
    [fetchRequest setEntity:entity];
    
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"name" ascending:YES];
    NSArray *sortDescriptors = [[NSArray alloc] initWithObjects:sortDescriptor, nil];
    
    [fetchRequest setSortDescriptors:sortDescriptors];
    
    NSFetchedResultsController *aFetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest managedObjectContext:self.managedObjectContext sectionNameKeyPath:nil cacheName:@"Root"];
    aFetchedResultsController.delegate = self;
    self.fetchedResultsController = aFetchedResultsController;
}

- (void)executeFetchedResultsController {
    NSError *error = nil;
    if (![[self fetchedResultsController] performFetch:&error]) {
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }
}

/*
- (NSFetchedResultsController *)fetchedResultsController {
    if (_fetchedResultsController != nil) {
        return _fetchedResultsController;
    }
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Person" inManagedObjectContext:self.managedObjectContext];
    [fetchRequest setEntity:entity];
    
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"name" ascending:YES];
    NSArray *sortDescriptors = [[NSArray alloc] initWithObjects:sortDescriptor, nil];
    
    [fetchRequest setSortDescriptors:sortDescriptors];
    
    NSFetchedResultsController *aFetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest managedObjectContext:self.managedObjectContext sectionNameKeyPath:nil cacheName:@"Root"];
    aFetchedResultsController.delegate = self;
    self.fetchedResultsController = aFetchedResultsController;
    
    // 查询方法
    NSFetchRequest *fetch = [[NSFetchRequest alloc] init];
    NSEntityDescription *entityNew = [NSEntityDescription entityForName:@"Person" inManagedObjectContext:self.managedObjectContext];
    [fetch setEntity:entityNew];
    NSArray *allPerson = [self.managedObjectContext executeFetchRequest:fetch error:NULL];
    for (Person *person in allPerson) {
        NSLog(@"allPerson:%@",person);
    }
    
    
    return _fetchedResultsController;
}
 */

//当数据发生变化时，点对点的更新tableview，这样大大的提高了更新效率
- (void)controller:(NSFetchedResultsController *)controller didChangeObject:(id)anObject atIndexPath:(NSIndexPath *)indexPath forChangeType:(NSFetchedResultsChangeType)type newIndexPath:(NSIndexPath *)newIndexPath
{
    switch (type) {
        case NSFetchedResultsChangeInsert:
            [self.showTableView insertRowsAtIndexPaths:[NSArray arrayWithObjects:newIndexPath, nil] withRowAnimation:UITableViewRowAnimationFade];
            break;
        case NSFetchedResultsChangeDelete:
            [self.showTableView deleteRowsAtIndexPaths:[NSArray arrayWithObjects:indexPath, nil] withRowAnimation:UITableViewRowAnimationFade];
            break;
        case NSFetchedResultsChangeMove:
        {
            [self.showTableView deleteRowsAtIndexPaths:[NSArray arrayWithObjects:indexPath, nil] withRowAnimation:UITableViewRowAnimationFade];
            [self.showTableView insertRowsAtIndexPaths:[NSArray arrayWithObjects:newIndexPath, nil] withRowAnimation:UITableViewRowAnimationFade];
        }
            break;
        case NSFetchedResultsChangeUpdate:
        {
            DBCell * cell = (DBCell *)[self.showTableView cellForRowAtIndexPath:indexPath];
            Person * person = (Person *)[controller objectAtIndexPath:indexPath];
            [cell showModel:person];
        }
            break;
            
        default:
            break;
    }
}

//点对点的更新section
- (void)controller:(NSFetchedResultsController *)controller didChangeSection:(id <NSFetchedResultsSectionInfo>)sectionInfo atIndex:(NSUInteger)sectionIndex forChangeType:(NSFetchedResultsChangeType)type
{
    switch(type) {
            
        case NSFetchedResultsChangeInsert:
            [self.showTableView insertSections:[NSIndexSet indexSetWithIndex:sectionIndex] withRowAnimation:UITableViewRowAnimationFade];
            break;
            
        case NSFetchedResultsChangeDelete:
            [self.showTableView deleteSections:[NSIndexSet indexSetWithIndex:sectionIndex] withRowAnimation:UITableViewRowAnimationFade];
            break;
            
        case NSFetchedResultsChangeMove:
        case NSFetchedResultsChangeUpdate :
            break;
    }
}

//此方法执行时，说明数据已经发生了变化，通知tableview开始更新UI
- (void)controllerWillChangeContent:(NSFetchedResultsController *)controller
{
    [self.showTableView beginUpdates];
}

//结束更新
- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller
{
    [self.showTableView endUpdates];
}

@end
