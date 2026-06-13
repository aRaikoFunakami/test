# 概要: C 版 hello world のビルド定義。
# `make` で hello バイナリを生成、`make run` で実行、`make clean` で生成物削除。Issue #11。
CC ?= cc
CFLAGS ?= -Wall -Wextra -O2
TARGET := hello

$(TARGET): hello.c
	$(CC) $(CFLAGS) -o $(TARGET) hello.c

.PHONY: run clean
run: $(TARGET)
	./$(TARGET)

clean:
	rm -f $(TARGET)
