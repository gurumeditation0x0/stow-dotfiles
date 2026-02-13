
# Table of Contents



apt install libgccjit0 libgccjit-10-dev libjansson4 libjansson-dev gnutls-bin autoconf build-essential texinfo libtifiles-dev libgif-dev libjpeg-dev libpng++-dev libxpm-dev libgtk-3-dev xorg-dev libsqlite3-dev libgnutls28-dev libtiff-dev libtinfo-dev libncurses-dev libacl1-dev libattr1-dev libalsaplayer-dev libasound2-dev libalsaplayer-dev libresvg-dev libwxsvg-dev cmake libtool  libvterm0 libvterm-dev cmake libtool  libvterm0 libvterm-dev librsvg2-dev libxml2-dev kdeconnect terminology

./configure --with-native-compilation --with-json --with-tree-sitter --with-sound=alsa  --with-xml2

git clone <https://github.com/tree-sitter/tree-sitter.git>  
cd tree-sitter  
make  
make install  

Configured for 'x86<sub>64</sub>-pc-linux-gnu'.  

Where should the build process find the source code?    .  
  What compiler should emacs be built with?               gcc -g3 -O2  
  Should Emacs use the GNU version of malloc?             no  
    (The GNU allocators don't work with this system configuration.)  
  Should Emacs use a relocating allocator for buffers?    no  
  Should Emacs use mmap(2) for buffer allocation?         no  
  What window system should Emacs use?                    x11  
  What toolkit should Emacs use?                          GTK3  
  Where do we find X Windows header files?                Standard dirs  
  Where do we find X Windows libraries?                   Standard dirs  
  Does Emacs use -lXaw3d?                                 no  
  Does Emacs use the X Double Buffer Extension?           yes  
  Does Emacs use -lXpm?                                   yes  
  Does Emacs use -ljpeg?                                  yes  
  Does Emacs use -ltiff?                                  yes  
  Does Emacs use a gif library?                           yes -lgif  
  Does Emacs use a png library?                           yes -lpng16 -lz  
  Does Emacs use -lrsvg-2?                                yes  
  Does Emacs use -lwebp?                                  yes  
  Does Emacs use -lsqlite3?                               yes  
  Does Emacs use cairo?                                   yes  
  Does Emacs use -llcms2?                                 yes  
  Does Emacs use imagemagick?                             no  
  Does Emacs use native APIs for images?                  no  
  Does Emacs support sound?                               yes  
  Does Emacs use -lgpm?                                   no  
  Does Emacs use -ldbus?                                  yes  
  Does Emacs use -lgconf?                                 no  
  Does Emacs use GSettings?                               yes  
  Does Emacs use a file notification library?             yes -lglibc (inotify)  
  Does Emacs use access control lists?                    yes -lacl -lattr  
  Does Emacs use -lselinux?                               yes  
  Does Emacs use -lgnutls?                                yes  
  Does Emacs use -lxml2?                                  yes  
  Does Emacs use -lfreetype?                              yes  
  Does Emacs use HarfBuzz?                                yes  
  Does Emacs use -lm17n-flt?                              no  
  Does Emacs use -lotf?                                   no  
  Does Emacs use -lxft?                                   no  
  Does Emacs use -lsystemd?                               no  
  Does Emacs use -ljansson?                               yes  
  Does Emacs use -ltree-sitter?                           yes  
  Does Emacs use the GMP library?                         yes  
  Does Emacs directly use zlib?                           yes  
  Does Emacs have dynamic modules support?                yes  
  Does Emacs use toolkit scroll bars?                     yes  
  Does Emacs support Xwidgets?                            no  
  Does Emacs have threading support in lisp?              yes  
  Does Emacs support the portable dumper?                 yes  
  Does Emacs support legacy unexec dumping?               no  
  Which dumping strategy does Emacs use?                  pdumper  
  Does Emacs have native lisp compiler?                   yes  
  Does Emacs use version 2 of the X Input Extension?      yes  
  Does Emacs generate a smaller-size Japanese dictionary? no  
