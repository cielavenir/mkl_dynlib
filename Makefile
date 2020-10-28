.PHONY: all main_all main_basic clean

all: main_all lib.so lib2.so

main_all: main_basic main_libs

main_basic: main_basic_local main_basic_global

# not working
main_basic_local: main.c
	gcc -o main_basic_local -g -O0 main.c -ldl

main_basic_global: main.c
	gcc -o main_basic_global -g -O0 main.c -ldl -DLOAD_GLOBAL

# working
main_libs: main.c
	gcc -o main_libs -g -O0 main.c -ldl -Wl,--no-as-needed -L/opt/intel/mkl/lib/intel64_lin -lmkl_core -lmkl_sequential -lmkl_intel_lp64 -lpthread -lm

lib.so: lib.c
	gcc -shared -fPIC -Wl,--no-as-needed -o lib.so -m64 -I/opt/intel/mkl/include lib.c -L/opt/intel/mkl/lib/intel64_lin -DFIXMKL -lmkl_core -lmkl_sequential -lmkl_intel_lp64 -lpthread -lm

lib2.so: lib.c
	gcc -shared -fPIC -Wl,--no-as-needed -o lib2.so -m64 -I/opt/intel/mkl/include lib.c -L/opt/intel/mkl/lib/intel64_lin -lmkl_rt -lpthread -lm

clean:
	rm -f main_basic_local main_basic_global main_libs lib.so lib2.so
