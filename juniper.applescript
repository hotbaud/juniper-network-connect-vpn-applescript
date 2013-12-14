#!/usr/bin/osascript

-- Juniper Network Connect manipulation script
-- Author: Sean Fisk
-- Adapted for Juniper Network Connect 7.3.4 (24309) by Anne Marie Merritt (amerritt@vmware.com)
-- References:
-- * <http://scdidadm.tumblr.com/post/5579178924/juniper-network-connect-applescript-start-stop>
-- * <http://hintsforums.macworld.com/showthread.php?t=99264>

-- Usage: juniper gatewayHostName username password

property appName : "Network Connect"

on run argv

	try
		if (system attribute "sysv") < 4138 then display dialog "This script requires the installation of Mac OS X 10.3 or higher." buttons {"Cancel"} default button 1 with icon 2
		tell application "System Events" to if not UI elements enabled then
			tell me
				activate
				display dialog "This script requires the built-in Graphic User Interface Scripting architecture of Mac OS X, which is currently disabled."
			end tell
			set UI elements enabled to true
			if not UI elements enabled then error number -128
		end if
	on error
		return "You need to enable AppleScript Events and possibly Terminal Events in the Security and Privacy settings of Mavericks Preferences for this script to work."
	end try

        if (count of argv) is not equal to 3 then
                -- FIXME: even returning here still starts Network Connect... the return apparently only returns from the if statement. Not sure how to fix yet.
                return "Usage: juniper.applescript gatewayHostName username password"
        end if
        -- `password' is a keyword, so don't use it as a variable name.
        set {gatewayHostName, username, pw} to argv
        -- Cannot use the `appName' property in this tell statement for some reason
        tell application "Network Connect"
                if connected then
                        sign out
                        -- Need to give Network Connect time to log out. If not, it will bother us next time with the "Continue the session" stuff. That's more buttons to click, so let's log out the right way.
                        delay 10
                        quit
                else
                        connect to gatewayHostName
                        delay 5
						tell application "System Events"
						-- FIXME:  Could do a version check here and perform the relevant text field references for the given version.
							set value of text field 1 of group 8 of UI element 1 of scroll area 1 of window appName of application process appName to username
							set value of text field 1 of group 11 of UI element 1 of scroll area 1 of window appName of application process appName to pw
							click button "Sign In" of group 15 of UI element 1 of scroll area 1 of window appName of application process appName
				
							-- AppleScript prints the last object that's returned. We don't want it to print the button that it fetched, so just return nothing.
							return
						end tell
                end if
        end tell
end run
