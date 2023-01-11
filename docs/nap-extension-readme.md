**Browser extension** (needed to make Comingle work!):
- **[Download for Chrome][1]!** (preferred)
- [Download for Firefox][2]!
**Remember to uninstall it after Hunt!**


Sites that require logins normally don't embed properly in Comingle frames. Unfortunately, this includes useful sites like... the Hunt site, Slack, Google Sheets, basically all the things we want to embed. This extension makes it possible. If you want even more gory details, ask me how!

**Installation on Chrome:**
(installing a custom extension - steps 2-5 - is also demonstrated in [this YouTube video][4])
1. Download the zip file, unzip it as a new folder, somewhere temporary
2. In Chrome, go to the settings menu (three dots), then More Tools, then Extensions
3. Enable "Developer Mode" using the switch at the top-right
4. Click the "Load unpacked" button that has just appeared in the top-left
5. Navigate to the folder that you created in step one, and press the "Select" button
6. You should see the "NotAPlanet Slack Hack" extension appear.
7. Check that it is working by going to Comingle and confirming that you can see Slack loaded in the chat pane of one of the rooms.
   - If we haven't got this year's real Comingle running yet, you can test in either of the [Slack test rooms here][3]

**Installation on Firefox:**
Easier to set up, because there is an app in the appstore, but Firefox prevents us loading Slack in a frame even with the extension in place. If using Firefox, you will have to use Slack outside the Comingle environment.
1. Install the addon at: https://addons.mozilla.org/en-US/firefox/addon/allow-sso-iframes/ by clicking "Add to Firefox"
2. In a non-Comingle window, open a Google Sheets page and the Hunt page, to set cookies correctly
3. Check that it is working by going to Comingle and confirming that you can see Google sheets loaded in the spreadsheet pane of the slack test room.
   - If we haven't got this year's real Comingle running yet, you can test in the [Slack test room here][3]

[1]: https://drive.google.com/u/0/uc?id=15cqr7XBsemih8b37drZ7pS1Y6BqEXxut&export=download "Download for Chrome"
[2]: https://addons.mozilla.org/en-US/firefox/addon/allow-sso-iframes/ "Download for Firefox"
[3]: https://comingle.csail.mit.edu/m/rEbn2fGE2prwyTnZn#NGLL5hXQmw8amPQnL "Comingle Test"
[4]: https://www.youtube.com/watch?v=vW8W19W_X0I "Installing a Chrome extension directly"


**Troubleshooting**

By far the most common issue last year was with cookie settings. Your browser must allow Comingle to set third party cookies. You can either do this by enabling third-party cookies globally, or - in Chrome - by adding an site-specific exception (as shown in the [attached image]). In Firefox, we have to use the "Custom" privacy tier, blocking either no cookies, or only "Cross-site tracking cookies" (also shown [attached]). I wasn't able to figure out a site-specific exception route.

The "turn it off and on again" sequence is:
- Uninstall the extension
- Ensure cookie settings are ok
- Log into Slack, Google and Hunt in your browser of choice (outside of Comingle)
- Install the extension
- Refresh the Comingle site
- (if necessary) log into those sites again in the Comingle frames

If it's still not working and you're in Firefox, try Chrome
If it's still not working and you're in Chrome, let me or Matt Hollenbeck know (but we make no promises about fixing anything complicated during Hunt!)