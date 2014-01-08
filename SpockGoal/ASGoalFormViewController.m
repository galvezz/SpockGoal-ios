//
//  ASGoalFormViewController.m
//  SpockGoal
//
//  Created by Alan Sparrow on 1/8/14.
//  Copyright (c) 2014 Alan Sparrow. All rights reserved.
//

#import "ASGoalFormViewController.h"
#import "ASGoal.h"
#import "ASGoalCopy.h"
#import "ASTimeProcess.h"
#import "ASTimePickerViewController.h"
#import "ASGoalStore.h"
#import <QuartzCore/QuartzCore.h>

@interface ASGoalFormViewController ()

@end

@implementation ASGoalFormViewController

@synthesize dismissBlock;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (id)initForGoal:(ASGoal *)goal newGoal:(BOOL)isNew
{
    self = [super initWithNibName:@"ASGoalFormViewController" bundle:nil];
    savedGoal = goal;
    copyGoal = [[ASGoalCopy alloc] initWith:goal];
    
    [[self navigationItem] setTitle:[goal title]];
    
    if (self) {
        if (isNew) {
            UIBarButtonItem *doneItem =[[UIBarButtonItem alloc]
                                        initWithBarButtonSystemItem:UIBarButtonSystemItemDone
                                        target:self
                                        action:@selector(save:)];
            [[self navigationItem] setRightBarButtonItem:doneItem];
            
            UIBarButtonItem *cancelItem = [[UIBarButtonItem alloc]
                                           initWithBarButtonSystemItem:UIBarButtonSystemItemCancel
                                           target:self
                                           action:@selector(cancelNewGoal:)]; // remove
            [[self navigationItem] setLeftBarButtonItem:cancelItem];
        } else {
            UIBarButtonItem *doneItem =[[UIBarButtonItem alloc]
                                        initWithBarButtonSystemItem:UIBarButtonSystemItemDone
                                        target:self
                                        action:@selector(save:)];
            [[self navigationItem] setRightBarButtonItem:doneItem];
            
            UIBarButtonItem *cancelItem = [[UIBarButtonItem alloc]
                                           initWithBarButtonSystemItem:UIBarButtonSystemItemCancel
                                           target:self
                                           action:@selector(cancel:)];  // don't remove
            [[self navigationItem] setLeftBarButtonItem:cancelItem];
            
        }
    }
    
    return self;
}

- (IBAction)save:(id)sender
{
    if ([[goalTitleTextField text] isEqual:@""]) {
        /*
        [goalTitleTextField setBackgroundColor:[UIColor blueColor]];
        
        [UIView animateWithDuration:4.0 animations:^{
            [goalTitleTextField setBackgroundColor:[UIColor colorWithRed:1.0
                                                                   green:0.0
                                                                    blue:0.0
                                                                   alpha:0.5]];
        } completion:nil];
         */
        [goalTitleTextField setBackgroundColor:[UIColor redColor]];

        [UIView beginAnimations:@"fade in" context:nil];
        [UIView setAnimationDuration:3.0];
        [goalTitleTextField setBackgroundColor:[UIColor whiteColor]];
        [UIView commitAnimations];
    }
    
    if (![self checkTime]) {
        CGRect screenRect = [[UIScreen mainScreen] bounds];
        UILabel *tmpLabel = [[UILabel alloc] init];
        [tmpLabel setNumberOfLines:0];
        [tmpLabel setTextAlignment:NSTextAlignmentCenter];
        
        [tmpLabel setFrame:CGRectMake(0, 0,
                                      screenRect.size.width*2/3, 100)];

        [tmpLabel setCenter:CGPointMake(screenRect.size.width/2, [startAtButton center].y+35)];
        [tmpLabel setText:@"Oh Snap!\n@Start > Finish@"];
        [tmpLabel setTextColor:[UIColor colorWithRed:1.0
                                               green:0.0
                                                blue:0.0
                                               alpha:1.0]];
        [[self view] addSubview:tmpLabel];
        
        // Create a basic animation
        CABasicAnimation *fader = [CABasicAnimation animationWithKeyPath:@"opacity"];
        [fader setDuration:4.0];
        
        [[tmpLabel layer] setOpacity:0.0];
        
        [fader setFromValue:[NSNumber numberWithFloat:1.0]];
        [fader setToValue:[NSNumber numberWithFloat:0.0]];
        [[tmpLabel layer] addAnimation:fader forKey:@"fader"];
        
    }
    
    if (![[goalTitleTextField text] isEqual:@""] && [self checkTime]) {
        
        [[self presentingViewController]
         dismissViewControllerAnimated:YES
         completion:dismissBlock];
    }
    
}

- (IBAction)cancelNewGoal:(id)sender
{
    // If the user cancelled, then remove the ASGoal from the store
    [[ASGoalStore sharedStore] removeGoal:savedGoal];
    
    [[self presentingViewController]
     dismissViewControllerAnimated:YES completion:dismissBlock];
}

