//
//  ViewController.m
//  example
//
//  Created by oximeeg on 2020/12/21.
//

#import "ViewController.h"

@import UserNotifications;

@interface ViewController () <UNUserNotificationCenterDelegate>

@property (nonatomic, weak) IBOutlet UITextField *titleText;
@property (nonatomic, weak) IBOutlet UITextField *bodyText;

@end

@implementation ViewController

#pragma mark - IB

- (IBAction)onAuthorization:(UIButton *)sender {
    NSLog(@"• onAuthorization");
    [self requestAuthorization];
}

- (IBAction)onNotification:(UIButton *)sender {
    NSLog(@"• onNotification");
    [self notification];
}

- (IBAction)onClear:(UIButton *)sender {
    NSLog(@"• onClear");
    [self clear];
}

#pragma mark - private

- (void)requestAuthorization {
    UNUserNotificationCenter *center = [UNUserNotificationCenter currentNotificationCenter];
    [center requestAuthorizationWithOptions:(UNAuthorizationOptionBadge | UNAuthorizationOptionSound | UNAuthorizationOptionAlert)
                          completionHandler:^(BOOL granted, NSError * _Nullable error) {
        if (!error) {
            NSLog(@"• error:%@", error);
        }
    }];
}

- (void)notification {
    UNMutableNotificationContent *content = [self notificationContent:self.titleText.text
                                                                 body:self.bodyText.text];

    UNNotificationRequest *request = [UNNotificationRequest requestWithIdentifier:[self identifier]
                                                                          content:content
                                                                          trigger:[self trigger]];

    UNUserNotificationCenter *center = [UNUserNotificationCenter currentNotificationCenter];
    center.delegate = self;

    [center addNotificationRequest:request
             withCompletionHandler:^(NSError * _Nullable error) {
        if (!error) {
            NSLog(@"• error:%@", error);
        }
    }];
}

- (NSString *)identifier {
    return [NSString stringWithFormat:@"%f", [[NSDate date] timeIntervalSince1970]];
}

- (UNMutableNotificationContent *)notificationContent:(NSString *)title
                                                 body:(NSString *)body {
    UNMutableNotificationContent *content = [[UNMutableNotificationContent alloc] init];
    content.title = title;
    content.body = body;
    content.sound = [UNNotificationSound defaultSound];
    content.badge = @([[UIApplication sharedApplication] applicationIconBadgeNumber] + 1);
    return content;
}

- (UNNotificationTrigger *)trigger {
    return [UNTimeIntervalNotificationTrigger triggerWithTimeInterval:0.1
                                                              repeats:NO];
}

- (void)clear {
    [[UNUserNotificationCenter currentNotificationCenter] removeAllPendingNotificationRequests];
    [[UIApplication sharedApplication] setApplicationIconBadgeNumber:0];
}

#pragma mark - UNUserNotificationCenterDelegate

- (void)userNotificationCenter:(UNUserNotificationCenter *)center
       willPresentNotification:(UNNotification *)notification
         withCompletionHandler:(void (^)(UNNotificationPresentationOptions))handler {

    NSLog(@"• willPresentNotification");
    handler(UNNotificationPresentationOptionBadge |
            UNNotificationPresentationOptionSound |
            UNNotificationPresentationOptionList |
            UNNotificationPresentationOptionBanner);
}

- (void)userNotificationCenter:(UNUserNotificationCenter *)center
didReceiveNotificationResponse:(UNNotificationResponse *)response
         withCompletionHandler:(void(^)(void))completionHandler {

    NSLog(@"• didReceiveNotificationResponse");
    completionHandler();
}

#pragma mark - textField

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return NO;
}

@end

