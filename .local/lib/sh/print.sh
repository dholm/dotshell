NORMAL=$(tput sgr0)
GREEN=$(tput setaf 2)
YELLOW=$(tput setaf 3)
RED=$(tput setaf 1; tput bold)

function red { echo -e "$RED$*$NORMAL"; }
function green { echo -e "$GREEN$*$NORMAL"; }
function yellow { echo -e "$YELLOW$*$NORMAL"; }

function debug { ((DEBUG)) && echo -e ">>> $*"; }
