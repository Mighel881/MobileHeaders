#import "MHRootViewController.h"
#define ALERT(str) [[[UIAlertView alloc] initWithTitle:str message:@"" delegate:self cancelButtonTitle:@"ok" otherButtonTitles:nil] show]
@implementation MHRootViewController 
-(id)initWithURL:(NSURL *)url {
	if ((self = [super init])) {
		_cellIdentifier = @"MHCell";
		if (!url) {
			self.directoryURL = [NSURL URLWithString:[[NSString stringWithFormat:@"%@%@", [[[NSBundle mainBundle] resourceURL] absoluteString], @"Data"] stringByReplacingOccurrencesOfString:@"file://" withString:@""]];
		} else {
			self.directoryURL = url;
		}
	}
	return self;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	return self.entries.count;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	[self.tableView deselectRowAtIndexPath:indexPath animated:YES];
	MHTableEntry *currentObject = [self.entries objectAtIndex:indexPath.row];
	if (currentObject.isDirectory) {
		MHRootViewController *newViewController = [[MHRootViewController alloc] initWithURL:currentObject.url];
		[self.navigationController pushViewController: newViewController animated:YES];
	} else {
		MHHeaderViewController *headerViewController = [[MHHeaderViewController alloc] initWithURL:currentObject.url];
		[self.navigationController pushViewController: headerViewController animated:YES];
	}

}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
	MHTableEntry *entry = self.entries[indexPath.row];
	cell.textLabel.text = entry.name;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	UITableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:_cellIdentifier];
	if (!cell) {
		cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:_cellIdentifier];
	}
	return cell;
}
-(void)loadEntries {
	self.entries = [NSMutableArray new];
	NSFileManager *fileManager = [NSFileManager defaultManager];
	NSArray *properties = [NSArray arrayWithObjects: NSURLLocalizedNameKey, nil];
	NSError *error = nil;
	NSMutableArray *URLs = [[fileManager contentsOfDirectoryAtURL:self.directoryURL
								includingPropertiesForKeys:properties
                   				options:(NSDirectoryEnumerationSkipsPackageDescendants)
                   				error:&error] mutableCopy];
	for (NSURL *url in URLs) {
		MHTableEntry *fileObject = [[MHTableEntry alloc] initWithURL:url];
		[self.entries addObject:fileObject];
	}
}
-(void)setup {
	[self loadEntries];
	self.tableView = [[UITableView alloc] initWithFrame:self.view.bounds];
	[self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:_cellIdentifier];

	self.tableView.delegate = self;
	self.tableView.dataSource = self;

	[self.view addSubview:self.tableView];

	/*MHSDKInstallerController *installerController = [[MHSDKInstallerController alloc] init];
	[self.navigationController pushViewController:installerController animated:YES];*/
}

-(void)viewDidLoad {
	[super viewDidLoad];
	[self setup];
}
@end