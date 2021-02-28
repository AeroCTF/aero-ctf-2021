## Install

### Initially compile using the standard script for gui version:
- git clone https://github.com/lcgamboa/picsimlab.git
- cd picsimlab
- ./picsimlab_build_all_and_deps.sh exp

### After compilation:
- cd ..
- git clone https://github.com/lcgamboa/lxrad_NOGUI.git
- cd lxrad_NOGUI/
- make
- sudo make install
- cd ..
- cd picsimlab
- cd src
- make -f Makefile.NOGUI exp