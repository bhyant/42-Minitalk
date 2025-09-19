# **************************************************************************** #
#                                                                              #
#                                                         :::      ::::::::    #
#    Makefile                                           :+:      :+:    :+:    #
#                                                     +:+ +:+         +:+      #
#    By: tbhuiyan <tbhuiyan@student.42.fr>          +#+  +:+       +#+         #
#                                                 +#+#+#+#+#+   +#+            #
#    Created: 2025/09/01 11:00:00 by tbhuiyan          #+#    #+#              #
#    Updated: 2025/09/01 10:35:04 by tbhuiyan         ###   ########.fr        #
#                                                                              #
# **************************************************************************** #

# Variables
NAME_SERVER = server
NAME_CLIENT = client
CC = cc
CFLAGS = -Wall -Wextra -Werror -g3
RM = rm -f

# Directories
SRC_DIR = src
INC_DIR = includes
LIBFT_DIR = libft

# Source files
SRC_SERVER = $(SRC_DIR)/server.c
SRC_CLIENT = $(SRC_DIR)/client.c

# Object files
OBJ_SERVER = $(SRC_SERVER:.c=.o)
OBJ_CLIENT = $(SRC_CLIENT:.c=.o)

# Libft
LIBFT = $(LIBFT_DIR)/libft.a

# Colors for output
RED = \033[0;31m
GREEN = \033[0;32m
YELLOW = \033[0;33m
BLUE = \033[0;34m
PURPLE = \033[0;35m
CYAN = \033[0;36m
WHITE = \033[0;37m
RESET = \033[0m

# Rules
all: $(LIBFT) $(NAME_SERVER) $(NAME_CLIENT)
	@echo "$(GREEN)✅ Minitalk compiled successfully!$(RESET)"

$(LIBFT):
	@echo "$(YELLOW)🔨 Compiling libft...$(RESET)"
	@make -C $(LIBFT_DIR) --silent
	@echo "$(GREEN)✅ Libft compiled!$(RESET)"

$(NAME_SERVER): $(OBJ_SERVER) $(LIBFT)
	@echo "$(BLUE)🔗 Linking server...$(RESET)"
	@$(CC) $(CFLAGS) $(OBJ_SERVER) $(LIBFT) -o $(NAME_SERVER)
	@echo "$(GREEN)✅ Server created!$(RESET)"

$(NAME_CLIENT): $(OBJ_CLIENT) $(LIBFT)
	@echo "$(BLUE)🔗 Linking client...$(RESET)"
	@$(CC) $(CFLAGS) $(OBJ_CLIENT) $(LIBFT) -o $(NAME_CLIENT)
	@echo "$(GREEN)✅ Client created!$(RESET)"

$(SRC_DIR)/%.o: $(SRC_DIR)/%.c
	@echo "$(CYAN)🔨 Compiling $<...$(RESET)"
	@$(CC) $(CFLAGS) -I$(INC_DIR) -I$(LIBFT_DIR) -c $< -o $@

clean:
	@echo "$(RED)🧹 Cleaning object files...$(RESET)"
	@$(RM) $(OBJ_SERVER) $(OBJ_CLIENT)
	@make -C $(LIBFT_DIR) clean --silent
	@echo "$(GREEN)✅ Object files cleaned!$(RESET)"

fclean: clean
	@echo "$(RED)🗑️  Removing executables...$(RESET)"
	@$(RM) $(NAME_SERVER) $(NAME_CLIENT)
	@make -C $(LIBFT_DIR) fclean --silent
	@echo "$(GREEN)✅ All files cleaned!$(RESET)"

re: fclean all

bonus: all
	@echo "$(PURPLE)✨ Bonus features compiled!$(RESET)"

# Help
help:
	@echo "$(CYAN)📖 Available commands:$(RESET)"
	@echo "  $(GREEN)make$(RESET)        - Compile server and client"
	@echo "  $(GREEN)make clean$(RESET)  - Remove object files"
	@echo "  $(GREEN)make fclean$(RESET) - Remove all generated files"
	@echo "  $(GREEN)make re$(RESET)     - Recompile everything"
	@echo "  $(GREEN)make test$(RESET)   - Run basic test"
	@echo "  $(GREEN)make bonus$(RESET)  - Compile with bonus"
	@echo "  $(GREEN)make help$(RESET)   - Show this help"