//
//  ViewController.m
//  GuestBook
//
//  Created by Vaishakh on 10/20/14.
//  Copyright (c) 2014 GuestBook. All rights reserved.
//

#import "ViewController.h"
#import "TFHpple.h"
#import "UIColor+HexKit.h"
#import "ELTextView.h"
#import "Constants.h"
#import "SDWebImage/UIImageView+WebCache.h"

@interface ViewController ()<UITextViewDelegate,UITextFieldDelegate,  NSURLConnectionDelegate>

@property (strong, nonatomic) IBOutlet UITextField *stackSelectTxtField;


@property (strong, nonatomic) IBOutlet UIButton *actionButton;
@property (strong, nonatomic) IBOutlet ELTextView *urlSearchTxtField;

@property (strong, nonatomic) UIActivityIndicatorView *spin;
@property (strong, nonatomic) NSMutableData *responseData;
@property (strong, nonatomic) IBOutlet UITextField *titleTxtField;
@property (strong, nonatomic) IBOutlet UIImageView *ogImageView;
@property (strong, nonatomic) IBOutlet UITextView *descriptionTextView;

@property (assign) CGFloat searchTextFieldY;
@property (assign) BOOL isDataViewExpanded;

@property (strong, nonatomic) IBOutlet UISwitch *cardSwitch;
@property (strong, nonatomic) NSString *lastSearchedUrl;

- (IBAction)actionButtonClicked:(id)sender;
@property (strong, nonatomic) IBOutlet UIView *containerView;


@end

@implementation ViewController



- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.navigationController.navigationBar.barTintColor = [UIColor colorFromHexCode:@"00A267"];
    
    NSDictionary *textAttributes = [NSDictionary dictionaryWithObjectsAndKeys:
                                    [UIColor whiteColor],NSForegroundColorAttributeName,
                                    [UIColor whiteColor],NSBackgroundColorAttributeName,nil];
    self.navigationController.navigationBar.titleTextAttributes = textAttributes;
    self.title = @"GUIDEPOST";
    self.view.backgroundColor = [UIColor colorFromHexCode:@"E3E8E7"];
    _actionButton.layer.cornerRadius = _actionButton.bounds.size.width / 2.0;
    [_actionButton setBackgroundColor:[UIColor colorFromHexCode:@"F1F4F3"]];
    
    [_actionButton setImage:[UIImage imageNamed:@"download_disable.png"] forState:UIControlStateDisabled];
    [_actionButton setImage:[UIImage imageNamed:@"download_active.png"] forState:UIControlStateNormal];
    
    _urlSearchTxtField.delegate = self;
    _urlSearchTxtField.text = kPlaceholder;
    _descriptionTextView.text = kDescriptionPlaceholder;
    
    [_actionButton setEnabled:NO];
    _urlSearchTxtField.text = @"https://www.facebook.com/thebeatles";
    _searchTextFieldY = _actionButton.frame.origin.y;
    
    _lastSearchedUrl = [[NSString alloc] init];
    // Add extra left Indentation to Title Text Field
    UIView *spacerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, 10)];
    [_titleTxtField setLeftViewMode:UITextFieldViewModeAlways];
    [_titleTxtField setLeftView:spacerView];
    
    //
    // Assign Tags
    _urlSearchTxtField.tag = kUrlTag;
    _descriptionTextView.tag = kDescriptionTag;
    _titleTxtField.tag = kDescriptionTag;
    
    _stackSelectTxtField.rightViewMode = UITextFieldViewModeAlways;
    UIImageView *rightImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"dropdown"]];
    _stackSelectTxtField.rightView = rightImageView;
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidAppear:(BOOL)animated
{
    CGRect actBtnFrame = _actionButton.frame;
    actBtnFrame.origin.y = 154;
    _actionButton.frame = actBtnFrame;
    _containerView.alpha = 0;
    _cardSwitch.transform = CGAffineTransformMakeScale(0.75, 0.75);
    _spin = [[UIActivityIndicatorView alloc]
             initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    _spin.center = _actionButton.center;
    [_actionButton.superview insertSubview:_spin aboveSubview:_actionButton];
}

// Validate URL
- (BOOL)validateUrl : (NSString *)urlString
{
    NSString *urlRegEx =
    @"(http|https)://((\\w)*|([0-9]*)|([-|_])*)+([\\.|/]((\\w)*|([0-9]*)|([-|_])*))+";
    NSPredicate *urlPredic = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", urlRegEx];
    BOOL isValidURL = [urlPredic evaluateWithObject:urlString];
    return isValidURL;
}


- (IBAction)actionButtonClicked:(id)sender {
    
    [_spin startAnimating];
    _actionButton.userInteractionEnabled = NO;
    [_actionButton setImage:[[UIImage alloc] init] forState:UIControlStateNormal];
    _lastSearchedUrl = _urlSearchTxtField.text;
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:_urlSearchTxtField.text]];
    //Create url connection and fire request
    NSURLConnection *conn = [[NSURLConnection alloc] initWithRequest:request delegate:self];
    
}

