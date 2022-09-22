### Functionality

This is a small program, tracking the time spent on various tasks. We are going to assume that we are only working on one task at a time. When the timer is stopped, we cannot start it again without creating a new task.

### Prerequisites

In order to use do command <chmod a+x track.sh> and then <source track.sh>
IMPORTANT: first time use do following:
Start program
0.
```
source track.sh
``` 
1.
```
track start
```
2. Close terminal (env var has been set but terminal needs to close and open again to take effect.)
3. Open the terminal again
4. type
```
source track.sh

```
And this should be it.



### Usage

Please start by starting a task of your choosing with 

```bash
track start task_name

```
To end the current task use:
```bash
track stop 

```
To get status info use
```bash
track status 

```
To get the log info:
```bash
track log 

```
