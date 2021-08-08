#import "AppDelegate.h"
#import <UIKit/UIKit.h>

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(id)options {
  CGRect mainScreenBounds = [[UIScreen mainScreen] bounds];
  self.window = [[UIWindow alloc] initWithFrame:mainScreenBounds];
  UIViewController *viewController = [[UIViewController alloc] init];
  viewController.view.backgroundColor = [UIColor whiteColor];
  viewController.view.frame = mainScreenBounds;

  UILabel *label = [[UILabel alloc] initWithFrame:mainScreenBounds];
  [label setText:@"Wow! I was built with Zig!"];
  [viewController.view addSubview: label];

  self.window.rootViewController = viewController;

  [self.window makeKeyAndVisible];

  return YES;
}

@end

