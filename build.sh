TANGGAL=$(date +"%F-%S")
START=$(date +"%s")
KERNEL_DIR=$(pwd)
NAME_KERNEL="$1"
chat_id="$TG_CHAT"
token="$TG_TOKEN"

function clone_git {
#download toolchains
git clone --depth=1 https://github.com/eun0115/AnyKernel3.git -b even ~/AnyKernel
git clone --depth=1 https://github.com/SayuZX/android_prebuilts_clang_host_linux-x86_clang-r437112.git clang

#BY ZYCROMERZ
#git clone --depth=1 https://github.com/ZyCromerZ/aarch64-zyc-linux-gnu -b 13 aarch64-gcc
#git clone --depth=1 https://github.com/ZyCromerZ/arm-zyc-linux-gnueabi -b 13 aarch32-gcc

#BY ETERNAL COMPILER
git clone --depth=1 https://github.com/EternalX-project/aarch64-linux-gnu.git aarch64-gcc
git clone --depth=1 https://github.com/EternalX-project/arm-linux-gnueabi.git aarch32-gcc
}

function cleaning_cache {
if [ -d out ];then
   rm -rf out
   fi
   if [ -d HASIL ];then
     rm -rf HASIL/**
     fi
   if [ -d ~/AnyKernel ];then
     rm -rf ~/AnyKernel ];then
   fi
     }

     function sticker() {
         curl -s -X POST "https://api.telegram.org/bot$token/sendSticker" \
                 -d sticker="CAACAgEAAxkBAAEnKnJfZOFzBnwC3cPwiirjZdgTMBMLRAACugEAAkVfBy-aN927wS5blhsE" \
                         -d chat_id=$chat_id
                         }

                         function sendinfo() {
                             curl -s -X POST "https://api.telegram.org/bot$token/sendMessage" \
                                     -d chat_id="$chat_id" \
                                             -d "disable_web_page_preview=true" \
                                                     -d "parse_mode=html" \
                                                             -d text="<b>$NAME_KERNEL</b>%0ABuild started on <code>GearCI</code>%0AFor device <b>realme C25/C25s</b> (even)%0Abranch <code>$(git rev-parse --abbrev-ref HEAD)</code> (master)%0AUnder commit <code>$(git log --pretty=format:'"%h : %s"' -1)</code>%0AUsing compiler: <code>${KBUILD_COMPILER_STRING}</code>%0AStarted on <code>$(date)</code>%0A<b>Build Status:</b> Beta"
                                                             }

                                                             # Push kernel to channel
                                                             function push() {
                                                                 cd ~/AnyKernel
                                                                     ZIP=$(echo *.zip)
                                                                         curl -F document=@$ZIP "https://api.telegram.org/bot$token/sendDocument" \
                                                                                 -F chat_id="$chat_id" \
                                                                                         -F "disable_web_page_preview=true" \
                                                                                                 -F "parse_mode=html" \
                                                                                                         -F caption="Build took $(($DIFF / 60)) minute(s) and $(($DIFF % 60)) second(s). | For <b>realme C25/C25s (even)</b> | <b>$(${GCC}gcc --version | head -n 1 | perl -pe 's/\(http.*?\)//gs' | sed -e 's/  */ /g')</b>"
                                                                                                         }

                                                                                                         # Fin Error
                                                                                                         function finerr() {
                                                                                                             curl -s -X POST "https://api.telegram.org/bot$token/sendMessage" \
                                                                                                                     -d chat_id="$chat_id" \
                                                                                                                             -d "disable_web_page_preview=true" \
                                                                                                                                     -d "parse_mode=markdown" \
                                                                                                                                             -d text="Build throw an error(s)"
                                                                                                                                                 exit 1
                                                                                                                                                 }

                                                                                                                                                 function compile() {
                                                                                                                                                 #ubah nama kernel dan dev builder
                                                                                                                                                 export ARCH=arm64
                                                                                                                                                 export KBUILD_BUILD_USER=TheUnknownName06 
                                                                                                                                                 export LOCALVERSION=$NAME_KERNEL

                                                                                                                                                 #mulai mengcompile kernel
                                                                                                                                                 [ -d "out" ] && rm -rf out  mkdir -p out

                                                                                                                                                 make O=out ARCH=arm64 rem01_defconfig

                                                                                                                                                 PATH="${PWD}/clang/bin:${PATH}:${PWD}/aarch32-gcc/bin:${PATH}:${PWD}/aarch64-gcc/bin:${PATH}" \
                                                                                                                                                 make -j$(nproc --all) O=out \
                                                                                                                                                                       ARCH=arm64 \
                                                                                                                                                                                             CC="clang" \
                                                                                                                                                                                                                   CLANG_TRIPLE=aarch64-linux-gnu- \
                                                                                                                                                                                                                                         CROSS_COMPILE="${PWD}/aarch64-gcc/bin/aarch64-linux-gnu-" \
                                                                                                                                                                                                                                                               CROSS_COMPILE_ARM32="${PWD}/aarch32-gcc/bin/arm-linux-gnueabihf-" \
                                                                                                                                                                                                                                                                                     CONFIG_NO_ERROR_ON_MISMATCH=y \
                                                                                                                                                                                                                                                                                     V=0 2>&1 | tee log.txt
                                                                                                                                                                                                                                                                                     cp out/arch/arm64/boot/Image.gz-dtb ~/AnyKernel
                                                                                                                                                                                                                                                                                     }

                                                                                                                                                                                                                                                                                     # Zipping
                                                                                                                                                                                                                                                                                     function zipping() {
                                                                                                                                                                                                                                                                                         cd ~/AnyKernel
                                                                                                                                                                                                                                                                                             zip -r9 ${NAME_KERNEL}_even-RUI2-${TANGGAL}.zip *
                                                                                                                                                                                                                                                                                                 cd ..
                                                                                                                                                                                                                                                                                                 }

                                                                                                                                                                                                                                                                                                 sendinfo
                                                                                                                                                                                                                                                                                                 cleaning_cache
                                                                                                                                                                                                                                                                                                 clone_git
                                                                                                                                                                                                                                                                                                 
                                                                                                                                                                                                                                                                                                 
                                                                                                                                                                                                                                                                                                 compile
                                                                                                                                                                                                                                                                                                 zipping
                                                                                                                                                                                                                                                                                                 END=$(date +"%s")
                                                                                                                                                                                                                                                                                                 DIFF=$(($END - $START))
                                                                                                                                                                                                                                                                                                 push
                                                                                                                                                                                                                                                                                                 
