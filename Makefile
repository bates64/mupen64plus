UNAME := $(shell uname -s)

ifeq ($(UNAME),Darwin)
	SO := dylib
	SODIR := out/Frameworks
else
	SO := so
	SODIR := out
endif

out/mupen64plus: $(SODIR)/libmupen64plus.$(SO) $(SODIR)/mupen64plus-audio-sdl.$(SO) $(SODIR)/mupen64plus-input-sdl.$(SO) $(SODIR)/mupen64plus-video-glide64mk2.$(SO) $(SODIR)/mupen64plus-rsp-hle.$(SO)
	make -C mupen64plus-ui-console/projects/unix all -j
	cp mupen64plus-ui-console/projects/unix/mupen64plus $@

$(SODIR)/libmupen64plus.$(SO):
	make -C mupen64plus-core/projects/unix all -j \
		DEBUGGER=1 \
		NO_ASM=1 NEON=0 VFP_HARD=0
	mv mupen64plus-core/projects/unix/*.$(SO) $@
	cp mupen64plus-core/data/* out

$(SODIR)/mupen64plus-audio-sdl.$(SO):
	make -C mupen64plus-audio-sdl/projects/unix all -j
	mv mupen64plus-audio-sdl/projects/unix/*.$(SO) $@

$(SODIR)/mupen64plus-input-sdl.$(SO):
	make -C mupen64plus-input-sdl/projects/unix all -j
	mv mupen64plus-input-sdl/projects/unix/*.$(SO) $@
	cp mupen64plus-input-sdl/data/* out

$(SODIR)/mupen64plus-rsp-hle.$(SO):
	make -C mupen64plus-rsp-hle/projects/unix all -j
	mv mupen64plus-rsp-hle/projects/unix/*.$(SO) $@

$(SODIR)/mupen64plus-video-rice.$(SO):
	make -C mupen64plus-video-rice/projects/unix all -j
	mv mupen64plus-video-rice/projects/unix/*.$(SO) $@
	cp mupen64plus-video-rice/data/* out

$(SODIR)/mupen64plus-video-glide64mk2.$(SO):
	make -C mupen64plus-video-glide64mk2/projects/unix all -j
	mv mupen64plus-video-glide64mk2/projects/unix/*.$(SO) $@
	cp mupen64plus-video-glide64mk2/data/* out

$(SODIR)/mupen64plus-video-GLideN64.$(SO): GLideN64/projects/cmake/Makefile
	cmake --build GLideN64/projects/cmake
	mv GLideN64/projects/cmake/*.$(SO) $@

GLideN64/projects/cmake/Makefile:
	cd GLideN64/projects/cmake && cmake \
		-DMUPENPLUSAPI_GLIDENUI=Off -DNOHQ=On -DVEC4_OPT=On -DCRC_OPT=On -DMUPENPLUSAPI=On \
		../../src/

clean:
	rm out/mupen64plus $(SODIR)/*.$(SO) || exit 0
	rm -rf */projects/unix/_obj || exit 0
	mkdir -p $(SODIR)

.PHONY: clean
