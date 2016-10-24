all: testc

testc: testc.c
		gcc testc.c -o testc

testc.c: test.rl
	ragel -o testc.c test.rl

clean:
	rm testc testc.c
	
