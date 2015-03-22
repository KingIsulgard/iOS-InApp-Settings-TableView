- (void) registerDefaultsFromSettingsBundle
{
    NSLog(@"Registering default values from Settings.bundle");
    NSUserDefaults * defs = [NSUserDefaults standardUserDefaults];
    [defs synchronize];

    NSString *settingsBundle = [[NSBundle mainBundle] pathForResource: @"Settings" ofType: @"bundle"];

    if(!settingsBundle)
    {
        NSLog(@"Could not find Settings.bundle");
        return;
    }

    NSDictionary *settings = [NSDictionary dictionaryWithContentsOfFile:[settingsBundle stringByAppendingPathComponent: @"Root.plist"]];
    NSArray *preferences = [settings objectForKey: @"PreferenceSpecifiers"];
    NSMutableDictionary *defaultsToRegister = [[NSMutableDictionary alloc] initWithCapacity:[preferences count]];

    for (NSDictionary *prefSpecification in preferences)
    {
        NSString *key = [prefSpecification objectForKey:@"Key"];
        if (key)
        {
            // check if value readable in userDefaults
            id currentObject = [defs objectForKey: key];
            if (currentObject == nil)
            {
                // not readable: set value from Settings.bundle
                id objectToSet = [prefSpecification objectForKey: @"DefaultValue"];
                [defaultsToRegister setObject: objectToSet forKey: key];
                NSLog(@"Setting object %@ for key %@", objectToSet, key);
            }
            else
            {
                // already readable: don't touch
                NSLog(@"Key %@ is readable (value: %@), nothing written to defaults.", key, currentObject);
            }
        }
    }

    [defs registerDefaults: defaultsToRegister];
    [defs synchronize];
}
