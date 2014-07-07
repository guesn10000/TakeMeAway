//
//  RegisterViewController.m
//  TakeMeAway
//
//  Created by Jymn_Chen on 14-5-10.
//  Copyright (c) 2014年 Jymn_Chen. All rights reserved.
//

#import "RegisterViewController.h"

@interface RegisterViewController ()

@property (weak, nonatomic) IBOutlet UITextField *username_textField;
@property (weak, nonatomic) IBOutlet UITextField *password_textField;
@property (weak, nonatomic) IBOutlet UITextField *confirmPassword_textField;

@property (strong, nonatomic) IBOutlet UISwipeGestureRecognizer *swipeGesture;

@end

@implementation RegisterViewController

#pragma mark - View life cycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.navigationItem.hidesBackButton = YES;
    _swipeGesture.direction = UISwipeGestureRecognizerDirectionUp | UISwipeGestureRecognizerDirectionDown;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return (section == 0) ? 3 : 1;
}

#pragma mark - Actions

- (IBAction)registAction:(id)sender {
#warning - Unfinished
    // 注册
}

- (IBAction)cancelRegist:(id)sender {
    [self.navigationController popToRootViewControllerAnimated:YES];
}

- (IBAction)swipeVertically:(id)sender {
    [_username_textField resignFirstResponder];
    [_password_textField resignFirstResponder];
    [_confirmPassword_textField resignFirstResponder];
}

@end
