//
//  ViewController.m
//  MeetupDemo
//
//  Created by Marc Hampson on 12/01/2017.
//  Copyright © 2017 Marc Hampson. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()
@property (strong, nonatomic) IBOutlet UIImageView *imageView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Languages are used for recognition (e.g. eng, ita, etc.). Tesseract engine
    // will search for the .traineddata language file in the tessdata directory.
    // For example, specifying "eng+ita" will search for "eng.traineddata" and
    // "ita.traineddata". Cube engine will search for "eng.cube.*" files.
    // See https://github.com/tesseract-ocr/tessdata.
    
    // Create your G8Tesseract object using the initWithLanguage method:
    G8Tesseract *tesseract = [[G8Tesseract alloc] initWithLanguage:@"eng"];
    
    // Optionaly: You could specify engine to recognize with.
    // G8OCREngineModeTesseractOnly by default. It provides more features and faster
    // than Cube engine. See G8Constants.h for more information.
    //tesseract.engineMode = G8OCREngineModeTesseractOnly;
    
    // Cube is an additional recognition engine using neural networks and will give
    // better results but slower.
    //tesseract.engineMode = G8OCREngineModeTesseractCubeCombined;
    
    
    // Set up the delegate to receive Tesseract's callbacks.
    // self should respond to TesseractDelegate and implement a
    // "- (BOOL)shouldCancelImageRecognitionForTesseract:(G8Tesseract *)tesseract"
    // method to receive a callback to decide whether or not to interrupt
    // Tesseract before it finishes a recognition.
    tesseract.delegate = self;
    
    // Optional: Limit the character set Tesseract should try to recognize from
    //tesseract.charWhitelist = @"0123456789";
    //tesseract.charWhitelist = @"T";
    //tesseract.charWhitelist = @"GOBEYOND";
    
    
    // This is wrapper for common Tesseract variable kG8ParamTesseditCharWhitelist:
    // [tesseract setVariableValue:@"0123456789" forKey:kG8ParamTesseditCharBlacklist];
    // See G8TesseractParameters.h for a complete list of Tesseract variables
    
    // Optional: Limit the character set Tesseract should not try to recognize from
    //tesseract.charBlacklist = @"OoZzBbSs";
    //tesseract.charBlacklist = @"aAbBcCdDeEfFgGhHiIjJkKlLmMnNoOpPqQrRsStTuUvVwWxXyYzZ£-@#";
    
    // Specify the image Tesseract should recognize on
    //tesseract.image = [[UIImage imageNamed:@"image_sample.jpg"] g8_blackAndWhite];
    tesseract.image = [[UIImage imageNamed:@"Thursdays.png"] g8_blackAndWhite];
    //tesseract.image = [UIImage imageNamed:@"receipt.jpg"];
    
    // Optional: Limit the area of the image Tesseract should recognize on to a rectangle
    //tesseract.rect = CGRectMake(0, 0, 600, 1000);
    
    // Optional: Limit recognition time with a few seconds
    //tesseract.maximumRecognitionTime = 2.0;
    
    // Start the recognition
    [tesseract recognize];
    
    // Retrieve the recognized text
    NSLog(@"%@", [tesseract recognizedText]);
    
    // You could retrieve more information about recognized text with that methods:
    
    NSArray *characterBoxes = [tesseract confidencesByIteratorLevel:G8PageIteratorLevelSymbol];
    UIImage *imageWithBlocks = [tesseract imageWithBlocks:characterBoxes drawText:YES thresholded:NO];
    
    [_imageView setImage:imageWithBlocks];
    
}

- (void)progressImageRecognitionForTesseract:(G8Tesseract *)tesseract {
    NSLog(@"progress: %lu", (unsigned long)tesseract.progress);
}

- (BOOL)shouldCancelImageRecognitionForTesseract:(G8Tesseract *)tesseract {
    return NO;  // return YES, if you need to interrupt tesseract before it finishes
}


@end
