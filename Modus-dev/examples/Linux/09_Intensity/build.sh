g++ -I./../../../include/ -I./../../../soundgen/ main.cpp ./../audio/audio.fmod.cpp ./../../../soundgen/FMOD/mxsoundgenfmod.cpp -o ./../bin/09_Intensity ./../../../lib/Linux/modus.a ./../../../soundgen/externals/FMOD/lib.linux/libfmodex.so -pthread -ldl -fpermissive