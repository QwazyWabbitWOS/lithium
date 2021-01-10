#
# Quake2 gamei386.so Makefile for Linux 2.0
#
# Jan '98 by Zoid <zoid@idsoftware.com>
#
# ELF only
#
# Requires GNU make
#
# This builds the gamei386.so for Linux based on the q2source_12_11.zip
# release.  
# Put his Makefile in the game subdirectory you get when you unzip
# q2source_12_11.zip.
#
# There are two compiler errors you'll get, the following fixes
# are necessary:
#
# In g_local.h (around line 828), you must change the 
#    typedef struct g_client_s { ... } gclient_t;
# to just:
#    struct g_client_s { ... };
# The typedef is already defined elsewhere (seems to compile fine under
# MSCV++ for Win32 for some reason).
#
# m_player.h has a Ctrl-Z at the end (damn DOS editors).  Remove it or
# gcc complains.
#
# Note that the source in q2source_12_11.zip is for version 3.05.  To
# get it to run with Linux 3.10, change the following in game.h:
#    #define    GAME_API_VERSION        1
# change it to:
#    #define    GAME_API_VERSION        2

# this nice line comes from the linux kernel makefile
ARCH := $(shell uname -m | sed -e s/i.86/i386/ -e s/sun4u/sparc64/ -e s/arm.*/arm/ -e s/sa110/arm/ -e s/alpha/axp/)
CC=gcc

#use these cflags to optimize it
CFLAGS=-O3
#use these when debugging 
#CFLAGS=-g

ifeq ($(shell uname),Linux)
CFLAGS+=-DNEED_STRLCAT -DNEED_STRLCPY
endif

# This enables warnings if a strlcat or strlcpy would have
# caused an overflow.
# CFLAGS+=-DSTRL_DEBUG

# This causes a backtrace to be emitted for detected buffer overflows
# Works only on linux
# CFLAGS+=-DSTRL_DEBUG_BACKTRACE -rdynamic

# flavors of Linux
ifeq ($(shell uname), Linux)
#SVNDEV := -D'SVN_REV="$(shell svnversion -n .)"'
#CFLAGS += $(SVNDEV)
CFLAGS += -DLINUX
LIBTOOL = ldd
endif

# OS X wants to be Linux and FreeBSD too.
ifeq ($(shell uname), Darwin)
#SVNDEV := -D'SVN_REV="$(shell svnversion -n .)"'
#CFLAGS += $(SVNDEV)
CFLAGS += -DLINUX
LIBTOOL = otool
endif

LDFLAGS=-ldl -lm
SHLIBEXT=so
SHLIBCFLAGS=-fPIC
SHLIBLDFLAGS=-shared

DO_CC=$(CC) $(CFLAGS) $(SHLIBCFLAGS) -o $@ -c $<

#############################################################################
# SETUP AND BUILD
# GAME
#############################################################################

.c.o:
	$(DO_CC)

GAME_OBJS = \
	p_client.o g_cmds.o g_combat.o g_func.o g_items.o \
	g_main.o g_misc.o g_phys.o g_save.o g_spawn.o \
	g_target.o g_trigger.o g_turret.o g_utils.o g_weapon.o m_move.o \
	p_hud.o p_trail.o p_view.o p_weapon.o q_shared.o g_svcmds.o g_chase.o \
	lithium.o l_display.o l_fragtrak.o l_gslog.o l_hook.o \
	l_mapqueue.o l_nocamp.o l_obit.o l_pack.o l_rune.o \
	l_var.o l_menu.o l_admin.o l_vote.o l_net.o net.o \
	g_ctf.o l_hscore.o zbotcheck.o strl.o

lithium/game$(ARCH).$(SHLIBEXT): $(GAME_OBJS) 
	$(CC) $(CFLAGS) $(SHLIBLDFLAGS) -o $@ $(GAME_OBJS) $(LDFLAGS)
	$(LIBTOOL) -r $@


#############################################################################
# MISC
#############################################################################

clean:
	rm -f $(GAME_OBJS)

depend:
	gcc -MM $(GAME_OBJS:.o=.c)

depends:
	$(CC) $(CFLAGS) -MM *.c > dependencies

all:
	make clean
	make depends
	make

-include dependencies
