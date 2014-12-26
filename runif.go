/*
	runif runs commands only when a given environment variable is set.

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
*/
package main

import (
	"fmt"
	"github.com/jessevdk/go-flags"
	"os"
	"os/exec"
	"strings"
	"syscall"
	"time"
)

var opts struct {
	DelayExit     int  `short:"d" long:"delay-exit" default:"0" value-name:"SECONDS" description:"Delay program exit by this many seconds when command does not get run"`
	ExitWithError bool `short:"e" long:"exit-with-error" default:"false" description:"Exit with non-zero exit status when Key is unset or false"`

	Positional struct {
		Key     string   `description:"The name of the environment variable that must be true in order for command to be run"`
		Command string   `description:"The command to run"`
		Args    []string `description:"Arguments to pass to command"`
	} `positional-args:"yes" required:"yes"`
}

// ParseFlags parses the argument flags passed to the program
// or exits accordingly if parsing fails.
func ParseFlags() {
	_, err := flags.Parse(&opts)
	if err != nil {
		e := err.(*flags.Error)
		switch e.Type {
		case flags.ErrTag:
			// ErrTag means you have messed up the tags in the opts struct
			panic(e.Message)
		case flags.ErrHelp:
			// ErrHelp means -h or --help was passed.
			os.Exit(0)
		default:
			os.Exit(1)
		}
	}
}

// ExecCommand executes the given command with given arguments.
// Program execution will terminate with an appropriate error if the command
// cannot be executed.
func ExecCommand(command string, args []string) {
	binary, err := exec.LookPath(command)
	if err != nil {
		fmt.Fprintln(os.Stderr, err)
		os.Exit(1)
	}

	args = append([]string{command}, args...)
	err = syscall.Exec(binary, args, os.Environ())
	if err != nil {
		panic(err)
	}
}

// IsTruthy returns true if the value of s is truthy.
// Truthy is determined to be the values "1", "yes" and "true" in any variation
// of capitalization.
func IsTruthy(s string) bool {
	upper := strings.ToUpper(s)
	return (upper == "YES" || upper == "TRUE" || upper == "1")
}

func main() {
	ParseFlags()

	if IsTruthy(os.Getenv(opts.Positional.Key)) {
		ExecCommand(opts.Positional.Command, opts.Positional.Args)
	} else {
		time.Sleep(time.Duration(opts.DelayExit) * time.Second)
		if opts.ExitWithError {
			os.Exit(1)
		}
	}
}
