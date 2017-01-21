# MarsOne

## Calculating Date and Time on Mars

* Date object in Java gives us the time in milliseconds for UTC since 1/1/1970
* Constant number 947116800000 is the time between 1/1/1970 and 1/6/2000
* Subtract that constant out of the _current_ milliseconds for the current milliseconds since 1/6/2000
* Use this algorithm to convert from those milliseconds to MTC:
```MTCseconds = (seconds since 1/1/2000 00:00:00 UTC)*(86400/88775.244)) + 44795.998```

**Figure out what this has been converted to**


## Walk through Zach's data diagram 
