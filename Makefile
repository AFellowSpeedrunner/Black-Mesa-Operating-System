LDFLAGS := -T targets/x86_64/linker.ld -no-pie

kernel_source_files := $(shell find src/impl/kernel -name *.cpp)
kernel_object_files := $(patsubst src/impl/kernel/%.cpp, build/kernel/%.o, $(kernel_source_files))

x86_64_cpp_source_files := $(filter-out src/impl/x86_64/print.cpp, $(shell find src/impl/x86_64 -name *.cpp))
x86_64_cpp_object_files := $(patsubst src/impl/x86_64/%.cpp, build/x86_64/%.o, $(x86_64_cpp_source_files))

x86_64_asm_source_files := $(shell find src/impl/x86_64 -name *.asm)
x86_64_asm_object_files := $(patsubst src/impl/x86_64/%.asm, build/x86_64/%.o, $(x86_64_asm_source_files))

x86_64_object_files := $(x86_64_cpp_object_files) $(x86_64_asm_object_files) build/x86_64/print.o

$(kernel_object_files): build/kernel/%.o : src/impl/kernel/%.cpp
	mkdir -p $(dir $@) && \
	g++ $(CFLAGS) -c -I src/intf -ffreestanding $(patsubst build/kernel/%.o, src/impl/kernel/%.cpp, $@) -o $@

$(x86_64_cpp_object_files): build/x86_64/%.o : src/impl/x86_64/%.cpp
	mkdir -p $(dir $@) && \
	g++ $(CFLAGS) -c -I src/intf -ffreestanding $(patsubst build/x86_64/%.o, src/impl/x86_64/%.cpp, $@) -o $@

$(x86_64_asm_object_files): build/x86_64/%.o : src/impl/x86_64/%.asm
	mkdir -p $(dir $@) && \
	nasm -f elf64 $(patsubst build/x86_64/%.o, src/impl/x86_64/%.asm, $@) -o $@

build/x86_64/print.o: src/impl/x86_64/print.cpp
	mkdir -p $(dir $@) && \
	g++ $(CFLAGS) -c -I src/intf -ffreestanding $< -o $@

.PHONY: build-x86_64
build-x86_64: $(kernel_object_files) $(x86_64_object_files)
	mkdir -p dist/x86_64 && \
	g++ $(LDFLAGS) -nostdlib -nostartfiles -o dist/x86_64/kernel.bin $(kernel_object_files) $(x86_64_object_files) && \
	cp dist/x86_64/kernel.bin targets/x86_64/iso/boot/kernel.bin && \
	grub-mkrescue /usr/lib/grub/i386-pc -o dist/x86_64/kernel.iso targets/x86_64/iso
