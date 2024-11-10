##
## EPITECH PROJECT, 2024
## Makefile
## File description:
## my test makefile
##

NAME	= 	test

SRC	=	main.c

OBJ	= $(SRC:.c=.o)

all: $(NAME)

$(NAME): $(OBJ)
	gcc $(OBJ) -o $(NAME) -Wall -Wextra
	rm -rf $(OBJ)

clean:
	rm -rf $(OBJ)

fclean: clean
	rm -rf $(NAME)

re: fclean all

# tests_runs:
