LIBS = text_util.vhd constants.vhd interface.vhd util.vhd
SRCS = $(LIBS) bf_array.vhd controller.vhd decoder.vhd main.vhd main_tb.vhd sys_reg.vhd rs232c_sender.vhd
OBJS = $(addsuffix .o, $(basename $(SRCS)))
TESTBENCH = main_tb.vhd

TB_BN = $(basename $(TESTBENCH))
TB_GHW = $(addsuffix .ghw, $(TB_BN))

.PHONY: all
all: $(TB_GHW)

libs: $(LIBS)
	ghdl -a -g --ieee=synopsys $(LIBS)

$(TB_GHW): $(OBJS)
	ghdl -e -g -fexplicit --ieee=synopsys $(TB_BN)
	ghdl -r -g -fexplicit --ieee=synopsys $(TB_BN) --wave=$(TB_GHW) --stop-time=10ms

%.o: %.vhd
	ghdl -a -g -fexplicit --ieee=synopsys $<

.PHONY: run
run: main
	gtkwave $(addsuffix .ghw, $(TB_BN)) &

.PHONY: clean
clean:
	$(RM) $(OBJS) $(addsuffix .ghw, $(TB_BN)) $(TB_BN)
 
