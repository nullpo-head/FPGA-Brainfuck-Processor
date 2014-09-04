FPGA-Brainfuck-Processor
========================

 
This is a brainf\*ck processor written in VHDL.  
This can be simulated with ghdl and can actually run on FPGA. (I tested it on Virtex5.)


Simulation
----

Be sure that you have installed ghdl and gtkwave.

In "src" directory, just run  


`
$ make && make run
`

Then Gtkwave will appear. Add main_tb > "rs_tx" and uut > rs232c_sender > "sending" to the wave area, set the data format of "sending" to ASCII, and zoom out properly.  
You will see some rs232c signals and "Hello, World!" characters.


FPGA
----

My ucf file is also provided with .vhd source codes. Modify it if you try this BF processor on a real FPGA. 

The clock on my board is 66.66MHz, and I make it x10 slower by DCM_ADV in top.vhd.  
Recalculate "wtime" value in rs232c_sender/receiver.vhd for your environment to send bits in the proper RS-232c timing.



BUGS
----

Echo program does not work completely. Bit loss and byte loss sometimes happen.

