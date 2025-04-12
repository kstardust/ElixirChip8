CFLAGS=-Wall -fPIC \
  -isysroot /Applications/Xcode.app/Contents/Developer/Platforms/MacOSX.platform/Developer/SDKs/MacOSX.sdk \
  -I/opt/homebrew/Cellar/erlang/27.2.1/lib/erlang/erts-15.2.1/include
# -undefined dynamic_lookup: https://stackoverflow.com/questions/8288358/erlang-nif-test-os-x-lion
LDFLAGS=-lcurses -dynamiclib -undefined dynamic_lookup

SOURCES=$(wildcard *.c)
OBJECTS=$(SOURCES:.c=.o)

LIBRARY=ncurses_ui_nif.so

all: $(LIBRARY)

$(LIBRARY): $(OBJECTS)
	$(CC) $(OBJECTS) $(LDFLAGS) -o $@

.c.o:
	$(CC) $(CFLAGS) -c $< -o $@

clean:
	rm -f *.o $(LIBRARY)
