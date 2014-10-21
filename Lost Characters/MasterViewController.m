//
//  MasterViewController.m
//  Lost Characters
//
//  Created by Eduardo Alvarado Díaz on 10/21/14.
//  Copyright (c) 2014 Organization. All rights reserved.
//

#import "MasterViewController.h"
#import "DetailViewController.h"
#import "SaveViewController.h"

@interface MasterViewController ()

@property NSArray *characters;

@end

@implementation MasterViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    [self loadData];
}

-(void)loadData{
    NSFetchRequest *request = [[NSFetchRequest alloc] initWithEntityName:@"LostCharacter"];
    NSSortDescriptor *sortDescriptor1 = [[NSSortDescriptor alloc] initWithKey:@"actor" ascending:YES];
    NSSortDescriptor *sortDescriptor2 = [[NSSortDescriptor alloc] initWithKey:@"passenger" ascending:NO];

    request.sortDescriptors = [NSArray arrayWithObjects:sortDescriptor1, sortDescriptor2 ,nil];
    self.characters = [self.managedObjectContext executeFetchRequest:request error:nil];

    NSLog(@"Number characters: %lu",self.characters.count);
    if (self.characters.count == 0) {
        NSString *plistPath = [[NSBundle mainBundle] pathForResource:@"lost" ofType:@"plist"];
        NSArray *lostPlist = [NSArray arrayWithContentsOfFile:plistPath];
        for (NSDictionary *data in lostPlist) {
            [self saveCharacterWithActor:[data objectForKey:@"actor"] passenger:[data objectForKey:@"passenger"]];
        }
        [self loadData];
    }

    [self.tableView reloadData];
}

-(void)saveCharacterWithActor:(NSString *)actor passenger:(NSString *)passenger{
    NSManagedObject *character = [NSEntityDescription insertNewObjectForEntityForName:@"LostCharacter" inManagedObjectContext:self.managedObjectContext];
    [character setValue:actor forKey:@"actor"];
    [character setValue:passenger forKey:@"passenger"];

    [self.managedObjectContext save:nil];
}

#pragma mark - Segues

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([[segue identifier] isEqualToString:@"showDetail"]) {
        NSLog(@"Detail ...");
    }else if ([[segue identifier] isEqualToString:@"showSave"]) {
        NSLog(@"Add new character ...");
    }
}

-(IBAction)unwindSegue:(UIStoryboardSegue *)segue{
    if ([segue.sourceViewController isKindOfClass:[SaveViewController class]]) {
        SaveViewController *saveVC = segue.sourceViewController;
        if (saveVC.actor && saveVC.passenger) {
            [self saveCharacterWithActor:saveVC.actor passenger:saveVC.passenger];
            [self loadData];
        }
    }
}

#pragma mark - Table View

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.characters.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSManagedObject *character = [self.characters objectAtIndex:indexPath.row];
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];

    cell.textLabel.text = [character valueForKey:@"actor"];
    cell.detailTextLabel.text = [character valueForKey:@"passenger"];

    return cell;
}


@end
