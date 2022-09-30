#!/bin/sh

RELEASE="5.9.0"
git submodule init && git submodule update && cd ../CMSIS_5 && git checkout ${RELEASE} && cd -

# Cortex-M7, Double Precision FPU
cmake -DROOT=$(pwd)"/../CMSIS_5" \
  -DCMAKE_PREFIX_PATH="/opt/gcc-arm-none-eabi" \
  -DCMAKE_TOOLCHAIN_FILE="./gcc.cmake" \
  -DARM_CPU="cortex-m7" \
  -G "Unix Makefiles" ..
make -j 6
find bin_dsp/ -name "libCMSIS*.a" -exec arm-none-eabi-ar -x  {} \;
arm-none-eabi-ar -qc libarm_cortexM7lfdp_math.a *.o
rm *.o

# Cortex-M4F, Single Precision FPU
cmake -DROOT=$(pwd)"/../CMSIS_5" \
  -DCMAKE_PREFIX_PATH="/opt/gcc-arm-none-eabi" \
  -DCMAKE_TOOLCHAIN_FILE="./gcc.cmake" \
  -DARM_CPU="cortex-m4" \
  -G "Unix Makefiles" ..
make -j 6
find bin_dsp/ -name "libCMSIS*.a" -exec arm-none-eabi-ar -x  {} \;
arm-none-eabi-ar -qc libarm_cortexM4lf_math.a *.o
rm *.o

# Cortex-M0+, no FPU
cmake -DROOT=$(pwd)"/../CMSIS_5" \
  -DCMAKE_PREFIX_PATH="/opt/gcc-arm-none-eabi" \
  -DCMAKE_TOOLCHAIN_FILE="./gcc.cmake" \
  -DARM_CPU="cortex-m0plus" \
  -G "Unix Makefiles" ..
make -j 6
find bin_dsp/ -name "libCMSIS*.a" -exec arm-none-eabi-ar -x  {} \;
arm-none-eabi-ar -qc libarm_cortexM0l_math.a *.o
rm *.o

# Get the official pack
wget https://github.com/ARM-software/CMSIS_5/releases/download/${RELEASE}/ARM.CMSIS.${RELEASE}.pack && unzip ARM.CMSIS.${RELEASE}.pack -d ARM.CMSIS.${RELEASE}/ && rm ARM.CMSIS.${RELEASE}.pack

# Create the Lib directory and move the built libraries there
mkdir -p ARM.CMSIS.${RELEASE}/CMSIS/DSP/Lib/GCC/
mv lib*.a ARM.CMSIS.${RELEASE}/CMSIS/DSP/Lib/GCC/

echo "ARM CMSIS ready!"

