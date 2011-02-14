#!/usr/bin/env bash
#mencoder ffmpeg ... install script
#Report Bugs in : http://code.google.com/p/fencoder/issues/list
#author: zhangjiayin99@gmail.com

#TODO check exists package

PID=$$
LOG="/var/log/ffmepg_mencoder_all_in_one.log.${PID}"

INSTALL_SDIR='/usr/local/src/fencoder'
INSTALL_DDIR='/usr/local/fencoder'
SCRIPT_DIR=`dirname $(readlink -f $0)`

#colors 
BLACK='\e[01;30m'
RED='\e[01;31m'
GREEN='\e[01;32m'
BROWN='\e[01;33m'
BLUE='\e[01;34m'
PURPLE='\e[01;35m'
CYAN='\e[01;36m'

#control charactor
RESET='\033[0m'

#vars
_version="0.1"
YUM_ENABLE=0
APT_ENABLE=0

export CPU=`cat "/proc/cpuinfo" | grep "processor"|wc -l`
export TMPDIR=$HOME/tmp
export LD_LIBRARY_PATH=${INSTALL_DDIR}/lib:/usr/local/lib:/usr/lib:$LD_LIBRARY_PATH
export LIBRARY_PATH=${INSTALL_DDIR}/lib:/usr/lib:/usr/local/lib:$LIBRARY_PATH
export CPATH={$INSTALL_DDIR}/include:/usr/include/:usr/local/include:$CPATH

#privileges check
export who=`whoami`

#exit on error
set -e

function check_privilege() {
    if [[ $who != "root" ]];then
            echo -e "$RED"
            echo "                  Sorry  , only root is allowed to run this script."
            echo -e "$RESET"
            exit
    fi
}

#TODO
#check_privilege

#redirect output to log
if [[ $1 == "" && $1 != "go" ]];then
    /usr/bin/env bash $0 go | tee $LOG
    exit;
fi


echo "">$LOG

#check dir and download extra source
if [[ ! -e $INSTALL_SDIR ]];then
    mkdir -p $INSTALL_SDIR
fi

#pre download all package's source and extract to $INSTALL_SDIR
cd $INSTALL_SDIR
if [[ ! -e "${INSTALL_SDIR}/fencoder-extra.tar.gz" ]]; then
    wget http://fencoder.googlecode.com/files/fencoder-extra.tar.gz
    tar xzvf fencoder-extra.tar.gz -C $INSTALL_SDIR
fi

cd $SCRIPT_DIR

#check system 
if [ -e "/etc/yum.conf" ];then
    YUM_ENABLE=1
fi

if [ -e "/etc/debian_version" ];then
    APT_ENABLE=1
fi

#packages
FREETYPE="freetype 2.4.4  http://download.savannah.gnu.org/releases/freetype/freetype-2.4.4.tar.bz2  freetype-2.4.4.tar.bz2 freetype-2.4.4 ./configure --prefix=$INSTALL_DDIR &&  make -j$CPU  && make install"

LIBWMF="libwmf 0.2.8.4 http://downloads.sourceforge.net/project/wvware/libwmf/0.2.8.4/libwmf-0.2.8.4.tar.gz?r=http%3A%2F%2Fsourceforge.net%2Fprojects%2Fwvware%2Ffiles%2Flibwmf%2F0.2.8.4%2F&ts=1297400919&use_mirror=citylan  libwmf-0.2.8.4.tar.gz libwmf-0.2.8.4 ./configure --prefix=$INSTALL_DDIR --with-freetype=$INSTALL_DDIR &&  make -j$CPU && make install"

RUBY="ruby 1.9  ftp://ftp.ruby-lang.org//pub/ruby/1.9/ruby-1.9.2-p136.tar.gz ruby-1.9.2-p136.tar.gz ruby-1.9.2-p136 ./configure --prefix=$INSTALL_DDIR  && make -j$CPU  && make install"

FLVTOOL2="flvtool2 1.06  http://rubyforge.org/frs/download.php/17497/flvtool2-1.0.6.tgz flvtool2-1.0.6.tgz flvtool2-1.0.6 ${INSTALL_DDIR}/bin/ruby setup.rb config && ${INSTALL_DDIR}/bin/ruby setup.rb setup && ${INSTALL_DDIR}/bin/ruby setup.rb install"

