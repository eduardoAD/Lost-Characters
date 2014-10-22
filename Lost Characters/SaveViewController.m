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
@property (strong, nonatomic) IBOutlet UITextField *occupationText;
@property (strong, nonatomic) IBOutlet UITextField *ageText;
@property (strong, nonatomic) IBOutlet UITextField *genderText;
@property (strong, nonatomic) IBOutlet UITextField *hairColorText;
@property (strong, nonatomic) IBOutlet UITextField *characterBioText;

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
        [msg appendString:@"- Passenger \n"];
    }
    if ([self.occupationText.text isEqualToString:@""]) {
        [msg appendString:@"- Occupation \n"];
    }
    if ([self.ageText.text isEqualToString:@""]) {
        [msg appendString:@"- Age \n"];
    }
    if ([self.genderText.text isEqualToString:@""]) {
        [msg appendString:@"- Gender \n"];
    }
    if ([self.hairColorText.text isEqualToString:@""]) {
        [msg appendString:@"- Hair's color \n"];
    }
    if ([self.characterBioText.text isEqualToString:@""]) {
        [msg appendString:@"- Character Biography "];
    }

    if ([msg isEqualToString:@""]) {
        self.actor = self.actorText.text;
        self.passenger = self.passengerText.text;
        self.occupation = self.occupationText.text;
        self.age = self.ageText.text;
        self.gender = self.genderText.text;
        self.hairColor = self.hairColorText.text;
        self.characterBio = self.characterBioText.text;

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
