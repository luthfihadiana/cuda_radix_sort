COMP = gcc
COMP1 = nvcc
FLAG = -g -Wall -o
LEAD = -fopenmp
INPT1 = cuda.cu
INPT3 = radix_sort_serial.c
OUTP1 = radix_sort
OUTP3 = radix_serial

all : program1 program3

program1 : 
	@echo "Compile your program radix_sort_cuda"
	${COMP1} ${INPT1} -o ${OUTP1}
	@echo "Your program are ready"

program3 : 
	@echo "Compile your program radix_sort_serial"
	${COMP} -o ${OUTP3} ${INPT3}
	@echo "Your program are ready"

clean :
	@echo "Cleaning up ..."
	rm ${OUTP1} ${OUTP2} ${OUTP3}
