# **************************************************************************** #
#                                                                              #
#                                                         :::      ::::::::    #
#    Makefile                                           :+:      :+:    :+:    #
#                                                     +:+ +:+         +:+      #
#    By: ribana-b <ribana-b@student.42malaga.com>   +#+  +:+       +#+         #
#                                                 +#+#+#+#+#+   +#+            #
#    Created: 2024/03/22 15:52:12 by ribana-b          #+#    #+# Malaga       #
#    Updated: 2024/03/22 16:30:27 by ribana-b         ###   ########.com       #
#                                                                              #
# **************************************************************************** #

# ========================================================================== #

# <-- Color Library --> #

# <-- Text Color --> #
T_BLACK = \033[30m
T_RED = \033[31m
T_GREEN = \033[32m
T_YELLOW = \033[33m
T_BLUE = \033[34m
T_MAGENTA = \033[35m
T_CYAN = \033[36m
T_WHITE = \033[37m

# <-- Text Style --> #
BOLD = \033[1m
ITALIC = \033[2m
UNDERLINE = \033[3m
STRIKETHROUGH = \033[4m

# <-- Background Color --> #
B_RED = \033[31m
B_BLACK = \033[30m
B_GREEN = \033[32m
B_YELLOW = \033[33m
B_BLUE = \033[34m
B_MAGENTA = \033[35m
B_CYAN = \033[36m
B_WHITE = \033[37m

# <-- Reset Everything --> #
RESET = \033[0m

# ========================================================================== #

# <-- Output Name --> #
NAME = so_long 

# <-- Compilation Command --> #
CC = cc

# <-- Compilation Flags --> #
ifdef WITH_DEBUG
	CFLAGS = -Wall -Wextra -Werror -ggdb
else
	CFLAGS = -Wall -Wextra -Werror
endif

# <-- Remove Command --> #
RM = rm -rf

# <-- Include Library --> #
INCLUDE = -I ./$(INCLUDE_DIR) -I $(BFL_DIR)include -I $(MLX42_DIR)/include/MLX42

# <-- Link BFL --> #
LIBRARY = -L./$(BFL_DIR) -lbfl -L./$(MLX42_DIR) -lmlx42 -ldl -lglfw -pthread -lm

# <-- Directories --> #
INCLUDE_DIR = include/
BFL_DIR = $(INCLUDE_DIR)BFL/
MLX42_DIR = $(INCLUDE_DIR)MLX42/
SRC_DIR = src/
UTILS_DIR = $(SRC_DIR)utils/
OBJ_DIR = obj/
BIN_DIR = bin/

DEBUG_DIR = src/debug/

# <-- Files --> #
SRC_FILES = main.c
UTILS_FILES = 

# <-- Directories + Files --> #
SRC = $(addprefix $(SRC_DIR), $(SRC_FILES))
UTILS = $(addprefix $(UTILS_DIR), $(UTILS_FILES))

# <-- Objects --> #
OBJ = $(patsubst $(SRC_DIR)%.c, $(OBJ_DIR)%.o, $(SRC)) \
		$(patsubst $(UTILS_DIR)%.c, $(OBJ_DIR)%.o, $(UTILS)) \

# ========================================================================== #

# <-- Project's Target --> #
all: $(BIN_DIR) $(BIN_DIR)$(NAME)

# <-- Program/Library Creation --> #
ifdef WITH_DEBUG
$(BIN_DIR)$(NAME): $(OBJ_DIR) $(OBJ)
	@make -s debug -C $(BFL_DIR)
	@make -s -C $(MLX42_DIR)
	@echo "✅ 🦔 $(T_YELLOW)$(BOLD)so_long Objects $(RESET)$(T_GREEN)created successfully!$(RESET)"
	@$(CC) -o $@ $(OBJ) $(INCLUDE) $(LIBRARY)
	@echo "✅ 🦔 $(T_MAGENTA)$(BOLD)$(NAME) $(RESET)$(T_GREEN)created successfully!$(RESET)"
else
$(BIN_DIR)$(NAME): $(OBJ_DIR) $(OBJ)
	@make -s -C $(BFL_DIR)
	@make -s -C $(MLX42_DIR)
	@echo "✅ 🦔 $(T_YELLOW)$(BOLD)so_long Objects $(RESET)$(T_GREEN)created successfully!$(RESET)"
	@$(CC) -o $@ $(OBJ) $(INCLUDE) $(LIBRARY)
	@echo "✅ 🦔 $(T_MAGENTA)$(BOLD)$(NAME) $(RESET)$(T_GREEN)created successfully!$(RESET)"
endif

# <-- Binaries Directory Creation --> #
$(BIN_DIR):
	@mkdir -p $(BIN_DIR)

# <-- Objects Directory Creation --> #
$(OBJ_DIR):
	@mkdir -p $(OBJ_DIR)

# <-- Objects Creation --> #
$(OBJ_DIR)%.o: $(SRC_DIR)%.c
	@echo "🔨 🦔 $(T_WHITE)$(BOLD)Compiling $<...$(RESET)"
	@$(CC) $(CFLAGS) $(INCLUDE) -c $< -o $@
	@echo "🧩 🦔 $(T_BLUE)$(BOLD)$@ $(RESET)$(T_GREEN)created!$(RESET)"

$(OBJ_DIR)%.o: $(UTILS_DIR)%.c
	@echo "🔨 🦔 $(T_WHITE)$(BOLD)Compiling $<...$(RESET)"
	@$(CC) $(CFLAGS) $(INCLUDE) -c $< -o $@
	@echo "🧩 🦔 $(T_BLUE)$(BOLD)$@ $(RESET)$(T_GREEN)created!$(RESET)"

# <-- Objects Destruction --> #
clean:
	@$(RM) $(OBJ_DIR)
	@make clean -s -C $(BFL_DIR)
	@make clean -s -C $(MLX42_DIR)
	@echo "🗑️  🦔 $(T_YELLOW)$(BOLD)so_long Objects $(RESET)$(T_RED)destroyed successfully!$(RESET)"

# <-- Clean Execution + push_swap Destruction --> #
fclean: clean
	@$(RM) $(BIN_DIR) tags
	@make fclean -s -C $(BFL_DIR)
	@make fclean -s -C $(MLX42_DIR)
	@echo "🗑️  🦔 $(T_MAGENTA)$(BOLD)$(NAME) $(RESET)$(T_RED)destroyed successfully!$(RESET)"

# <-- Fclean Execution + All Execution --> #
re: fclean all

# <-- Debug --> #
debug:
	@make -s WITH_DEBUG=1

# <-- Tags --> #
tags:
	@$(shell find . -type f \( -name "*c" -o -name "*.h" \) > temp)
	@ctags -F $(shell cat temp)
	@rm temp

# <-- Targets Declaration --> #
.PHONY = all clean debug fclean re tags

# ========================================================================== #
