#include <QtWidgets>
#import <AppKit/AppKit.h>

// This example shows how to create and populate a global touch bar
// for a Qt application. The touch bar will be active for all application
// windows.

// Create identifiers for two button items.
static NSTouchBarItemIdentifier Button1Identifier = @"com.myapp.Button1Identifier";
static NSTouchBarItemIdentifier Button2Identifier = @"com.myapp.Button2Identifier";

// We will be replacing the global NSApplication delegate with an instance
// of this TouchBarProvider class. The class implements makeTouchBar which
// creates the touch bar.
@interface TouchBarProvider: NSResponder <NSTouchBarDelegate, NSApplicationDelegate>

@property (strong) NSCustomTouchBarItem *touchbarButton1;
@property (strong) NSCustomTouchBarItem *touchbarButton2;

@end

@implementation TouchBarProvider

- (NSTouchBar *)makeTouchBar
{
    // Create the touch bar with this instance as its delegate
    NSTouchBar *bar = [[NSTouchBar alloc] init];
    bar.delegate = self;
    
    // Add touch bar items: first, the very important emoji picker, followed
    // by a couple of buttons. Note that no further handling of the emoji picker
    // is needed (emojii are automatically routed to any active text edit). Button
    // activation is handled in makeItemForIdentifier below.
    bar.defaultItemIdentifiers = @[NSTouchBarItemIdentifierCharacterPicker, 
                                   Button1Identifier, Button2Identifier];

    return bar;
}

- (NSTouchBarItem *)touchBar:(NSTouchBar *)touchBar makeItemForIdentifier:(NSTouchBarItemIdentifier)identifier
{
    Q_UNUSED(touchBar); 
    
    // Create touch bar items as NSCustomTouchBarItems which can contain any NSView.
    if ([identifier isEqualToString:Button1Identifier]) {
        _touchbarButton1 = [[NSCustomTouchBarItem alloc] initWithIdentifier:identifier];
        _touchbarButton1.view = [[NSButton buttonWithTitle:@"B1" target:self
                                           action:@selector(button1Clicked)] autorelease];
         return self.touchbarButton1;
    } else if ([identifier isEqualToString:Button2Identifier]) {
        _touchbarButton2 = [[NSCustomTouchBarItem alloc] initWithIdentifier:identifier];
        _touchbarButton2.view = [[NSButton buttonWithTitle:@"B2" target:self
                                           action:@selector(button2Clicked)] autorelease];
        return self.touchbarButton2;
    }
   return nil;
}

- (void)button1Clicked
{
    qDebug() << "button1Clicked";
}

- (void)button2Clicked
{
    qDebug() << "button2Clicked";
}
    
@end

int main(int argc, char **argv)
{
    QApplication app(argc, argv);

    QTextEdit *textEdit = nullptr;
    TouchBarProvider *touchBarProvider = nil;

    QTimer::singleShot(0, [&textEdit, &touchBarProvider](){
        textEdit = new QTextEdit();
        textEdit->show();

        TouchBarProvider *touchBarProvider = [[TouchBarProvider alloc] init];
        
        // Replace the global application delegate with our delegate. Note
        // that this removes the Qt internal application delegate. 
        // (TODO: investigate if Qt really needs an app delegate)
        [NSApplication sharedApplication].delegate = touchBarProvider;
    });
		
    int code = app.exec();

    delete textEdit;
    [touchBarProvider release];
    return code;
}
	