LIBS = text_util.vhd constants.vhd interface.vhd util.vhd
SRCS = bf_array.vhd controller.vhd decoder.vhd main.vhd main_tb.vhd sys_reg.vhd rs232c_sender.vhd rs232c_receiver.vhd
LIBOBJS = $(addsuffix .o, $(basename $(LIBS)))
OBJS = $(addsuffix .o, $(basename $(SRCS)))
TESTBENCH = main_tb.vhd

TB_BN = $(basename $(TESTBENCH))
TB_GHW = $(addsuffix .ghw, $(TB_BN))

STOP_TIME = 10ms

.PHONY: all
all: $(TB_GHW)

.PHONY: libs
libs: $(LIBOBJS)

$(OBJS) : $(LIBOBJS)

$(TB_GHW): $(OBJS)
	ghdl -e -g -fexplicit --ieee=synopsys $(TB_BN)
	ghdl -r -g -fexplicit --ieee=synopsys $(TB_BN) --wave=$(TB_GHW) --stop-time=$(STOP_TIME)

%.o: %.vhd
	ghdl -a -g -fexplicit --ieee=synopsys $<

.PHONY: run
run: $(TB_GHW)
	gtkwave $(addsuffix .ghw, $(TB_BN)) &

.PHONY: clean
clean:
	$(RM) $(LIBOBJS) $(OBJS) $(addsuffix .ghw, $(TB_BN)) $(TB_BN)
 
