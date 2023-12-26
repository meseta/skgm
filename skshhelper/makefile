CC=gcc
CFLAGS=-shared -fPIC

skshhelper.so: skshhelper.c
	$(CC) $(CFLAGS) -o skshhelper.so skshhelper.c

install: skshhelper.so
	cp skshhelper.so ../skgm/extensions/extSkshhelper/skshhelper.so

clean:
	rm skshhelper.so