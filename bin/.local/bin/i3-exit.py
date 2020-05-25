#!/usr/bin/env python3
import subprocess

para_stdin = [
    ' Poweroff',
    ' Reboot',
    ' Suspend',
    ' Hibernate',
    ' Logout'
]

entrada = subprocess.run(
    [
        'rofi',
        '-dmenu',
        '-markup-rows',
        '-p',
        'Power',
        '-i',
    ],
    input='\n'.join(para_stdin), encoding="utf-8", stdout=subprocess.PIPE)

print(entrada)

if entrada.stdout == para_stdin[0] + '\n':
    print("Poweroff")
    subprocess.Popen(['systemctl', 'poweroff'])

if entrada.stdout == para_stdin[1] + '\n':
    print("Reboot")
    subprocess.Popen(['systemctl', 'reboot'])

if entrada.stdout == para_stdin[2] + '\n':
    print("Logout")
    subprocess.Popen(['systemctl', 'suspend'])

if entrada.stdout == para_stdin[3] + '\n':
    print("Logout")
    subprocess.Popen(['systemctl', 'hibernate'])

if entrada.stdout == para_stdin[4] + '\n':
    print("Logout")
    subprocess.Popen(['i3-msg', 'exit'])