LAME="lame 3.98.4 http://downloads.sourceforge.net/project/lame/lame/3.98.4/lame-3.98.4.tar.gz?r=http%3A%2F%2Fsourceforge.net%2Fprojects%2Flame%2Ffiles%2Flame%2F3.98.4%2F&ts=1297402992&use_mirror=softlayer lame-3.98.4.tar.gz lame-3.98.4 ./configure  --prefix=$INSTALL_DDIR --enable-mp3x --enable-mp3rtp && make -j$CPU  && make install"

CODECS="codecs 20110131 http://www.mplayerhq.hu/MPlayer/releases/codecs/all-20110131.tar.bz2 all-20110131.tar.bz2 all-20110131 mkdir -pv $INSTALL_DDIR/lib/codecs/ && cp -vrf all-20110131/* $INSTALL_DDIR/lib/codecs/ && chmod -R 755 ${INSTALL_DDIR}/lib/codecs/"

# OGG VORBIS 无损压缩格式
LIBOGG="libogg 1.2.2 http://downloads.xiph.org/releases/ogg/libogg-1.2.2.tar.gz libogg-1.2.2.tar.gz libogg-1.2.2  ./configure --prefix=$INSTALL_DDIR && make -j$CPU  && make install"  

LIBVORBIS="libvorbis 1.3.2 http://downloads.xiph.org/releases/vorbis/libvorbis-1.3.2.tar.bz2 libvorbis-1.3.2.tar.bz2 libvorbis-1.3.2  ./configure --prefix=$INSTALL_DDIR && make -j$CPU  && make install"  

VORBISTOOLS="vorbis-tools 1.2.0 http://downloads.xiph.org/releases/vorbis/vorbis-tools-1.4.0.tar.gz vorbis-tools-1.4.0.tar.gz vorbis-tools-1.4.0  ./configure --prefix=$INSTALL_DDIR && make -j$CPU  && make install"  

#免费的视频压缩编码技术 ，从VP3 HD高清到MPEG-4/DiVX格式都能够被Theora很好的支持
LIBTHEORA="libtheora  1.1.1 http://downloads.xiph.org/releases/theora/libtheora-1.1.1.tar.bz2 libtheora-1.1.1.tar.bz2 libtheora-1.1.1 ./configure --prefix=$INSTALL_DDIR --with-ogg=$INSTALL_DDIR --with-vorbis=$INSTALL_DDIR  && make -j$CPU  && make install"  

#Adaptive Multi-Rate和Adaptive Multi-Rate Wideband 手机 移动设备音频 语音带宽范围：300－3400Hz，8KHz抽样
AMRNB="AMRNB 7.0.0.2 http://ftp.penguin.cz/pub/users/utx/amr/amrnb-7.0.0.2.tar.bz2 amrnb-7.0.0.2.tar.bz2 amrnb-7.0.0.2 ./configure --prefix=$INSTALL_DDIR && make -j$CPU  && make install"  

#AMR-WB”全称为“Adaptive Multi-rate - Wideband”，即“自适应多速率宽带编码”，采样频率为16kHz，是一种同时被国际标准化组织ITU-T和3GPP采用的宽带语音编码标准，也称 为G722.2标准。AMR-WB提供语音带宽范围达到50～7000Hz，用户可主观感受到话音比以前更加自然、舒适和易于分辨。
AMRWB="AMRWB 7.0.0.3 http://ftp.penguin.cz/pub/users/utx/amr/amrwb-7.0.0.3.tar.bz2 amrwb-7.0.0.3.tar.bz2 amrwb-7.0.0.3 ./configure --prefix=$INSTALL_DDIR && make -j$CPU  && make install" 

#Library of OpenCORE Framework implementation of Adaptive Multi Rate Narrowband and Wideband speech codec
OPENCOREAMR="opencore-amr 0.1.2 http://downloads.sourceforge.net/project/opencore-amr/opencore-amr/0.1.2/opencore-amr-0.1.2.tar.gz?r=http%3A%2F%2Fsourceforge.net%2Fprojects%2Fopencore-amr%2Ffiles%2Fopencore-amr%2F0.1.2%2F&ts=1297406432&use_mirror=surfnet opencore-amr-0.1.2.tar.gz opencore-amr-0.1.2 ./configure --prefix=$INSTALL_DDIR && make -j$CPU  && make install"  

