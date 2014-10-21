//
//  SaveViewController.m
//  Lost Characters
//
//  Created by Eduardo Alvarado Díaz on 10/21/14.
//  Copyright (c) 2014 Organization. All rights reserved.
//

#import "SaveViewController.h"

@interface SaveViewController ()
@property (strong, nonatomic) IBOutlet UITextField *actorText;
@property (strong, nonatomic) IBOutlet UITextField *passengerText;
@property (strong, nonatomic) IBOutlet UILabel *requiredLabel;

@end

@implementation SaveViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.requiredLabel.hidden = YES;

}

- (IBAction)saveButtonPressed:(UIBarButtonItem *)button {
    NSMutableString *msg = [[NSMutableString alloc] init];
    if ([self.actorText.text isEqualToString:@""]) {
        [msg appendString:@"- Actor's name \n"];
    }
    if ([self.passengerText.text isEqualToString:@""]) {
        [msg appendString:@"- Passenger "];
    }

    if ([msg isEqualToString:@""]) {
        self.actor = self.actorText.text;
        self.passenger = self.passengerText.text;
        [self performSegueWithIdentifier:@"saveCharacter" sender:self];
    }else{
        self.requiredLabel.text = [NSString stringWithFormat:@"The following are required: \n%@",msg];
        self.requiredLabel.hidden= NO;
    }
}

#pragma mark - Segues

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
}

@end
