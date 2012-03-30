//
//  RootViewController.m
//  iPhoneClient
//
//  Created by Apple User on 3/26/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import "RootViewController.h"
#import "ServiceDetailController.h"

NSString* const		kServiceTypeString          = @"_acelistener._tcp.";
NSString* const		kServiceNameString          = @"Desktop listen service";
NSString* const     kSearchDomain               = @"local.";
const	int			kListenPort                 = 8081;

@implementation RootViewController

#pragma mark -
#pragma mark Memory management


- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Relinquish ownership any cached data, images, etc that aren't in use.
}

- (void)dealloc
{
	[services_ release];
    [super dealloc];
}

#pragma mark -
#pragma mark NSNetServiceBrowserDelegate 

- (void) startServiceSearch
{
    browser_		= [[NSNetServiceBrowser alloc] init] ;
    [browser_ setDelegate:self];
    [browser_ searchForServicesOfType:kServiceTypeString inDomain:kSearchDomain];
    
	NSLog(@"Started browsing for services: %@", [browser_ description]);	
    
}

- (void)netServiceBrowser:(NSNetServiceBrowser *)aNetServiceBrowser 
            didFindDomain:(NSString *)domainName moreComing:(BOOL) moreDomainComing
{
    NSLog(@"Found domain : %@", domainName);
}

- (void) netServiceBrowserWillSearch:(NSNetServiceBrowser *)aNetServiceBrowser
{
    NSLog(@"Search will begin!");  
}

- (void)netServiceBrowser:(NSNetServiceBrowser *)aNetServiceBrowser 
           didFindService:(NSNetService *)aNetService 
               moreComing:(BOOL)moreComing 
{
    NSLog(@"Adding new service");
    [services_ addObject:aNetService];
    
    [aNetService setDelegate:self]; 
    [aNetService resolveWithTimeout:5.0];
    // timeout is in seconds !
    
    if (!moreComing) 
        [self.tableView reloadData];
}

- (void)netServiceBrowser:(NSNetServiceBrowser *)aNetServiceBrowser 
         didRemoveService:(NSNetService *)aNetService 
               moreComing:(BOOL)moreComing 
{
    NSLog(@"Removing service");
    
    for (NSNetService* currentNetService in services_) {
        if ([[currentNetService name] isEqual:[aNetService name]] &&
            [[currentNetService type] isEqual:[aNetService type]] &&
            [[currentNetService domain] isEqual:[aNetService domain]]) 
        {
            [services_ removeObject:currentNetService];
            break;
        }
    }
    
    if (!moreComing) 
        [self.tableView reloadData];
}

#pragma mark -
#pragma mark NSNetServiceDelegate

- (void)netServiceWillResolve:(NSNetService *)sender
{
	NSLog(@"RESOLVING net service with name %@ and type %@", [sender name], [sender type]);
}


- (void)netServiceDidResolveAddress:(NSNetService *)sender
{
	NSLog(@"RESOLVED net service with name %@ and type %@", [sender name], [sender type]);
    
    [self.tableView reloadData];
}

- (void)netService:(NSNetService *)sender didNotResolve:(NSDictionary *)errorDict
{
    NSLog(@"NOT RESOLVE service with name %@ and type %@", [sender name], [sender type]);  // ???
	NSLog(@"Error Dict:%@", [errorDict description]);
    
    NSUInteger indexOfService = [services_ indexOfObject:sender];
    if (indexOfService != NSNotFound ) {
        NSIndexPath* path = [NSIndexPath indexPathForRow:indexOfService inSection:1];
        UITableViewCell* failureCell = [self tableView:self.tableView cellForRowAtIndexPath:path];
        failureCell.textLabel.text = @"Failed to resolve address";
    }
    
    
}

#pragma mark -
#pragma mark View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
	// <ADD SOME CODE HERE : Create the service browser and start looking for services> 
    
    services_ = [[NSMutableArray array] retain];
    [self startServiceSearch];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    
    // Relinquish ownership of anything that can be recreated in viewDidLoad or on demand.
    [services_ release];
    services_ = nil;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
	[super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated
{
	[super viewDidDisappear:animated];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation 
{
 // Return YES for supported orientations.
    return YES; // (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark -
#pragma mark Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [services_ count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier] autorelease];
    }
    
	NSNetService* service = [services_ objectAtIndex:indexPath.row];
	NSArray* addresses = [service addresses];

    /*    
     for (NSData* addressData in addresses) {
        struct sockaddr_in* address = (struct sockaddr_in*)[addressData bytes];
     
        NSLog(@"host : %d port : %d", ntohl(address->sin_addr.s_addr), ntohs(address->sin_port)); 
        char hostname[2048];
        char serv[20];
        getnameinfo((const struct sockaddr*) address, sizeof(address), hostname, sizeof(hostname), serv, sizeof((serv), 0));
        NSLog(@"hostname : %s service : %s", hostname, serv);
        NSLog(@"domain : %@", [service domain]);
     }
     */

    cell.textLabel.text = [addresses count]==0 ? @"Could not resolve address" : [service hostName];
	cell.detailTextLabel.text = [service name]; 
	
    return cell;
}

/*
 // Override to support conditional editing of the table view.
 - (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
 {
    // Return NO if you do not want the specified item to be editable.
    return YES;
 }

 // Override to support editing the table view.
 - (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
 {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source.
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view.
    }   
 }

 // Override to support rearranging the table view.
 - (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
 {
 }

 // Override to support conditional rearranging of the table view.
 - (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
 {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
 }
*/

#pragma mark -
#pragma mark Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
	NSNetService* selectedService = [services_ objectAtIndex:indexPath.row];
	
	// if the selection was not resolved, try to resolve it again, but don't attempt
	// to bring up the details >
    if ( [[selectedService addresses] count] <= 0 ) {
        UITableViewCell* selectedCell = [self tableView:self.tableView
                                  cellForRowAtIndexPath:indexPath];
        selectedCell.textLabel.text = @"Attempting to resolve address";
        [selectedService resolveWithTimeout:5.0]; 
        return;
    }
    
    ServiceDetailController* detailController = [[ServiceDetailController alloc] initWithNibName:@"ServiceDetailController" bundle:nil];
	
	detailController.service = selectedService;
    [[self navigationController] pushViewController:detailController animated:YES];
    [detailController release];	
}

@end
