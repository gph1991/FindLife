//
//  SearchViewController.m
//  FindLife
//
//  Created by qianfeng on 14-9-30.
//  Copyright (c) 2014年 GPH. All rights reserved.
//

#import "SearchViewController.h"
#import "SearchResultViewController.h"

#define URL @"http://api.chengmi.com/searchhotkey?location=bj"


@interface SearchViewController ()<UITextFieldDelegate>
{
    UISearchBar *_searchBar;
    UITextField *_textField;
}
@end

@implementation SearchViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self makeTableViewAndSearchBar];
    [self startRequest];
    
}


-(void)viewWillAppear:(BOOL)animated
{
    [Common HideTabBar:YES andViews:self.tabBarController.view.subviews];
    self.navigationController.navigationBarHidden = YES;
}

-(void)makeTableViewAndSearchBar
{
    int height = 0;
    if (IOS7)
    {
        height = 20;
    }
    
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, height, 320, 44)];
    view.backgroundColor = COLOR(53, 198, 179, 1);
    [self.view addSubview:view];
    [self initTableViewWithFrame:CGRectMake(0, height+44, 320, 400)];

    UIImageView *imageView = [[[UIImageView alloc] initWithFrame:CGRectMake(35, height+5, 319-35, 30)] autorelease];
    
    imageView.image = [UIImage imageNamed:@"searchstyle.png"];
    [self.view addSubview:imageView];
    [imageView release];
    
    _textField = [[UITextField alloc]initWithFrame:CGRectMake(60, height+5, 220, 30)];
    _textField.returnKeyType = UIReturnKeySearch;
    _textField.clearButtonMode = UITextFieldViewModeAlways;
    _textField.delegate = self;
    [self.view addSubview:_textField];
    [_textField release];
    [_textField becomeFirstResponder];
    UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
                         
    backBtn.frame = CGRectMake(5, height+10, 16, 20);
    [backBtn setImage:[UIImage imageNamed:@"white_back.png"] forState:UIControlStateNormal];
    [backBtn addTarget:self action:@selector(backDown) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:backBtn];
    
    UIButton *scanBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    
    scanBtn.frame = CGRectMake(290, height+5, 30, 30);
    [scanBtn addTarget:self action:@selector(scanDown) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:scanBtn];

}

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if (textField.text.length == 0)
    {
        [textField resignFirstResponder];
        return YES;
    }
    NSLog(@"keywords:%@",textField.text);
    
    [textField resignFirstResponder];
    SearchResultViewController *searchReuslt = [[SearchResultViewController alloc]init];
    searchReuslt.keywords = textField.text;
    [self.navigationController pushViewController:searchReuslt animated:YES];
    [searchReuslt release];
    return YES;
}

-(void)backDown
{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)scanDown
{
    NSLog(@"扫描");
}

-(void)startRequest
{
    [HTTPManager requestWithUrl:URL FinishBlock:^(NSData *data) {
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
        NSArray *arr = dic[@"hotkeys"];
        for (int i = 0; i < arr.count; i++)
        {
            NSString *str = [[NSString alloc]initWithString:arr[i]];
            [self.dataArr addObject:str];
            [str release];
        }
        [self.tableView reloadData];
        
    } FailedBlock:^{
        NSLog(@"EORROR");
    }];
}



-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 30;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}
-(NSString*)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    if (section == 0)
    {
        return @"我的搜索";
    }
    else
    {
        return @"热门搜索";
    }
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"item"];
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"item"];
        
    }
    cell.textLabel.text = self.dataArr[indexPath.row];
    cell.textLabel.textColor = COLOR(53, 198, 179, 1);
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *str =  self.dataArr[indexPath.row];
    //跳转
    SearchResultViewController *searchResult = [[SearchResultViewController alloc]init];
    searchResult.keywords = str;
    [self.navigationController pushViewController:searchResult animated:YES];
    [searchResult release];

}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
