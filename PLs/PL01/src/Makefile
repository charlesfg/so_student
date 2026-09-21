CC ?= cc
CFLAGS ?= -std=c11 -Wall -Wextra -Wpedantic -g

TARGET = mr-wordcount

.PHONY: all clean test

all: $(TARGET)

$(TARGET): mr-wordcount.c
	$(CC) $(CFLAGS) $< -o $@

test: $(TARGET)
	../tests/test_wordcount.sh ./$(TARGET) ./wordcount.sh

clean:
	rm -f $(TARGET)
