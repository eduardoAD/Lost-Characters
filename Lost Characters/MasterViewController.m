//
//  MasterViewController.m
//  Lost Characters
//
//  Created by Eduardo Alvarado Díaz on 10/21/14.
//  Copyright (c) 2014 Organization. All rights reserved.
//

#import "MasterViewController.h"
#import "SaveViewController.h"
#import "LostCharacterCell.h"

@interface MasterViewController ()

@property NSArray *characters;

@end

@implementation MasterViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.leftBarButtonItem = self.editButtonItem;
    [self loadData];
}

-(void)loadData{
    NSFetchRequest *request = [[NSFetchRequest alloc] initWithEntityName:@"LostCharacter"];
    NSSortDescriptor *sortDescriptor1 = [[NSSortDescriptor alloc] initWithKey:@"actor" ascending:YES];
    NSSortDescriptor *sortDescriptor2 = [[NSSortDescriptor alloc] initWithKey:@"passenger" ascending:NO];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"gender like[c] %@", @"male"];

    request.predicate = predicate;
    request.sortDescriptors = [NSArray arrayWithObjects:sortDescriptor1, sortDescriptor2 ,nil];
    self.characters = [self.managedObjectContext executeFetchRequest:request error:nil];

    NSLog(@"Number characters: %lu",self.characters.count);
    if (self.characters.count == 0) {
        NSString *plistPath = [[NSBundle mainBundle] pathForResource:@"lost" ofType:@"plist"];
        NSArray *lostPlist = [NSArray arrayWithContentsOfFile:plistPath];
        for (NSDictionary *data in lostPlist) {
            [self saveCharacterWithActor:[data objectForKey:@"actor"]
                               passenger:[data objectForKey:@"passenger"]
                              occupation:[data objectForKey:@"occupation"]
                                     age:[data objectForKey:@"age"]
                                  gender:[data objectForKey:@"gender"]
                               hairColor:[data objectForKey:@"hairColor"]
                            characterBio:[data objectForKey:@"characterBio"]];
        }
        [self loadData];
    }

    [self.tableView reloadData];
}

-(void)saveCharacterWithActor:(NSString *)actor
                    passenger:(NSString *)passenger
                   occupation:(NSString *)occupation
                          age:(NSString *)age
                       gender:(NSString *)gender
                    hairColor:(NSString *)hairColor
                 characterBio:(NSString *)characterBio{
    NSManagedObject *character = [NSEntityDescription insertNewObjectForEntityForName:@"LostCharacter" inManagedObjectContext:self.managedObjectContext];
    [character setValue:actor forKey:@"actor"];
    [character setValue:passenger forKey:@"passenger"];
    [character setValue:occupation forKey:@"occupation"];
    [character setValue:age forKey:@"age"];
    [character setValue:gender forKey:@"gender"];
    [character setValue:hairColor forKey:@"hairColor"];
    [character setValue:characterBio forKey:@"characterBio"];

    [self.managedObjectContext save:nil];
}

#pragma mark - Segues

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([[segue identifier] isEqualToString:@"showSave"]) {
        NSLog(@"Add new character ...");
    }
}

-(IBAction)unwindSegue:(UIStoryboardSegue *)segue{
    if ([segue.sourceViewController isKindOfClass:[SaveViewController class]]) {
        SaveViewController *saveVC = segue.sourceViewController;
        if (saveVC.actor && saveVC.passenger) {
            [self saveCharacterWithActor:saveVC.actor
                               passenger:saveVC.passenger
                              occupation:saveVC.occupation
                                     age:saveVC.age
                                  gender:saveVC.gender
                               hairColor:saveVC.hairColor
                            characterBio:saveVC.characterBio];
            [self loadData];
        }
    }
}

#pragma mark - Table View

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.characters.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView registerNib:[UINib nibWithNibName:@"LostCharacterCell" bundle:nil] forCellReuseIdentifier:@"myCell"];
    LostCharacterCell *cell = [tableView dequeueReusableCellWithIdentifier:@"myCell" forIndexPath:indexPath];

    return cell;
}

-(void)tableView:(UITableView *)tableView willDisplayCell:(LostCharacterCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    NSManagedObject *character = [self.characters objectAtIndex:indexPath.row];

    cell.actorLabel.text = [character valueForKey:@"actor"];
    cell.passengerLabel.text = [character valueForKey:@"passenger"];
    cell.occupationLabel.text = [character valueForKey:@"occupation"];
    cell.ageLabel.text = [character valueForKey:@"age"];
    cell.genderLabel.text = [character valueForKey:@"gender"];
    cell.hairColorLabel.text = [character valueForKey:@"hairColor"];
    cell.bioLabel.text = [character valueForKey:@"characterBio"];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 148;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        NSManagedObjectContext *context = self.managedObjectContext;
        
        [context deleteObject:[self.characters objectAtIndex:indexPath.row]];

        [context save:nil];
        
        [self loadData];
    }
}

-(NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath{
    return @"SMOKE MONSTER";
}

@end