#liba52 is a free library for decoding ATSC A/52 streams. It is released under the terms of the GPL license. The A/52 standard is used in a variety of applications, including digital television and DVD. It is also known as AC-3.
#64bit processor bug fix
A52DEC_64="a52dec 0.7.4 http://liba52.sourceforge.net/files/a52dec-0.7.4.tar.gz a52dec-0.7.4.tar.gz a52dec-0.7.4 ./configure --prefix=$INSTALL_DDIR --enable-shared 'CFLAGS=-fPIC' && make -j$CPU  && make install"  

A52DEC="a52dec 0.7.4 http://liba52.sourceforge.net/files/a52dec-0.7.4.tar.gz a52dec-0.7.4.tar.gz a52dec-0.7.4 ./configure --prefix=$INSTALL_DDIR --enable-shared && make -j$CPU  && make install"  

#FAAC is an Advanced Audio Coder (MPEG2-AAC, MPEG4-AAC). The goal of FAAC is to explore the possibilities of AAC and exceed the quality of the currently best MP3 encoders.
#Advanced Audio Coding (AAC) is a standardized, lossy compression and encoding scheme for digital audio. Designed to be the successor of the MP3 format, AAC generally achieves better sound quality than MP3 at similar bit rates
FAAC="FAAC 1.28 http://downloads.sourceforge.net/faac/faac-1.28.tar.bz2 faac-1.28.tar.bz2 faac-1.28 ./bootstrap && ./configure --prefix=$INSTALL_DDIR  --with-mp4v2 && make -j$cpu && make install"

#AAD2 is Freeware Advanced Audio (AAC) Decoder including SBR decoding
FAAD2="FAAD2 2.7 http://downloads.sourceforge.net/faac/faad2-2.7.tar.bz2 faad2-2.7.tar.bz2 faad2-2.7 ./bootstrap && ./configure --prefix=$INSTALL_DDIR  --with-mpeg4ip && make -j$cpu && make install"

YASM="YASM 1.1.0 http://www.tortall.net/projects/yasm/releases/yasm-1.1.0.tar.gz yasm-1.1.0.tar.gz  yasm-1.1.0  ./configure --prefix=$INSTALL_DDIR && make -j$cpu && make install"

NASM="NASM 2.09.04 http://www.nasm.us/pub/nasm/releasebuilds/2.09.04/nasm-2.09.04.tar.bz2 nasm-2.09.04.tar.bz2 nasm-2.09.04 ./configure --prefix=$INSTALL_DDIR  && make -j$cpu && make install"

#Xvid (formerly "XviD") is a video codec library following the MPEG-4 standard, specifically MPEG-4 Part 2 Advanced Simple Profile (ASP). It uses ASP features such as b-frames, global and quarter pixel motion compensation, lumi masking, trellis quantization, and H.263, MPEG and custom quantization matrices.
XVID="xvidcore 1.2.2 http://downloads.xvid.org/downloads/xvidcore-1.2.2.tar.bz2 xvidcore-1.2.2.tar.bz2 xvidcore-1.2.2 cd xvidcore/build/generic/ && ./configure --prefix=$INSTALL_DDIR  && make -j$cpu && make install"

#x264 is a free software library for encoding video streams into the H.264/MPEG-4 AVC format.
X264="x264 2245rev ftp://ftp.videolan.org/pub/x264/snapshots/x264-snapshot-20110207-2245.tar.bz2 x264-snapshot-20110207-2245.tar.bz2 x264-snapshot-20110207-2245  ./configure  --prefix=$INSTALL_DDIR --enable-shared --disable-asm  && make -j$cpu && make install"

