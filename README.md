# CUDA - Radix Sort
## Praktikum 03 - IF3230 Sistem Paralel dan Terdistribusi
## Petunjuk Penggunaan
___
### Requirment
Pengguna harus melakukan instalasi OpenMPI, Compiler bahasa c dan juga terinstall.
### Instalasi
- Lakukan git clone https://gitlab.informatika.org/luthfihadiana/openmpi.git
``` bash
git clone https://gitlab.informatika.org/luthfihadiana/openmpi.git
```
- Masuk ke folder Openmpi
``` bash
cd openmpi
```
- Lakukan makefile
``` bash
make
```

### Run Program
Untuk menjalankan program, lakukan command dibawah 
```bash
mpirun -np <banyak_proses> ./radix_openmpi <banyak_elemen>
```
_banyak-elemen_ adalah banyak elemen yang ingin dilakukan sort serta _banyak-process_ adalah jumlah proses yang akan dibangkitkan selama proses sorting ini.
## Pembagian Tugas
___
1. ___Luthfi Ahmad Mujahid / 13516051___
- Debugger
- Counting Sort
- Laporan
- Tester
- Fungsi utilitas
2. ___Muhamad Ilyas Mustafa / 13516123___
- Main Program
- Radix
- Laporan
- Debugger
- Fungsi utilitas
## Laporan
____
### Solusi Paralel
Langkah solusi untuk menyelesaikan permasalahan ini adalah : 
- __Partitioning__  \
Jenis partitioning yang dilakukan pada desain algoritma ini adalah data partitioning, dimana data akan dipecah menjadi sebanyak n/p dimana n adalah jumlah data dan p adalah jumlah process yang digunakan. Data akan dikirimkan ke masing - masing processor yang tersedia. 

- __Paralelism__ \
Setelah membagi data sebanyak n/p ke setiap prosessornya, setiap processornya memiliki local bucket untuk membuat count tabel berdasarkan digit yang sedang diurutkan.

- __Communication__ \
Proses komunikasi yang dilakukan : 
    * Scatter \
    Komunikasi ini dilakukan untuk mengirimkan n/p elemen kesetiap prosesor slave.
    * Reduce \
    Komunikasi ini dilakukan untuk menggabungkan hasil count table untuk setiap perhitungan di prosessor slave dan digabungkan di proesessor master

- __Sorting__ \
Proses sorting dilakukan dengan cara counting sort. Counting sort yang kami dengan menggunakan basis 10 . Proses sorting ini kami lakukan di prosessor master.

- __Mapping__ \
Setelah dilakukan proses sorting, data akan kembali dilakukan counting namun dengan digit selanjutnya.

