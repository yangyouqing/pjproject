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

export _CFLAGS 	:= $(PJ_CFLAGS) $(CFLAGS) $(PJ_VIDEO_CFLAGS) $(MQTT_CFLAGS)
export _CXXFLAGS:= $(PJ_CXXFLAGS) $(CFLAGS) $(PJ_VIDEO_CFLAGS)
export _LDFLAGS := $(PJ_LDFLAGS) $(PJ_LDLIBS) $(LDFLAGS) $(MQTT_LDFLAGS) $(MQTT_LIBS)
export _LDXXFLAGS := $(PJ_LDXXFLAGS) $(PJ_LDXXLIBS) $(LDFLAGS)

SRCDIR := ../src/samples
OBJDIR := ./output/samples-$(TARGET_NAME)
BINDIR := ../bin/samples/$(TARGET_NAME)

SAMPLES := ice_peer \
	   ice_client \
	   icedemo

PJSUA2_SAMPLES := pjsua2_demo

ifeq ($(EXCLUDE_APP),0)
EXES := $(foreach file, $(SAMPLES), $(file)$(HOST_EXE))
PJSUA2_EXES := $(foreach file, $(PJSUA2_SAMPLES), $(file)$(HOST_EXE))
endif

ifeq ($(PJ_EXCLUDE_PJSUA2),1)
PJSUA2_EXES :=
endif

.PHONY: $(EXES)
.PHONY: $(PJSUA2_EXES)

all: $(EXES) depend

$(EXES):
	$(MAKE) --no-print-directory -f $(RULES_MAK) SAMPLE_SRCDIR=$(SRCDIR) SAMPLE_OBJS="$@.o ice_common.o" SAMPLE_CFLAGS="$(_CFLAGS)" SAMPLE_CXXFLAGS="$(_CXXFLAGS)" SAMPLE_LDFLAGS="$(_LDFLAGS)" SAMPLE_EXE=$@ APP=SAMPLE app=sample $(subst /,$(HOST_PSEP),$(BINDIR)/$@)

$(PJSUA2_EXES):
	$(MAKE) --no-print-directory -f $(RULES_MAK) PJSUA2_SAMPLE_SRCDIR=$(SRCDIR) PJSUA2_SAMPLE_OBJS=$@.o PJSUA2_SAMPLE_CFLAGS="$(_CFLAGS)" PJSUA2_SAMPLE_CXXFLAGS="$(_CXXFLAGS)" PJSUA2_SAMPLE_LDFLAGS="$(_LDXXFLAGS)" PJSUA2_SAMPLE_EXE=$@ APP=PJSUA2_SAMPLE app=pjsua2_sample $(subst /,$(HOST_PSEP),$(BINDIR)/$@)

depend:
	cp ../../../libumqtt/src/*.so* $(BINDIR)

clean:
	$(MAKE) -f $(RULES_MAK) APP=SAMPLE app=sample $@
	$(MAKE) -f $(RULES_MAK) APP=PJSUA2_SAMPLE app=pjsua2_sample $@
	$(subst @@,$(EXES),$(HOST_RM))
	$(subst @@,$(BINDIR),$(HOST_RMDIR))

distclean realclean: clean
	$(MAKE) -f $(RULES_MAK) APP=SAMPLE app=sample $@

