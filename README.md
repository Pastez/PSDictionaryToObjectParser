NSDictionary To Object
==========================

__Simple class that helps to parse NSDictionary into Object with corresponding properties.__

> __Be aware__
> 
> that this project was made for fun and it's not tested very well. For me it's good code sniped to remember how to use `<objc/runtime.h>`.

## Installation

Copy __PSDTO__ directory into your project

## Example of usage

#### 1. Create reference to __PSDTO__ *(not required)*
   
   ```
   PSDTO *dto = [PSDTO sharedInstance];
   ```
#### 2. Setup possible destination objects classes
   
   for example:
   
   ```
   [dto addDestinationObject:[SampleObjectA class]];
   [dto addDestinationObject:[SampleObjectB class]];
   [dto addDestinationObject:[SampleObjectC class]];
   ```

#### 3. Examples of usage

  a. __Parse dictionary into object__
  
    returned __`object`__ kind will be determined by the best match to defined destination objects
  
  ```
  [_dto parseDictionary:dictionary onComplete:^(id object)
    {
        
    } 
    onFaild:^(NSException *exception)
    {
        NSLog(@"exception: %@",exception);
    }];
  ```
  
  b. __Check if `dictionary` can be parsed to object class__
  
  ```
  // dictionary to parse
  NSDictionary *dictionary = @{ @"someKey" : @"someValue" };
  
  if( [dto canParseDictionary:dictionary toObjectOfKind:[SampleObjectA class]] )
  {
      NSLog("YES object can be parsed");
  }
  ```
  
  c. __Get `object` dictionary representation__
  
  ```
  NSDictionary *obj = [object propertyListRepresentation];
  ```
  
  
## Sample Project

__Look into `PSViewController.m` to see PSDTO usage in action__

## License

```
15.11.2013
Copyright (C) 2013 Tomasz Kwolek (www.pastez.com).
44-100 Gliwice, Poland

DO WHAT THE FUCK YOU WANT TO.
```
