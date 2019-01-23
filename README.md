
## VCScrollTabBar

![Platform](http://img.shields.io/badge/platform-iOS-red.svg?style=flat
)
![Language](http://img.shields.io/badge/language-objective_c-brightgreen.svg?style=flat
)
[![License](http://img.shields.io/badge/license-MIT-lightgrey.svg?style=flat
)](http://mit-license.org)

### VCScrollTabBar is simple ScrollTabBar component for iOS (Obj-C)

#### VCScrollTabBar with center indicator
<img src="Center Indicator.gif" width="300"></br>
#### VCScrollTabBar with bottom indicator
<img src="Bottom Indicator.gif" width="300">


## Usage
Just drag the folder 'ScrollViewTabBar' into your project.
###### Bottom Indicator
```objective-c
VCScrollTabBarConfig *config = [VCScrollTabBarConfig defaultConfig];
    
VCScrollTabBarConfig *scrollTabBar = [[VCScrollTabBar alloc] init];
[scrollTabBar configureTitleInfos:self.titleInfos config:config scrollView:self.scrollView tarBarDelegate:self];

```
###### Center Indicator
```objective-c
VCScrollTabBarConfig *config = [VCScrollTabBarConfig defaultConfig];
config.showCenterIndicatorView = YES;
config.showBottomIndicatorView = NO;
    
VCScrollTabBarConfig *scrollTabBar = [[VCScrollTabBar alloc] init];
[scrollTabBar configureTitleInfos:self.titleInfos config:config scrollView:self.scrollView tarBarDelegate:self];

```
###### VCScrollTabBarConfig 
```objective-c
// You can adjust the config to change scrollTabBar style.

VCScrollTabBarConfig *config = [VCScrollTabBarConfig defaultConfig];

//Center indicator view color
config.centerIndicatorViewColor

//Show hide the center indicator view
config.showCenterIndicatorView;

//BottomIndicatorView color.
config.bottomIndicatorViewColor;

//Selected tabBar button title font size.
config.buttonTitleMaxFont

...

```

## Feature
* Easy to use, just call configureTitleInfos:config:scrollView:tarBarDelegate:
* Available for all size (iPhone / iPad)
* Support multiple style Indicator


## License

VCScrollTabBar is available under the MIT license. See the LICENSE file for more info.