#re2c is a tool for writing very fast and very flexible scanners. Unlike any other such tool, re2c focuses on generating high efficient code for regular expression matching. As a result this allows a much broader range of use than any traditional lexer offers. And Last but not least re2c generates warning free code that is equal to hand-written code in terms of size, speed and quality.
RE2C="re2c 0.13.5 http://downloads.sourceforge.net/project/re2c/re2c/0.13.5/re2c-0.13.5.tar.gz?r=http%3A%2F%2Fsourceforge.net%2Fprojects%2Fre2c%2F&ts=1297409454&use_mirror=citylan  re2c-0.13.5.tar.gz re2c-0.13.5 ./configure  --prefix=$INSTALL_DDIR && make -j$cpu && make install"

#V8
LIBVPX="libvpx 0.9.5 http://webm.googlecode.com/files/libvpx-v0.9.5.tar.bz2  libvpx-v0.9.5.tar.bz2 libvpx-v0.9.5 ./configure  --prefix=$INSTALL_DDIR && make -j$cpu && make install"

MPLAYER="mplayer -rc4 http://www.mplayerhq.hu/MPlayer/releases/MPlayer-1.0rc4.tar.bz2 MPlayer-1.0rc4.tar.bz2  MPlayer-1.0rc4  ./configure --prefix=$INSTALL_DDIR  --codecsdir=$INSTALL_DDIR/lib/codecs/    --extra-cflags=-I${INSTALL_DDIR}/include/ --extra-ldflags=-L${INSTALL_DDIR}/lib  --with-freetype-config=${INSTALL_DDIR}/bin/freetype-config   --yasm=${INSTALL_DDIR}/bin/yasm  && make -j$cpu && make install && cp -f etc/codecs.conf $INSTALL_DDIR/etc/mplayer/codecs.conf"

FFMPEG="ffmpeg 0.6.1 http://ffmpeg.org/releases/ffmpeg-0.6.1.tar.bz2 MPlayer-1.0rc4.tar.bz2  ffmpeg  ./configure --prefix=$INSTALL_DDIR --enable-shared --enable-nonfree  --enable-gpl --enable-pthreads  --enable-libopencore-amrnb  --enable-decoder=liba52  --enable-libopencore-amrwb  --enable-libfaac  --enable-libmp3lame  --enable-libtheora --enable-libvorbis  --enable-libx264  --enable-libxvid  --extra-cflags=-I${INSTALL_DDIR}/include/ --extra-ldflags=-L${INSTALL_DDIR}/lib  --enable-version3 && make -j$cpu && make tools/qt-faststart && make install && cp -vf tools/qt-faststart {$INSTALL_DDIR}/bin/  "

#MP4Box is a MP4 multiplexer. It can import MPEG-4 video, DivX, XviD, 3ivx, h264 etc, audio streams and subtitles into the .mp4 container. The end result is a compliant MP4 stream. It can also extract streams from a .mp4. MP4Box is a command line tool, but can be used with graphical user interfaces such as YAMB.
MP4BOX="gpac  0.4.5 http://downloads.sourceforge.net/project/gpac/GPAC/GPAC%200.4.5/gpac-0.4.5.tar.gz?r=http%3A%2F%2Fsourceforge.net%2Fprojects%2Fgpac%2F&ts=1297411317&use_mirror=citylan gpac-0.4.5.tar.gz gpac ./configure --prefix=${INSTALL_DDIR} --extra-cflags=-I${INSTALL_DDIR}/include/ --extra-ldflags=-L${INSTALL_DDIR}/lib      --disable-wx --strip && make -j$cpu && make install"

#64bit processor bug fix A52DEC
ARCh=`arch`
if [[ $ARCh == 'x86_64' ]];then
    packages=("FREETYPE" "LIBWMF" "RUBY" "FLVTOOL2" "LAME" "CODECS" "LIBOGG" "LIBVORBIS" "VORBISTOOLS" "LIBTHEORA" "AMRNB" "AMRWB" "OPENCOREAMR" "A52DEC_64" "FAAC" "FAAD2" "YASM" "NASM" "XVID" "X264" "RE2C" "LIBVPX" "MPLAYER" "FFMPEG" "MP4BOX")
        
else
    packages=("FREETYPE" "LIBWMF" "RUBY" "FLVTOOL2" "LAME" "CODECS" "LIBOGG" "LIBVORBIS" "VORBISTOOLS" "LIBTHEORA" "AMRNB" "AMRWB" "OPENCOREAMR" "A52DEC" "FAAC" "FAAD2" "YASM" "NASM" "XVID" "X264" "RE2C" "LIBVPX" "MPLAYER" "FFMPEG" "MP4BOX") 
