help:
	@echo "supported commands:"
	@echo "make compile [COMPILE_MODULE] [COMPILE ARGS]"
	@echo "make clean"

COMPILE_MODULE?=fifo_tb
COMPILE_ARGS?=-g2012 -f files.f
BUILD_DIRECTORY?=build

compile: $(BUILD_DIRECTORY)
	@iverilog -o $(BUILD_DIRECTORY)/$(COMPILE_MODULE) $(COMPILE_ARGS) $(COMPILE_MODULE).sv
	@vvp $(BUILD_DIRECTORY)/$(COMPILE_MODULE)

$(BUILD_DIRECTORY):
	@mkdir build

.PHONY:
clean:
	@rm -rf build *.vcd
