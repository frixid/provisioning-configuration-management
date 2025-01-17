#!/bin/bash

case "${1:-''}" in
    'start')
        if test -f /tmp/selenium.pid
        then
            echo "Selenium is already running."
        else
            export DISPLAY=localhost:99.0
            java -jar {{ selenium_folder }}/{{ selenium_jar }} -role {{ selenium_config }} > {{ selenium_logs }}/output.log 2> {{ selenium_logs }}/error.log & echo $! > /tmp/selenium.pid
            echo "Starting Selenium..."

            error=$?
            if test $error -gt 0
            then
                echo "${bon}Error $error! Couldn't start Selenium!${boff}"
            fi
        fi
    ;;
    'stop')
        if test -f /tmp/selenium.pid
        then
            echo "Stopping Selenium..."
            PID=`cat /tmp/selenium.pid`
            kill -3 $PID
            if kill -9 $PID ;
                then
                    sleep 2
                    test -f /tmp/selenium.pid && rm -f /tmp/selenium.pid
                else
                    echo "Selenium could not be stopped..."
                fi
        else
            echo "Selenium is not running."
        fi
        ;;
    'restart')
        if test -f /tmp/selenium.pid
        then
            kill -HUP `cat /tmp/selenium.pid`
            test -f /tmp/selenium.pid && rm -f /tmp/selenium.pid
            sleep 1
            export DISPLAY=localhost:99.0
            java -jar {{ selenium_folder }}/{{ selenium_jar }} -role {{ selenium_config }} > {{ selenium_logs }}/output.log 2> {{ selenium_logs }}/error.log & echo $! > /tmp/selenium.pid
            echo "Reload Selenium..."
        else
            echo "Selenium isn't running..."
        fi
        ;;
    *)      # no parameter specified
        echo "Usage: $SELF start|stop|restart"
        exit 1
    ;;
esac