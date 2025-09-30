# Makefile for "Guess It" Game (Number Guessing Game) Assembly Project

# Program name
PROGRAM = guess_it

# Assembly source file
SOURCE = guess_it.asm

# Object file
OBJECT = $(SOURCE:.asm=.o)

# Assembler and linker
ASM = nasm
LINKER = ld

# Flags
ASMFLAGS = -f elf32
LINKFLAGS = -m elf_i386

# Default target
all: $(PROGRAM)

# Build the executable
$(PROGRAM): $(OBJECT)
	$(LINKER) $(LINKFLAGS) -o $@ $<

# Assemble source file
$(OBJECT): $(SOURCE)
	$(ASM) $(ASMFLAGS) -o $@ $<

# Run the program
run: $(PROGRAM)
	./$(PROGRAM)

# Clean build files
clean:
	rm -f $(OBJECT) $(PROGRAM)

# Debug information
debug: ASMFLAGS += -g -F dwarf
debug: $(PROGRAM)

# Help target
help:
	@echo "Available targets:"
	@echo "  all     - Build the program (default)"
	@echo "  run     - Build and run the program"
	@echo "  clean   - Remove build files"
	@echo "  debug   - Build with debug information"
	@echo "  help    - Show this help message"

.PHONY: all run clean debug help