### Jumlah thread
Jumlah thread yang digunakan adalah  5 dan 10 . Kami memilih jumlah tersebut karena dengan jumlah thread tersebut, pembagian data ke processor merata.
### Kasus uji (jumlah N pada array) 
* Kasus uji 1 (n = 5000) \
__Untuk Paralel__
```bash
luthfihadiana@luthfihadiana-X411UN:~/Documents/openmpi/src$ mpirun -np 5 radix_openmpi 5000
Execution time: 13.67 ms

luthfihadiana@luthfihadiana-X411UN:~/Documents/openmpi/src$ mpirun -np 10 radix_openmpi 5000
Execution time: 9.77 ms
```
__Untuk Serial__
```bash
luthfihadiana@luthfihadiana-X411UN:~/Documents/openmpi/src$ ./radix_serial
5000
Time taken: 0.60070000ms
```
* _Kasus uji 2 (n = 50000)_\
__Untuk Paralel__
```bash
luthfihadiana@luthfihadiana-X411UN:~/Documents/openmpi/src$ mpirun -np 5 radix_openmpi 50000
Execution time: 96.68 ms

luthfihadiana@luthfihadiana-X411UN:~/Documents/openmpi/src$ mpirun -np 10 radix_openmpi 50000
Execution time: 175.78 ms

```
__Untuk Serial__
```bash
luthfihadiana@luthfihadiana-X411UN:~/Documents/openmpi/src$ ./radix_serial
50000
Time taken: 2.17430000ms
```
* _Kasus uji 3 (n = 100000)_\
__Untuk Paralel__
```bash
luthfihadiana@luthfihadiana-X411UN:~/Documents/openmpi/src$ mpirun -np 5 radix_openmpi 100000
Execution time: 152.34 ms

luthfihadiana@luthfihadiana-X411UN:~/Documents/openmpi/src$ mpirun -np 10 radix_openmpi 100000
Execution time: 194.34 ms
```
__Untuk Serial__
```bash
luthfihadiana@luthfihadiana-X411UN:~/Documents/openmpi/src$ ./radix_serial
100000
Time taken: 3.84110000ms
```
* _Kasus uji 4 (n = 200000)_\
__Untuk Paralel__
```bash
luthfihadiana@luthfihadiana-X411UN:~/Documents/openmpi/src$ mpirun -np 5 radix_openmpi 200000
Execution time: 284.18 ms

luthfihadiana@luthfihadiana-X411UN:~/Documents/openmpi/src$ mpirun -np 10 radix_openmpi 200000
Execution time: 565.43 ms
```
__Untuk Serial__
```bash
luthfihadiana@luthfihadiana-X411UN:~/Documents/openmpi/src$ ./radix_serial
200000
Time taken: 6.62570000ms
```
* _Kasus uji 5 (n = 400000)_\
__Untuk Paralel__
```bash
luthfihadiana@luthfihadiana-X411UN:~/Documents/openmpi/src$ mpirun -np 5 radix_openmpi 400000
Execution time: 706.05 ms

luthfihadiana@luthfihadiana-X411UN:~/Documents/openmpi/src$ mpirun -np 10 radix_openmpi 400000
Execution time: 766.60 ms
```
__Untuk Serial__
```bash
luthfihadiana@luthfihadiana-X411UN:~/Documents/openmpi/src$ ./radix_serial
400000
Time taken: 11.85350000ms
```
__Hasil Test SSH__
```bash
if3230-13516051@hpc14:~/openmpi/src$ mpirun -np 5 ./radix_openmpi 5000
--------------------------------------------------------------------------
[[16012,1],0]: A high-performance Open MPI point-to-point messaging module
was unable to find any relevant network interfaces:

Module: OpenFabrics (openib)
  Host: hpc14

Another transport will be used instead, although this may result in
lower performance.

NOTE: You can disable this warning by setting the MCA parameter
btl_base_warn_component_unused to 0.
--------------------------------------------------------------------------
Execution time: 26.86 ms
[hpc14:24612] 4 more processes have sent help message help-mpi-btl-base.txt / btl:no-nics
[hpc14:24612] Set MCA parameter "orte_base_help_aggregate" to 0 to see all help / error messages
if3230-13516051@hpc14:~/openmpi/src$ mpirun -np 5 ./radix_openmpi 50000
--------------------------------------------------------------------------
[[16374,1],0]: A high-performance Open MPI point-to-point messaging module
was unable to find any relevant network interfaces:

Module: OpenFabrics (openib)
  Host: hpc14

Another transport will be used instead, although this may result in
lower performance.

NOTE: You can disable this warning by setting the MCA parameter
btl_base_warn_component_unused to 0.
--------------------------------------------------------------------------
Execution time: 634.28 ms
[hpc14:24926] 4 more processes have sent help message help-mpi-btl-base.txt / btl:no-nics
[hpc14:24926] Set MCA parameter "orte_base_help_aggregate" to 0 to see all help / error messages
if3230-13516051@hpc14:~/openmpi/src$ mpirun -np 5 ./radix_openmpi 100000
--------------------------------------------------------------------------
[[16249,1],3]: A high-performance Open MPI point-to-point messaging module
was unable to find any relevant network interfaces:

Module: OpenFabrics (openib)
  Host: hpc14

Another transport will be used instead, although this may result in
lower performance.

NOTE: You can disable this warning by setting the MCA parameter
btl_base_warn_component_unused to 0.
--------------------------------------------------------------------------
Execution time: 944.34 ms
[hpc14:25041] 4 more processes have sent help message help-mpi-btl-base.txt / btl:no-nics
[hpc14:25041] Set MCA parameter "orte_base_help_aggregate" to 0 to see all help / error messages
if3230-13516051@hpc14:~/openmpi/src$ mpirun -np 5 ./radix_openmpi 200000
--------------------------------------------------------------------------
[[16207,1],1]: A high-performance Open MPI point-to-point messaging module
was unable to find any relevant network interfaces:

Module: OpenFabrics (openib)
  Host: hpc14

Another transport will be used instead, although this may result in
lower performance.

NOTE: You can disable this warning by setting the MCA parameter
btl_base_warn_component_unused to 0.
--------------------------------------------------------------------------
Execution time: 1621.58 ms
[hpc14:25063] 4 more processes have sent help message help-mpi-btl-base.txt / btl:no-nics
[hpc14:25063] Set MCA parameter "orte_base_help_aggregate" to 0 to see all help / error messages
if3230-13516051@hpc14:~/openmpi/src$ mpirun -np 5 ./radix_openmpi 400000
--------------------------------------------------------------------------
[[16214,1],0]: A high-performance Open MPI point-to-point messaging module
was unable to find any relevant network interfaces:

Module: OpenFabrics (openib)
  Host: hpc14

Another transport will be used instead, although this may result in
lower performance.

NOTE: You can disable this warning by setting the MCA parameter
btl_base_warn_component_unused to 0.
--------------------------------------------------------------------------
Execution time: 2863.28 ms
[hpc14:25086] 4 more processes have sent help message help-mpi-btl-base.txt / btl:no-nics
[hpc14:25086] Set MCA parameter "orte_base_help_aggregate" to 0 to see all help / error messages
```
### Analisis Perbandingan Kinerja Serial dan Paralel. 
Berdasarkan hasil analisis dari kasus uji diatas, kinerja dari radix sort menggunakan openmpi / dilakukan secara parallel lebih lambat dibandingkan dengan menggunakan serial. Hal ini dikarenakan banyak proses komunikasi antar processor yang memakan waktu cukup lama sehingga waktu pengerjaan didominasi oleh overhead dibandingkan process radix sort sebenarnya. 

