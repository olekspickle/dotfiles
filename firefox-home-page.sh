#!/bin/bash

set -e
echo Installing flatpak...



# 1.Go to about:support in the address bar. 
# 2.View the section "Application Basics" ➔ Profile Directory (or "Profile Folder" on MacOS) ➔ 
# click the button "Open Directory" (or "Show in Finder" on MacOS)
# It should open your Firefox profile directory, which is usually in your $HOME directory.
# 3.Create a directory called chrome inside the opened directory, if it's not already there.
# 4.Go to the chrome directory and (a) create a directory called img and (b) create a file called userContent.css. Move your image to the img directory.
# 5.Open userContent.css in any text editor and paste the following code:

css=<<EOL
@-moz-document url(about:home), url(about:newtab), url(about:privatebrowsing) {
    .click-target-container *, .top-sites-list * {
        color: #fff !important ;
        text-shadow: 2px 2px 2px #222 !important ;
    }

    body::before {
        content: "" ;
        z-index: -1 ;
        position: fixed ;
        top: 0 ;
        left: 0 ;
        background: #f9a no-repeat url(img/home.jpg) center ;
        background-size: cover ;
        width: 100vw ;
        height: 100vh ;
    }
}
EOL



# Don't forget to change the image name to img/home.jpg
# 6.Go to the url about:config, accept the risk (we will not really do anything harmful here, nothing to worry about), and in the Search Bar, paste toolkit.legacyUserProfileCustomizations.stylesheets, and set the value to true. This tells Firefox to load the CSS file at startup.
# 7. Restart Firefox if it's running.
