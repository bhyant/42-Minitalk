/* ************************************************************************** */
/*                                                                            */
/*                                                        :::      ::::::::   */
/*   server.c                                           :+:      :+:    :+:   */
/*                                                    +:+ +:+         +:+     */
/*   By: tbhuiyan <tbhuiyan@student.42.fr>          +#+  +:+       +#+        */
/*                                                +#+#+#+#+#+   +#+           */
/*   Created: 2025/09/19 11:18:24 by tbhuiyan          #+#    #+#             */
/*   Updated: 2025/09/19 21:37:08 by tbhuiyan         ###   ########.fr       */
/*                                                                            */
/* ************************************************************************** */

#include "../includes/minitalk.h"

pid_t	g_client_pid = 0;

void	recover_pid_and_size(int signum, void *content)
{
	static int	bit_index;

	if (bit_index < 32)
	{
		*(pid_t *)content <<= 1;
		*(pid_t *)content |= (signum == SIGUSR1);
		bit_index++;
	}
	else if (bit_index >= 32 && bit_index < 64)
	{
		*(unsigned int *)content <<= 1;
		*(unsigned int *)content |= (signum == SIGUSR1);
		bit_index++;
		if (bit_index == 64)
			bit_index = 0;
		kill(g_client_pid, SIGUSR1);
	}
}

int	build_bits(int signum, unsigned char **str, int *i)
{
	static unsigned int		bit_index;
	static unsigned char	c;

	c |= (signum == SIGUSR1);
	bit_index++;
	if (bit_index == 8)
	{
		if (c == 0)
		{
			bit_index = 0;
			c = 0;
			return (1);
		}
		*(*str + *i) = c;
		(*i)++;
		bit_index = 0;
		c = 0;
	}
	else
		c <<= 1;
	return (0);
}

int	recover_message(int signum, unsigned int size)
{
	static unsigned char	*str;
	static int				i;

	if (str == NULL)
	{
		str = ft_calloc(size + 1, sizeof(unsigned char));
		if (!str)
			exit(0);
	}
	if (build_bits(signum, &str, &i))
	{
		ft_printf("Message from [%i] : \"%s\"\n\n --END OF MESSAGE--",
			g_client_pid, str);
		free(str);
		str = NULL;
		i = 0;
		return (1);
	}
	return (0);
}

void	serv_handler(int signum)
{
	static int						bits_index;
	static unsigned int				size;

	if (bits_index < 64)
	{
		if (bits_index < 32)
			recover_pid_and_size(signum, &g_client_pid);
		else
			recover_pid_and_size(signum, &size);
		bits_index++;
	}
	else if (bits_index == 64)
	{
		if (!recover_message(signum, size))
			kill(g_client_pid, SIGUSR1);
		else
		{
			bits_index = 0;
			size = 0;
			kill(g_client_pid, SIGUSR2);
			g_client_pid = 0;
			ft_printf("\n Waiting an other messages...\n\n");
		}
	}
}

int	main(void)
{
	struct sigaction	sa;

	sa.sa_handler = serv_handler;
	sa.sa_flags = SA_RESTART | SA_NODEFER;
	ft_printf("---MINITALK SERVER---");
	ft_printf("server PID is  %d\n", getpid());
	ft_printf("Waiting for messages...\n\n");
	sigaction(SIGUSR1, &sa, NULL);
	sigaction(SIGUSR2, &sa, NULL);
	while (1)
	{
		pause();
	}
	return (0);
}