- (void)collapseContainerView
{
    _isDataViewExpanded = NO;
    _titleTxtField.text = kEmptyString;
    _descriptionTextView.text = kEmptyString;
    _ogImageView.image = [UIImage imageNamed:@"camera_placeholder.png"];
    
    [UIView animateWithDuration:0.5f
                     animations:^{
                         [_containerView setAlpha:0.0f];
                         CGRect frame = _containerView.frame;
                         frame.origin.y = 154;
                         _containerView.frame = frame;
                         
                         CGRect actBtnFrame = _actionButton.frame;
                         actBtnFrame.origin.y = 154;
                         _actionButton.frame = actBtnFrame;
                         
                     }
     ];
    
}

#pragma mark - UITextView Delegates

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    
    if(textView.tag == kUrlTag)
    {
        NSString *newUrl = [textView.text stringByReplacingCharactersInRange:range withString:text];
        if(_isDataViewExpanded)
        {
            if (![newUrl isEqualToString:_lastSearchedUrl])
            {
                [_actionButton setImage:[UIImage imageNamed:@"download_active.png"] forState:UIControlStateNormal];
                [self collapseContainerView];
            }
        }
        
        NSString *urlPrependHttp = [NSString stringWithFormat:@"http://%@",newUrl];
        NSString *urlPrependHttps = [NSString stringWithFormat:@"https://%@",newUrl];
        
        if ([self validateUrl:newUrl] || [self validateUrl:urlPrependHttp] || [self validateUrl:urlPrependHttps])
        {
            [_actionButton setEnabled:YES];
        }
        else
        {
            [_actionButton setEnabled:NO];
        }
    }
    return YES;
}

- (void)textViewDidBeginEditing:(UITextView *)textView
{
    if(textView.tag == kUrlTag)
    {
        if ([textView.text isEqualToString:kPlaceholder])
        {
            textView.text = kEmptyString;
            textView.textColor = [UIColor darkGrayColor]; //optional
        }
    }
    else if(textView.tag == kDescriptionTag)
    {
        if ([textView.text isEqualToString:kDescriptionPlaceholder])
        {
            textView.text = kEmptyString;
            textView.textColor = [UIColor darkGrayColor]; //optional
        }
    }
    [textView becomeFirstResponder];
}

- (void)textViewDidEndEditing:(UITextView *)textView
{
    if(textView.tag == kUrlTag)
    {
        if ([textView.text isEqualToString:kEmptyString]) {
            textView.text = kPlaceholder;
            textView.textColor = [UIColor lightGrayColor]; //optional
        }
    }
    else if (textView.tag == kDescriptionTag)
    {
        if ([textView.text isEqualToString:kEmptyString]) {
            textView.text = kDescriptionPlaceholder;
            textView.textColor = [UIColor lightGrayColor]; //optional
        }
    }
    [textView resignFirstResponder];
}

#pragma mark - UITextField Delegates


- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    //[textField resignFirstResponder];
    return YES;
}


