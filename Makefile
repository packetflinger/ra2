-include .config

MOD ?= ra2

ifndef CPU
	CPU := $(shell uname -m | sed -e s/i.86/i386/ -e s/amd64/x86_64/ -e s/sun4u/sparc64/ -e s/arm.*/arm/ -e s/sa110/arm/ -e s/alpha/axp/)
endif

ifndef REV
	REV := $(shell git rev-list HEAD | wc -l | tr -d " ")
endif

ifndef VER
	VER := $(REV)~$(shell git rev-parse --short HEAD)
endif
ifndef YEAR
	YEAR := $(shell date +%Y)
endif

CC ?= gcc
LD ?= ld
WINDRES ?= windres
STRIP ?= strip
RM ?= rm -f

CFLAGS += -std=c99 -O2 -fno-strict-aliasing -g -Wno-unused-but-set-variable -fPIC -MMD $(INCLUDES)
LDFLAGS ?= -shared
LIBS ?= -lm -ldl


HEADERS := \
	arena.h \
	game.h \
	g_local.h \
	gslog.h \
	m_actor.h \
	m_berserk.h \
	m_boss2.h \
	m_boss31.h \
	m_boss32.h \
	m_brain.h \
	m_chick.h \
	menu.h \
	m_flipper.h \
	m_float.h \
	m_flyer.h \
	m_gladiator.h \
	m_gunner.h \
	m_hover.h \
	m_infantry.h \
	m_insane.h \
	m_medic.h \
	m_mutant.h \
	m_parasite.h \
	m_player.h \
	m_rider.h \
	m_soldier.h \
	m_supertank.h \
	m_tank.h \
	q_shared.h

OBJS := \
	arena.o \
	debug.o \
	g_ai.o \
	g_cmds.o \
	g_combat.o \
	g_func.o \
	g_items.o \
	g_main.o \
	g_misc.o \
	g_monster.o \
	g_phys.o \
	g_save.o \
	gslogx.o \
	g_spawn.o \
	g_svcmds.o \
	g_target.o \
	g_trigger.o \
	g_turret.o \
	g_utils.o \
	g_weapon.o \
	m_actor.o \
	maploop.o \
	m_berserk.o \
	m_boss2.o \
	m_boss31.o \
	m_boss32.o \
	m_boss3.o \
	m_brain.o \
	m_chick.o \
	menu.o \
	m_flash.o \
	m_flipper.o \
	m_float.o \
	m_flyer.o \
	m_gladiator.o \
	m_gunner.o \
	m_hover.o \
	m_infantry.o \
	m_insane.o \
	m_medic.o \
	m_move.o \
	m_mutant.o \
	m_parasite.o \
	m_soldier.o \
	m_supertank.o \
	m_tank.o \
	p_client.o \
	p_hud.o \
	p_trail.o \
	p_view.o \
	p_weapon.o \
	q_shared.o \
	ra2menus.o

TARGET ?= game$(CPU)-$(MOD)-r$(VER).so	

all: $(TARGET)

default: all

# Define V=1 to show command line.
ifdef V
    Q :=
    E := @true
else
    Q := @
    E := @echo
endif

-include $(OBJS:.o=.d)

%.o: %.c $(HEADERS)
	$(E) [CC] $@
	$(Q)$(CC) -c $(CFLAGS) -o $@ $<

%.o: %.rc
	$(E) [RC] $@
	$(Q)$(WINDRES) $(RCFLAGS) -o $@ $<

$(TARGET): $(OBJS)
	$(E) [LD] $@
	$(Q)$(CC) $(LDFLAGS) -o $@ $^ $(LIBS)

clean:
	$(E) [CLEAN]
	$(Q)$(RM) *.o *.d $(TARGET)

strip: $(TARGET)
	$(E) [STRIP]
	$(Q)$(STRIP) $(TARGET)
	
