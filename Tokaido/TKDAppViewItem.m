//
//  TKDRailsAppIcon.m
//  Tokaido
//
//  Created by Mucho Besos on 10/26/12.
//  Copyright (c) 2012 Tilde. All rights reserved.
//

#import "TKDAppViewItem.h"

@interface TKDAppViewItem ()
@end

@implementation TKDAppViewItem

- (void)awakeFromNib
{
    [super awakeFromNib];
    self.appController.content = self.representedObject;
    
    [self.showInFinderMenuItem setTarget:self.representedObject];
    [self.showInFinderMenuItem setAction:@selector(showInFinder)];
    [self.showInFinderMenuItem setEnabled:YES];
    
    [self.editMenuItem setTarget:self];
    [self.editMenuItem setAction:@selector(editApp)];
    
    [self.removeMenuItem setTarget:self];
    [self.removeMenuItem setAction:@selector(removeApp)];
    [self.removeMenuItem setEnabled:YES];
    
    [self.activatedMenuItem setTarget:self];
    [self.activatedMenuItem setAction:@selector(activate)];
    [self configureActivatedMenuItem];
    
    [self.representedObject addObserver:self
                             forKeyPath:@"state"
                                options:(NSKeyValueObservingOptionNew|NSKeyValueObservingOptionOld)
                                context:NULL];
}

- (void)activate
{
    TKDApp *app = self.representedObject;
    
    switch (app.state) {
        case TKDAppOff:
            [self.tokaidoController activateApp:app];
            break;
        
        case TKDAppOn:
            [self.tokaidoController deactivateApp:app];
            break;
            
        case TKDAppShuttingDown:
        case TKDAppBooting:
            break;
            
        default:
            break;
    }
}

- (void)configureActivatedMenuItem
{
    TKDApp *app = self.representedObject;
    
    switch (app.state) {
        case TKDAppOff:
            [self.activatedMenuItem setEnabled:YES];
            [self.activatedMenuItem setTarget:self];
            [self.activatedMenuItem setTitle:@"Activate"];
            break;
            
        case TKDAppBooting:
            [self.activatedMenuItem setEnabled:NO];
            [self.activatedMenuItem setTarget:nil];
            [self.activatedMenuItem setTitle:@"Starting up..."];
            break;
            
        case TKDAppOn:
            [self.activatedMenuItem setEnabled:YES];
            [self.activatedMenuItem setTarget:self];
            [self.activatedMenuItem setTitle:@"Deactivate"];
            break;
            
        case TKDAppShuttingDown:
            [self.activatedMenuItem setEnabled:NO];
            [self.activatedMenuItem setTarget:nil];
            [self.activatedMenuItem setTitle:@"Shutting down..."];
            break;
            
        default:
            break;
    }
}

- (void)observeValueForKeyPath:(NSString*)keyPath
                      ofObject:(id)object
                        change:(NSDictionary*)change
                       context:(void*)context
{
	if ([keyPath isEqualToString:@"state"]) {
        [self configureActivatedMenuItem];
	} else {
        [super observeValueForKeyPath:keyPath
                             ofObject:object
                               change:change
                              context:context];
    }
}

- (void)tokenField:(TKDRailsAppTokenField *)tokenField clickedWithEvent:(NSEvent *)event;
{
    [NSMenu popUpContextMenu:self.appMenu withEvent:event forView:self.view];
}

- (NSString *)titleForTokenField:(TKDRailsAppTokenField *)tokenField;
{
    TKDApp *app = (TKDApp *)self.representedObject;
    return app.appHostname;
}

- (void)editApp
{
    [self.tokaidoController showEditWindowForApp:self.representedObject];
}

- (void)removeApp
{
    [self.tokaidoController removeApp:self.representedObject];
}

- (void)setSelected:(BOOL)selected
{
    [super setSelected:selected];
    [self.appIcon setSelected:selected];
}

- (TKDApp *)app
{
    return self.representedObject;
}

@end
