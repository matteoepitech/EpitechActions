NAME = a.out
SRC = test.c

all:
	$(CC) $(SRC) -o $(NAME)

clean:
	rm -f $(NAME)
