//
//  ViewController.m
//  DemoCloudObjectiveCApp
//
//  Created by Daniel Diaz on 18/07/23.
//

#import "ViewController.h"

@interface ViewController ()

@property (nonatomic, strong) WKWebView *webView;
@property (nonatomic, strong) NSString *token;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Create a configuration for the web view
    WKWebViewConfiguration *configuration = [[WKWebViewConfiguration alloc] init];
    
    // Create a user content controller and add your view controller as the message handler
    WKUserContentController *userContentController = [[WKUserContentController alloc] init];
    [userContentController addScriptMessageHandler:self name:@"flipgiveAppInterface"];
    
    // Assign the user content controller to the configuration
    configuration.userContentController = userContentController;
    
    // Create the WKWebView with the configuration
    self.webView = [[WKWebView alloc] initWithFrame:self.view.bounds configuration:configuration];
    self.webView.alpha = 0.0;
    
    // Add the WKWebView as a subview to the main view
    [self.view addSubview:self.webView];
    
    // Prompt for a token before executing other actions
    [self promptForTokenWithCompletion:^(NSString *token) {
        if (token) {
            // Handle the token as needed

            // Show the web view now that the token is available
            self.webView.alpha = 1.0;

            // Load a web page in the WKWebView
            NSString *urlString = [NSString stringWithFormat:@"https://cloud.almostflip.com/?token=%@", token];
            NSURL *url = [NSURL URLWithString:urlString];
            NSURLRequest *request = [NSURLRequest requestWithURL:url];
            [self.webView loadRequest:request];
        } else {
            NSLog(@"No token entered");
        }
    }];
}

// Implement the WKScriptMessageHandler method to handle script messages
- (void)userContentController:(WKUserContentController *)userContentController didReceiveScriptMessage:(WKScriptMessage *)message {
    // Handle the message from JavaScript
    NSString *messageBody = (NSString *)message.body;
    NSLog(@"Received message from JavaScript: %@", messageBody);
    
    [self promptForTokenWithCompletion:^(NSString *token) {
        if (token) {
            NSString *jsCallback = [NSString stringWithFormat:@"window.updateToken('%@')", token];

            // Evaluate the JavaScript callback in the web view
            [self.webView evaluateJavaScript:jsCallback completionHandler:^(id result, NSError *error) {
                if (error) {
                    NSLog(@"JavaScript execution error: %@", error.localizedDescription);
                } else {
                    NSLog(@"JavaScript executed successfully");
                    // Additional code to handle success if needed
                }
            }];
        }
    }];
}

- (void)promptForTokenWithCompletion:(void (^)(NSString *))completion {
    dispatch_async(dispatch_get_main_queue(), ^{
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Enter Token"
                                                                                 message:nil
                                                                          preferredStyle:UIAlertControllerStyleAlert];
        [alertController addTextFieldWithConfigurationHandler:^(UITextField *textField) {
            textField.placeholder = @"Token";
        }];
        UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
            UITextField *tokenTextField = alertController.textFields.firstObject;
            NSString *token = tokenTextField.text;
            completion(token);
        }];
        [alertController addAction:okAction];

        [self presentViewController:alertController animated:YES completion:nil];
    });
}

- (void)loadWebViewWithToken:(NSString *)token {
    if (token) {
        // Add your code to handle the token as needed
        
        // Construct the URL with the token as a parameter
        NSString *urlString = [NSString stringWithFormat:@"https://cloud.almostflip.com/?token=%@", token];
        NSURL *url = [NSURL URLWithString:urlString];
        NSURLRequest *request = [NSURLRequest requestWithURL:url];
        
        // Show the web view now that the token is available
        self.webView.alpha = 1.0;
        
        // Load the web page with the token as a URL parameter
        [self.webView loadRequest:request];
    }
}

- (void)webViewDidStartLoad:(WKWebView *)webView {
    // Called when the web view starts loading a web page
    NSLog(@"Web view started loading");
}

- (void)webViewDidFinishLoad:(WKWebView *)webView {
    // Called when the web view finishes loading a web page
    NSLog(@"Web view finished loading");
}

- (void)webView:(WKWebView *)webView didFailLoadWithError:(NSError *)error {
    // Called when the web view fails to load a web page
    NSLog(@"Web view failed to load: %@", error.localizedDescription);
}

@end