fi

#promapt
clear
echo -e "$GREEN"
echo "***************************************************************************************************************"
echo "#############                ffmpeg mencoder  all in one installation script $_version                ###############"
echo "***************************************************************************************************************"
echo -e "$RESET"

echo " All operations are loged to ${LOG}  . Check the logs for any failure"

function pre_setup() {
    if [ $YUM_ENABLE == 1 ];then
        echo "Ensuring required RPM ........"
        yum install gcc gcc-c++ libgcc gd gd-devel gettext freetype \
            freetype-devel ImageMagick ImageMagick-devel libjpeg* libjpeg-devel* \
            libpng* libpng-devel* libstdc++* libstdc++-devel* libtiff* \
            libtiff-devel* libtool* libungif* libungif-deve* libxml* libxml2* \
            libxml2-devel* zlib* zlib-devel* automake* autoconf* samba-common* \
            ncurses-devel ncurses patch make apr-util   -y
        yum -y install freetype-devel SDL-devel freeglut-devel
        #rpm -e alsa-lib --nodeps
    fi

    if [ $APT_ENABLE == 1 ];then
        echo "Ensuring Debian packages ....."
        apt-get install gcc libgd-dev gettext libfreetype6 libfreetype6-dev libpng-dev libstdc++-dev \
            libtiff-dev libtool libxml2 libxml2-dev automake autoconf libncurses-dev ncurses-dev patch \
            make -y
    fi
    
    #process tmp dir
    rm -rf $HOME/tmp
    mkdir -p $HOME/tmp

    if [ ! -e $INSTALL_SDIR ]; then
        mkdir -p $INSTALL_SDIR
    fi

    echo " "
    echo "creating folders..........done"
    echo -n "Creating ldd configurations "
    echo "";
    echo "${INSTALL_DDIR}/lib" > /etc/ld.so.conf.d/fencoder.so.conf
    echo -n ".......... done"
}

#install all packages 
function install_all() {

    cnt=${#packages[@]}
    echo "$cnt packages will be installed"
    for package_var in ${packages[@]}
    do

        if [[ -z ${!package_var} ]];then
            continue;
        fi

        package=( ${!package_var} )
        clear
        sleep 2
        echo -e $BLUE"Installation of ${package[0]}${package[1]}....... started"$RESET

        cd $INSTALL_SDIR

        if [[  ! -e  ${package[3]} ]];then
            wget "${package[2]}" -O ${package[3]}
        fi
        
        package_cnt=${#package[@]}
        install_command=""
        index=0
        while [[ "$index" -lt "$package_cnt" ]];

        do
            if [[ $index -gt 4 ]];then
                install_command="${install_command} ${package[$index]}"
            fi
            ((index++))
        done
        
        #extract package
        if [[ ${package[3]##*\.} == "gz" ]];then
            tar zxvf ${package[3]}
        elif [[ ${package[3]##*\.} == "bz2" ]];then
            tar jxvf ${package[3]}
        elif [[ ${package[3]##*\.} == "tgz" ]];then
            tar zxvf ${package[3]}
        fi
        
        if [[ -d ${package[4]} ]]; then
            cd ${package[4]}
        fi

        eval $install_command
        ldconfig
       
        echo -e $BLUE"Installation of ${package[0]} ....... Completed"$RESET
        sleep 2
    done
}

echo -e "$GREEN"
echo -n "Waiting ...."
echo -e "$RESET"
#TODO
sleep 10
pre_setup
install_all


#mplayer
if [ -e "${INSTALL_DDIR}/bin/mplayer" ]; then
        echo " "
else
        echo " "
        echo " "
        echo -e $RED"   MPLAYER Failed"$RESET
        echo " "
        echo " "
        exit
fi

#ffmpeg
if [ -e "${INSTALL_DDIR}/bin/ffmpeg" ]; then
        echo " "
else
        echo " "
        echo " "
        echo -e $RED"   FFMPEG Failed :("$RESET
        echo " "
        echo " "
        exit
fi

echo -e $GREEN"Congratulations!, Installation of all packages Completed"$RESET
