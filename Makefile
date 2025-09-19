# **************************************************************************** #
#                                                                              #
#                                                         :::      ::::::::    #
#    Makefile                                           :+:      :+:    :+:    #
#                                                     +:+ +:+         +:+      #
#    By: tbhuiyan <tbhuiyan@student.42.fr>          +#+  +:+       +#+         #
#                                                 +#+#+#+#+#+   +#+            #
#    Created: 2025/09/19 21:33:25 by tbhuiyan          #+#    #+#              #
#    Updated: 2025/09/19 21:33:26 by tbhuiyan         ###   ########.fr        #
#                                                                              #
# **************************************************************************** #

NAME_SERVER		= server
NAME_CLIENT		= client
CC				= cc
CFLAGS			= -Wall -Wextra -Werror -MMD -MP -g3
AR				= ar rc
RM				= rm -f

OBJDIR			= .objs
SRC_DIR			= src
INC_DIR			= includes
LIBFT_DIR		= libft

SRC_SERVER		= $(SRC_DIR)/server.c
SRC_CLIENT		= $(SRC_DIR)/client.c

OBJ_SERVER		= $(OBJDIR)/server.o
OBJ_CLIENT		= $(OBJDIR)/client.o
DEP_SERVER		= $(OBJDIR)/server.d
DEP_CLIENT		= $(OBJDIR)/client.d

LIBFT			= $(LIBFT_DIR)/libft.a

.PHONY: all clean fclean re bonus

all: $(LIBFT) $(NAME_SERVER) $(NAME_CLIENT)

$(LIBFT):
	@make -C $(LIBFT_DIR)

$(NAME_SERVER): $(OBJ_SERVER) $(LIBFT)
	@$(CC) $(CFLAGS) $(OBJ_SERVER) $(LIBFT) -o $(NAME_SERVER)
	@echo "🖥️  Server executable created successfully!"

$(NAME_CLIENT): $(OBJ_CLIENT) $(LIBFT)
	@$(CC) $(CFLAGS) $(OBJ_CLIENT) $(LIBFT) -o $(NAME_CLIENT)
	@echo "💻 Client executable created successfully!"

$(OBJDIR)/%.o: $(SRC_DIR)/%.c | $(OBJDIR)
	@$(CC) $(CFLAGS) -I$(INC_DIR) -c $< -o $@

$(OBJDIR):
	@mkdir -p $(OBJDIR)

clean:
	@$(RM) -r $(OBJDIR)
	@make -C $(LIBFT_DIR) clean
	@echo "🧹 Minitalk objects cleaned!"

fclean: clean
	@$(RM) $(NAME_SERVER) $(NAME_CLIENT)
	@make -C $(LIBFT_DIR) fclean
	@echo "🗑️  Executables removed!"

re: fclean all

bonus: all

-include $(DEP_SERVER) $(DEP_CLIENT)