#pragma mark NSURLConnection Delegate Methods

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {
    // A response has been received, this is where we initialize the instance var you created
    // so that we can append data to it in the didReceiveData method
    // Furthermore, this method is called each time there is a redirect so reinitializing it
    // also serves to clear it
    _responseData = [[NSMutableData alloc] init];
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
    // Append the new data to the instance variable you declared
    [_responseData appendData:data];
}

- (NSCachedURLResponse *)connection:(NSURLConnection *)connection
                  willCacheResponse:(NSCachedURLResponse*)cachedResponse {
    // Return nil to indicate not necessary to store a cached response for this connection
    return nil;
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
    // The request is complete and data has been received
    // You can parse the stuff in your instance variable now
    
    [_spin stopAnimating];
    _isDataViewExpanded = YES;
    _urlSearchTxtField.userInteractionEnabled = YES;
    _actionButton.userInteractionEnabled = YES;
    [_urlSearchTxtField resignFirstResponder];
    [_actionButton setImage:[UIImage imageNamed:@"done.png"] forState:UIControlStateNormal];
    
    TFHpple *ogDataParser = [TFHpple hppleWithHTMLData:_responseData];
    
    NSString *imageXpathQueryString = @"//meta[@property='og:image']/@content";
    NSArray *imageNodes = [ogDataParser searchWithXPathQuery:imageXpathQueryString];
    if ([imageNodes count] > 0)
    {
        TFHppleElement *element = (TFHppleElement *)[imageNodes objectAtIndex:0];
        [_ogImageView setImageWithURL:[NSURL URLWithString:[[element firstChild] content]] placeholderImage:[UIImage imageNamed:@"camera_placeholder.png"]];
        
    }
    
    NSString *titleXpathQueryString = @"//meta[@property='og:title']/@content";
    NSArray *titleNodes = [ogDataParser searchWithXPathQuery:titleXpathQueryString];
    if ([titleNodes count] > 0)
    {
        TFHppleElement *element = (TFHppleElement *)[titleNodes objectAtIndex:0];
        _titleTxtField.text = [[element firstChild] content];
    }
    
    NSString *descriptionXpathQueryString = @"//meta[@property='og:description']/@content";
    NSArray *descriptionNodes = [ogDataParser searchWithXPathQuery:descriptionXpathQueryString];
    if ([descriptionNodes count] > 0)
    {
        TFHppleElement *element = (TFHppleElement *)[descriptionNodes objectAtIndex:0];
        _descriptionTextView.text = [[element firstChild] content];
    }
    
    [UIView animateWithDuration:0.5f
                     animations:^{
                         [_containerView setAlpha:1.0f];
                         CGRect frame = _containerView.frame;
                         frame.origin.y = _urlSearchTxtField.frame.origin.y + _urlSearchTxtField.frame.size.height + 5;
                         _containerView.frame = frame;
                         
                         CGRect actBtnFrame = _actionButton.frame;
                         actBtnFrame.origin.y = (_containerView.frame.origin.y+_containerView.frame.size.height)+10;
                         _actionButton.frame = actBtnFrame;
                         
                     }
     ];
    
    
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
    // The request has failed for some reason!
    // Check the error var
  
    [_spin stopAnimating];
    _isDataViewExpanded = YES;
    _actionButton.userInteractionEnabled = YES;
    _urlSearchTxtField.userInteractionEnabled = YES;
     [_urlSearchTxtField resignFirstResponder];
    [_actionButton setImage:[UIImage imageNamed:@"done.png"] forState:UIControlStateNormal];
    
    [UIView animateWithDuration:0.5f
                     animations:^{
                         [_containerView setAlpha:1.0f];
                         CGRect frame = _containerView.frame;
                         frame.origin.y = _urlSearchTxtField.frame.origin.y + _urlSearchTxtField.frame.size.height + 5;
                         _containerView.frame = frame;
                         
                         CGRect actBtnFrame = _actionButton.frame;
                         actBtnFrame.origin.y = (_containerView.frame.origin.y+_containerView.frame.size.height)+10;
                         _actionButton.frame = actBtnFrame;
                         
                     }
     ];
}

@end