- (IBAction)cancel:(id)sender
{
    // Reset all form to savedGoal data
    ASTimeProcess *timeProcess = [[ASTimeProcess alloc] init];
    
    NSArray *colors = [NSArray arrayWithObjects:[UIColor grayColor],
                       [UIColor colorWithRed:0.0 green:122.0/255.0 blue:1.0 alpha:1.0], nil];
    [monButton setTitleColor:[colors objectAtIndex:[copyGoal monday]] forState:UIControlStateNormal];
    [tueButton setTitleColor:[colors objectAtIndex:[copyGoal tuesday]] forState:UIControlStateNormal];
    [wedButton setTitleColor:[colors objectAtIndex:[copyGoal wednesday]] forState:UIControlStateNormal];
    [thuButton setTitleColor:[colors objectAtIndex:[copyGoal thursday]] forState:UIControlStateNormal];
    [friButton setTitleColor:[colors objectAtIndex:[copyGoal friday]] forState:UIControlStateNormal];
    [satButton setTitleColor:[colors objectAtIndex:[copyGoal saturday]] forState:UIControlStateNormal];
    [sunButton setTitleColor:[colors objectAtIndex:[copyGoal sunday]] forState:UIControlStateNormal];
    
    [remindMeSwitch setOn:[copyGoal remindMe]];
    [goalTitleTextField setText:[copyGoal title]];
    [startAtButton setTitle:[timeProcess timeIntervalToString:[copyGoal everydayStartAt]]
                   forState:UIControlStateNormal];
    [finishAtButton setTitle:[timeProcess timeIntervalToString:[copyGoal everydayFinishAt]]
                    forState:UIControlStateNormal];

    
    // Move back
    [[self presentingViewController]
     dismissViewControllerAnimated:YES completion:dismissBlock];
}

- (BOOL)checkTime
{
    BOOL resultBoolean = NO;
    
    ASTimeProcess *timeProcess = [[ASTimeProcess alloc] init];
    NSInteger tp1 = [timeProcess
                     timePointToInt:
                     [timeProcess stringToDate:[[startAtButton titleLabel] text]]
                     ];
    NSInteger tp2 = [timeProcess
                     timePointToInt:
                     [timeProcess stringToDate:[[finishAtButton titleLabel] text]]
                     ];
    if (tp1 <= tp2) {
        resultBoolean = YES;
    }
    
    return resultBoolean;
}



- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.

}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    
    if (![[savedGoal title] isEqual:@"Creating goal..."]) {
        ASTimeProcess *timeProcess = [[ASTimeProcess alloc] init];
        
        NSArray *colors = [NSArray arrayWithObjects:[UIColor grayColor],
                           [UIColor colorWithRed:0.0 green:122.0/255.0 blue:1.0 alpha:1.0], nil];
        [monButton setTitleColor:[colors objectAtIndex:[savedGoal monday]] forState:UIControlStateNormal];
        [tueButton setTitleColor:[colors objectAtIndex:[savedGoal tuesday]] forState:UIControlStateNormal];
        [wedButton setTitleColor:[colors objectAtIndex:[savedGoal wednesday]] forState:UIControlStateNormal];
        [thuButton setTitleColor:[colors objectAtIndex:[savedGoal thursday]] forState:UIControlStateNormal];
        [friButton setTitleColor:[colors objectAtIndex:[savedGoal friday]] forState:UIControlStateNormal];
        [satButton setTitleColor:[colors objectAtIndex:[savedGoal saturday]] forState:UIControlStateNormal];
        [sunButton setTitleColor:[colors objectAtIndex:[savedGoal sunday]] forState:UIControlStateNormal];
        
        [remindMeSwitch setOn:[savedGoal remindMe]];
        [goalTitleTextField setText:[savedGoal title]];
        [startAtButton setTitle:[timeProcess timeIntervalToString:[savedGoal everydayStartAt]]
                       forState:UIControlStateNormal];
        [finishAtButton setTitle:[timeProcess timeIntervalToString:[savedGoal everydayFinishAt]]
                        forState:UIControlStateNormal];
    } else {
        ASTimeProcess *timeProcess = [[ASTimeProcess alloc] init];
        [startAtButton setTitle:[timeProcess timeIntervalToString:[NSDate timeIntervalSinceReferenceDate]]
                       forState:UIControlStateNormal];
        [finishAtButton setTitle:[timeProcess timeIntervalToString:[NSDate timeIntervalSinceReferenceDate]]
                        forState:UIControlStateNormal];
    }
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:YES];
    
    // Clear first responder
    [[self view] endEditing:YES];
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateStyle:NSDateFormatterNoStyle];
    [dateFormatter setTimeStyle:NSDateFormatterShortStyle];
    
    ASTimeProcess *timeProcess = [[ASTimeProcess alloc] init];
    NSDate* tp1 = [timeProcess stringToDate:[[startAtButton titleLabel] text]];
    NSDate* tp2 = [timeProcess stringToDate:[[finishAtButton titleLabel] text]];
    
    // "Save" changes to goal
    [savedGoal setTitle:[goalTitleTextField text]];
    [savedGoal setRemindMe:[remindMeSwitch isOn]];
    [savedGoal setEverydayStartAt:[tp1 timeIntervalSinceReferenceDate]];
    [savedGoal setEverydayFinishAt:[tp2 timeIntervalSinceReferenceDate]];
    
    if ([monButton titleColorForState:UIControlStateNormal] == [UIColor grayColor]) {
        [savedGoal setMonday:NO];
    } else {
        [savedGoal setMonday:YES];
    }
    if ([tueButton titleColorForState:UIControlStateNormal] == [UIColor grayColor]) {
        [savedGoal setTuesday:NO];
    } else {
        [savedGoal setTuesday:YES];
    }
    if ([wedButton titleColorForState:UIControlStateNormal] == [UIColor grayColor]) {
        [savedGoal setWednesday:NO];
    } else {
        [savedGoal setWednesday:YES];
    }
    if ([thuButton titleColorForState:UIControlStateNormal] == [UIColor grayColor]) {
        [savedGoal setThursday:NO];
    } else {
        [savedGoal setThursday:YES];
    }
    if ([friButton titleColorForState:UIControlStateNormal] == [UIColor grayColor]) {
        [savedGoal setFriday:NO];
    } else {
        [savedGoal setFriday:YES];
    }
    if ([satButton titleColorForState:UIControlStateNormal] == [UIColor grayColor]) {
        [savedGoal setSaturday:NO];
    } else {
        [savedGoal setSaturday:YES];
    }
    if ([sunButton titleColorForState:UIControlStateNormal] == [UIColor grayColor]) {
        [savedGoal setSunday:NO];
    } else {
        [savedGoal setSunday:YES];
    }
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)monClick:(id)sender {
    if ([monButton titleColorForState:UIControlStateNormal] == [UIColor grayColor]) {
        [monButton setTitleColor:[UIColor colorWithRed:0.0 green:122.0/255.0 blue:1.0 alpha:1.0]
                        forState:UIControlStateNormal];
    } else {
        [monButton setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    }
}

- (IBAction)tueClick:(id)sender {
    if ([tueButton titleColorForState:UIControlStateNormal] == [UIColor grayColor]) {
        [tueButton setTitleColor:[UIColor colorWithRed:0.0 green:122.0/255.0 blue:1.0 alpha:1.0]
                        forState:UIControlStateNormal];
    } else {
        [tueButton setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    }
}

- (IBAction)wedClick:(id)sender {
    if ([wedButton titleColorForState:UIControlStateNormal] == [UIColor grayColor]) {
        [wedButton setTitleColor:[UIColor colorWithRed:0.0 green:122.0/255.0 blue:1.0 alpha:1.0]
                        forState:UIControlStateNormal];
    } else {
        [wedButton setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    }
}

- (IBAction)thuClick:(id)sender {
    if ([thuButton titleColorForState:UIControlStateNormal] == [UIColor grayColor]) {
        [thuButton setTitleColor:[UIColor colorWithRed:0.0 green:122.0/255.0 blue:1.0 alpha:1.0]
                        forState:UIControlStateNormal];
    } else {
        [thuButton setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    }
}

- (IBAction)friClick:(id)sender {
    if ([friButton titleColorForState:UIControlStateNormal] == [UIColor grayColor]) {
        [friButton setTitleColor:[UIColor colorWithRed:0.0 green:122.0/255.0 blue:1.0 alpha:1.0]
                        forState:UIControlStateNormal];
    } else {
        [friButton setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    }
}

- (IBAction)satClick:(id)sender {
    if ([satButton titleColorForState:UIControlStateNormal] == [UIColor grayColor]) {
        [satButton setTitleColor:[UIColor colorWithRed:0.0 green:122.0/255.0 blue:1.0 alpha:1.0]
                        forState:UIControlStateNormal];
    } else {
        [satButton setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    }
}

- (IBAction)startAtClick:(id)sender {
    ASTimePickerViewController *tpc = [[ASTimePickerViewController alloc]
                                       initFor:savedGoal];
    [[self navigationController] pushViewController:tpc animated:YES];
}

- (IBAction)finishAtClick:(id)sender {
    ASTimePickerViewController *tpc = [[ASTimePickerViewController alloc]
                                       initFor:savedGoal];
    [[self navigationController] pushViewController:tpc animated:YES];
    
}

- (IBAction)sunClick:(id)sender {
    if ([sunButton titleColorForState:UIControlStateNormal] == [UIColor grayColor]) {
        [sunButton setTitleColor:[UIColor colorWithRed:0.0 green:122.0/255.0 blue:1.0 alpha:1.0]
                        forState:UIControlStateNormal];
    } else {
        [sunButton setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    }
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range
replacementString:(NSString *)string
{
    return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [[self view] endEditing:YES];
    return YES;
}

@end
