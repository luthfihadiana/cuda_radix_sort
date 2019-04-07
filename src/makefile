COMP = gcc
COMP2 = mpicc
FLAG = -g -Wall -o
LEAD = -fopenmp
INPT1 = radix_sort_cuda.c
INPT3 = radix_sort_serial.c
OUTP1 = radix_sort
OUTP3 = radix_serial

all : program1 program2 program3

program1 : 
	@echo "Compile your program radix_sort_openmpi"
	${COMP2} ${INPT1} -o ${OUTP1} -lm
	@echo "Your program are ready"

program3 : 
	@echo "Compile your program radix_sort_serial"
	${COMP2} -o ${OUTP3} ${INPT3}
	@echo "Your program are ready"

clean :
	@echo "Cleaning up ..."
	rm ${OUTP1} ${OUTP2} ${OUTP3}
