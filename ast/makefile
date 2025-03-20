
SRCS = $(wildcard ../*/fpp.config.*)

TESTS = $(SRCS:%=test/test/%)

all : $(TESTS)

test/test/% : % genast ../rom.4th dict.map rmcom test_all_fpp_config
	./test_all_fpp_config $<

print-%: ; @echo $*=$($*)

clean:
	rm -rf test
