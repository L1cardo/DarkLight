//
//  TouchBar.m
//  DarkLight
//
//  Created by Licardo on 2019/11/6.
//  Copyright © 2019 Licardo. All rights reserved.
//

#import <AppKit/AppKit.h>

extern void DFRElementSetControlStripPresenceForIdentifier(NSTouchBarItemIdentifier, BOOL);
extern void DFRSystemModalShowsCloseBoxWhenFrontMost(BOOL);

@interface NSTouchBarItem ()

+ (void)addSystemTrayItem:(NSTouchBarItem *)item;

@end

@interface NSTouchBar ()

// macOS 10.14 and above
+ (void)presentSystemModalTouchBar:(NSTouchBar *)touchBar systemTrayItemIdentifier:(NSTouchBarItemIdentifier)identifier NS_AVAILABLE_MAC(10.14);

// macOS 10.13 and below
+ (void)presentSystemModalFunctionBar:(NSTouchBar *)touchBar systemTrayItemIdentifier:(NSTouchBarItemIdentifier)identifier NS_DEPRECATED_MAC(10.12.2, 10.14);

@end