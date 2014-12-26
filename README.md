Runif
=====

*runif runs commands only when a given environment variable is set.*


Usage
-----

	Usage:
	  runif [OPTIONS] Key Command Args...

	Application Options:
	  -d, --delay-exit=SECONDS    Delay program exit by this many seconds when command does not get run (0)
	  -e, --exit-with-error       Exit with non-zero exit status when Key is unset or false (false)

	Help Options:
	  -h, --help                  Show this help message

	Arguments:
	  Key:                        The name of the environment variable that must be true in order for command to be run
	  Command:                    The command to run
	  Args:                       Arguments to pass to command


Example
-------

The following invocation will run cron in the foreground if there is an environment variable `RUN_CRON` with a value that evaluates to true (*"1"*, *"yes"* or *"true"*):
 
    runif RUN_CRON -- cron -f
    
*Note: The `--` denotes the end of argument flags to runif. This ensures the `-f` flag to cron isn't interpreted as a flag to runif.*


License
-------

The MIT License (MIT)

Copyright (c) 2014 Nick Groenen <nick@groenen.me>

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in
all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
THE SOFTWARE.
