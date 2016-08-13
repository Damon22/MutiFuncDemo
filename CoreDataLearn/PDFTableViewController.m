//
//  PDFTableViewController.m
//  CoreDataLearn
//
//  Created by 高继鹏 on 16/5/30.
//  Copyright © 2016年 GaoJipeng. All rights reserved.
//

#import "PDFTableViewController.h"
#import <QuickLook/QuickLook.h>

@interface PDFTableViewController ()<QLPreviewControllerDataSource, QLPreviewControllerDelegate,QLPreviewItem>

@property (nonatomic, strong) NSArray *tableSource;
@property (nonatomic) NSURL *previewItemURL;

@end

@implementation PDFTableViewController {
    QLPreviewController *controller;
}

- (NSURL *)previewItemURL
{
    return self.tableSource[0];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableSource = [NSArray array];
    NSURL *fileURL = [[NSBundle mainBundle] URLForResource:@"Lecture3Slides" withExtension:@"pdf"];
    self.tableSource = @[fileURL];
    [self.tableView reloadData];
    
    controller = [[QLPreviewController alloc] init];
    controller.dataSource = self;
    controller.delegate = self;
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

//单个文件的大小
- (long long) fileSizeAtPath:(NSString*) filePath{
    NSFileManager* manager = [NSFileManager defaultManager];
    if ([manager fileExistsAtPath:filePath]){
        return [[manager attributesOfItemAtPath:filePath error:nil] fileSize];
    }
    return 0;
}

- (NSDictionary *)getFileInfo:(NSURL *)fileURL
{
    NSString *fileName = fileURL.lastPathComponent; //@"Lecture3Slides.pdf";
    NSString *filePath = [fileURL path];
    double fileDSize = [self fileSizeAtPath:filePath]/1024.0/1024.0;
    NSString *fileSize = [NSString stringWithFormat:@"%.2f",fileDSize];
    NSDictionary *dic = @{@"title":fileName,@"size":fileSize};
    return dic;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"infoCell" forIndexPath:indexPath];
    
    NSDictionary *dic = [self getFileInfo:self.tableSource[0]];
    cell.textLabel.text = [dic objectForKey:@"title"];
    cell.detailTextLabel.text = [NSString stringWithFormat:@"%@MB",[dic objectForKey:@"size"]];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self.navigationController pushViewController:controller animated:YES];
}

#pragma mark - QLPreviewControllerDataSource
/*!
 * @abstract Returns the number of items that the preview controller should preview.
 * @param controller The Preview Controller.
 * @result The number of items.
 */
- (NSInteger)numberOfPreviewItemsInPreviewController:(QLPreviewController *)controller
{
    return self.tableSource.count;
}

/*!
 * @abstract Returns the item that the preview controller should preview.
 * @param panel The Preview Controller.
 * @param index The index of the item to preview.
 * @result An item conforming to the QLPreviewItem protocol.
 */
- (id <QLPreviewItem>)previewController:(QLPreviewController *)controller previewItemAtIndex:(NSInteger)index
{
    return self.tableSource[0];
    
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
