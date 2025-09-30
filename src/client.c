/* ************************************************************************** */
/*                                                                            */
/*                                                        :::      ::::::::   */
/*   client.c                                           :+:      :+:    :+:   */
/*                                                    +:+ +:+         +:+     */
/*   By: tbhuiyan <tbhuiyan@student.42.fr>          +#+  +:+       +#+        */
/*                                                +#+#+#+#+#+   +#+           */
/*   Created: 2025/09/19 11:18:26 by tbhuiyan          #+#    #+#             */
/*   Updated: 2025/09/27 17:28:21 by tbhuiyan         ###   ########.fr       */
/*                                                                            */
/* ************************************************************************** */

#include "../includes/minitalk.h"

static sig_atomic_t	g_return_signal = 0;

void	send_pid(pid_t pid)
{
	pid_t	client_pid;
	int		bit_index;

	client_pid = getpid();
	bit_index = 31;
	ft_printf("client PID : %d\n", client_pid);
	while (bit_index >= 0)
	{
		if ((1 << bit_index) & client_pid)
			kill(pid, SIGUSR1);
		else
			kill(pid, SIGUSR2);
		bit_index--;
		usleep(1000);
	}
}

void	send_size(pid_t pid, unsigned int size)
{
	int	bit_index;

	bit_index = 31;
	while (bit_index >= 0)
	{
		g_return_signal = 0;
		if ((1 << bit_index) & size)
			kill(pid, SIGUSR1);
		else
			kill(pid, SIGUSR2);
		bit_index--;
		while (!g_return_signal)
			;
	}
}

void	send_message(pid_t pid, unsigned char *str)
{
	int	bit_index;
	int	i;
	int	len;

	len = ft_strlen((char *)str);
	i = 0;
	while (i <= len)
	{
		bit_index = 7;
		while (bit_index >= 0)
		{
			g_return_signal = 0;
			if ((1 << bit_index) & str[i])
				kill(pid, SIGUSR1);
			else
				kill(pid, SIGUSR2);
			while (!g_return_signal)
				;
			bit_index--;
		}
		i++;
	}
}

void	client_handler(int signum)
{
	if (signum == SIGUSR1)
		g_return_signal = 1;
	else if (signum == SIGUSR2)
	{
		ft_printf("\n>>MESSAGE SUCCESFULLY SENT<<\n");
		exit(0);
	}
	else
		exit(0);
}

int	main(int ac, char **av)
{
	int	serv_pid;

	if (ac != 3)
		return (ft_printf("Wrong number of args !\n"));
	serv_pid = ft_atoi(av[1]);
	if (!serv_pid || kill(serv_pid, 0) == -1 || serv_pid == -1)
		return (ft_printf("Incorect PID!\n"));
	signal(SIGUSR1, client_handler);
	signal(SIGUSR2, client_handler);
	send_pid(serv_pid);
	send_size(serv_pid, ft_strlen(av[2]));
	send_message(serv_pid, (unsigned char *)av[2]);
	return (0);
}
