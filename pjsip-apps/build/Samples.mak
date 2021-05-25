include ../../build.mak
include ../../version.mak
include ../../build/common.mak

RULES_MAK := $(PJDIR)/build/rules.mak

###############################################################################
# Gather all flags.
#
#

MQTT_LDFLAGS = -L../../../libumqtt/src
MQTT_LIBS = -lumqtt -lev
MQTT_CFLAGS = -I../../../libumqtt/src -I../../../libumqtt/src/buffer


BICE_LDFLAGS = -L../lib
BICE_LIBS = -lbice
BICE_CFLAGS = -I../src/bice

export _CFLAGS 	:= $(PJ_CFLAGS) $(CFLAGS) $(PJ_VIDEO_CFLAGS) $(MQTT_CFLAGS) $(BICE_CFLAGS)
export _CXXFLAGS:= $(PJ_CXXFLAGS) $(CFLAGS) $(PJ_VIDEO_CFLAGS)
export _LDFLAGS := $(BICE_LDFLAGS) $(BICE_LIBS) $(PJ_LDFLAGS) $(PJ_LDLIBS) $(LDFLAGS) $(MQTT_LDFLAGS) $(MQTT_LIBS)
export _LDXXFLAGS := $(PJ_LDXXFLAGS) $(PJ_LDXXLIBS) $(LDFLAGS)

SRCDIR := ../src/samples
OBJDIR := ./output/samples-$(TARGET_NAME)
BINDIR := ../bin/samples/$(TARGET_NAME)

SAMPLES := icedemo_client icedemo_peer

PJSUA2_SAMPLES := pjsua2_demo

ifeq ($(EXCLUDE_APP),0)
EXES := $(foreach file, $(SAMPLES), $(file)$(HOST_EXE))
endif


.PHONY: $(EXES)

all: $(EXES) depend

$(EXES):
	$(MAKE) --no-print-directory -f $(RULES_MAK) SAMPLE_SRCDIR=$(SRCDIR) SAMPLE_OBJS="$@.o" SAMPLE_CFLAGS="$(_CFLAGS)" SAMPLE_CXXFLAGS="$(_CXXFLAGS)" SAMPLE_LDFLAGS="$(_LDFLAGS)" SAMPLE_EXE=$@ APP=SAMPLE app=sample $(subst /,$(HOST_PSEP),$(BINDIR)/$@)

depend:

clean:
	#$(MAKE) -f $(RULES_MAK) APP=SAMPLE app=sample $@
	rm -rf $(BINDIR)/*
	$(subst @@,$(EXES),$(HOST_RM))
	#$(subst @@,$(BINDIR),$(HOST_RMDIR))

distclean realclean: clean
	#$(MAKE) -f $(RULES_MAK) APP=SAMPLE app=sample $@

