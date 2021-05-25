# By default, the test application includes main.o.
# OS make file may override this with os-specific files

include ../../build.mak
include ../../version.mak
include $(PJDIR)/build/common.mak

export LIBDIR := ../lib
export BINDIR := ../bin

RULES_MAK := $(PJDIR)/build/rules.mak

PJNATLIB_LIB:=../../pjnath/lib/libpjnat-$(TARGET_NAME)$(LIBEXT)


#export BICE_LIB:=libbice-$(TARGET_NAME)$(LIBEXT)
export BICE_LIB:=libbice$(LIBEXT)

ifeq ($(PJ_SHARED_LIBRARIES),)
else
export BICE_SONAME := libbice.$(SHLIB_SUFFIX)
export BICE_SHLIB := $(BICE_SONAME).$(PJ_VERSION_MAJOR)
endif

###############################################################################
# Gather all flags.
#
export _CFLAGS 	:= $(CC_CFLAGS) $(OS_CFLAGS) $(HOST_CFLAGS) $(M_CFLAGS) \
		   $(CFLAGS) $(CC_INC)../include $(CC_INC)../../pjnath/include \
		   $(CC_INC)../../pjlib/include $(CC_INC)../../pjlib-util/include \
		   $(CC_INC)../../../libumqtt/src $(CC_INC)../../../libumqtt/src/buffer
export _CXXFLAGS:= $(_CFLAGS) $(CC_CXXFLAGS) $(OS_CXXFLAGS) $(M_CXXFLAGS) \
		   $(HOST_CXXFLAGS) $(CXXFLAGS)
export _LDFLAGS := $(CC_LDFLAGS) $(OS_LDFLAGS) $(M_LDFLAGS) $(HOST_LDFLAGS) \
		   $(APP_LDFLAGS) $(LDFLAGS) 

###############################################################################
# Defines for building BICE library
#
export BICE_SRCDIR = ../src/bice
export BICE_OBJS += bp2p_ice_api.o ice_client.o ice_peer.o ice_common.o
export BICE_CFLAGS += $(_CFLAGS) -g
export BICE_CXXFLAGS += $(_CXXFLAGS)
export BICE_LDFLAGS += $(PJLIB_UTIL_LDLIB) $(PJLIB_LDLIB) $(_LDFLAGS) $(PJNATHLIB_LDLIB)

###############################################################################
# Main entry
TARGETS := $(BICE_LIB) $(BICE_SONAME)
TARGETS_EXE := $(BICE_TEST_EXE) $(PJTURN_CLIENT_EXE) $(PJTURN_SRV_EXE)

all: $(TARGETS)

lib: $(TARGETS)


dep: depend
distclean: realclean

.PHONY: all dep depend clean realclean distclean
.PHONY: $(TARGETS)
.PHONY: $(BICE_LIB) $(BICE_SONAME)
.PHONY: $(BICE_TEST_EXE) $(PJTURN_CLIENT_EXE) $(PJTURN_SRV_EXE)

bice: $(BICE_LIB)
$(BICE_SONAME): $(BICE_LIB)
$(BICE_LIB) $(BICE_SONAME): $(PJNATHLIB_LIB)
	$(MAKE) -f $(RULES_MAK) APP=BICE app=bice $(subst /,$(HOST_PSEP),$(LIBDIR)/$@)

bice-test: $(BICE_TEST_EXE)
$(BICE_TEST_EXE): $(BICE_LIB) $(BICE_SONAME)
	$(MAKE) -f $(RULES_MAK) APP=BICE_TEST app=bice-test $(subst /,$(HOST_PSEP),$(BINDIR)/$@)

pjturn-client: $(PJTURN_CLIENT_EXE)
$(PJTURN_CLIENT_EXE): $(BICE_LIB) $(BICE_SONAME)
	$(MAKE) -f $(RULES_MAK) APP=PJTURN_CLIENT app=pjturn-client $(subst /,$(HOST_PSEP),$(BINDIR)/$@)

pjturn-srv: $(PJTURN_SRV_EXE)
$(PJTURN_SRV_EXE): $(BICE_LIB) $(BICE_SONAME)
	$(MAKE) -f $(RULES_MAK) APP=PJTURN_SRV app=pjturn-srv $(subst /,$(HOST_PSEP),$(BINDIR)/$@)

.PHONY: bice.ko
bice.ko:
	echo Making $@
	$(MAKE) -f $(RULES_MAK) APP=BICE app=bice $(subst /,$(HOST_PSEP),$(LIBDIR)/$@)

.PHONY: bice-test.ko
bice-test.ko:
	$(MAKE) -f $(RULES_MAK) APP=BICE_TEST app=bice-test $(subst /,$(HOST_PSEP),$(LIBDIR)/$@)

clean:
	$(MAKE) -f $(RULES_MAK) APP=BICE app=bice $@
	$(MAKE) -f $(RULES_MAK) APP=BICE_TEST app=bice-test $@
	$(MAKE) -f $(RULES_MAK) APP=PJTURN_CLIENT app=pjturn-client $@
	$(MAKE) -f $(RULES_MAK) APP=PJTURN_SRV app=pjturn-srv $@

realclean:
	$(subst @@,$(subst /,$(HOST_PSEP),.bice-$(TARGET_NAME).depend),$(HOST_RMR))
	$(subst @@,$(subst /,$(HOST_PSEP),.bice-test-$(TARGET_NAME).depend),$(HOST_RMR))
	$(subst @@,$(subst /,$(HOST_PSEP),.pjturn-client-$(TARGET_NAME).depend),$(HOST_RMR))
	$(subst @@,$(subst /,$(HOST_PSEP),.pjturn-srv-$(TARGET_NAME).depend),$(HOST_RMR))
	$(MAKE) -f $(RULES_MAK) APP=BICE app=bice $@
	$(MAKE) -f $(RULES_MAK) APP=BICE_TEST app=bice-test $@
	$(MAKE) -f $(RULES_MAK) APP=PJTURN_CLIENT app=pjturn-client $@
	$(MAKE) -f $(RULES_MAK) APP=PJTURN_SRV app=pjturn-srv $@

depend:
	$(MAKE) -f $(RULES_MAK) APP=BICE app=bice $@
	$(MAKE) -f $(RULES_MAK) APP=BICE_TEST app=bice-test $@
	$(MAKE) -f $(RULES_MAK) APP=PJTURN_CLIENT app=pjturn-client $@
	$(MAKE) -f $(RULES_MAK) APP=PJTURN_SRV app=pjturn-srv $@
	echo '$(BINDIR)/$(BICE_TEST_EXE): $(LIBDIR)/$(BICE_LIB) $(PJLIB_UTIL_LIB) $(PJLIB_LIB)' >> .bice-test-$(TARGET_NAME).depend
	echo '$(BINDIR)/$(PJTURN_CLIENT_EXE): $(LIBDIR)/$(BICE_LIB) $(PJLIB_UTIL_LIB) $(PJLIB_LIB)' >> .pjturn-client-$(TARGET_NAME).depend
	echo '$(BINDIR)/$(PJTURN_SRV_EXE): $(LIBDIR)/$(BICE_LIB) $(PJLIB_UTIL_LIB) $(PJLIB_LIB)' >> .pjturn-srv-$(TARGET_NAME).depend


