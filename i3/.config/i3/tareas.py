#!/usr/bin/python3
import sqlite3
import subprocess
import re


def formatear_entrada(entrada):
    if entrada[1] == 0:
        return "<b>{}</b>".format(entrada[0])
    else:
        return "<s>{}</s>".format(entrada[0])


pattern = re.compile('\<(s|b)\>(.+)\<\/(s|b)\>')

conn = sqlite3.connect('tareas.db')

tablas = conn.execute('''SELECT name FROM sqlite_master''')
if not [x for x in tablas if x == ('tareas',)]:
    try:
        conn.execute('''CREATE TABLE tareas
                     (tarea text, completada integer)''')
    except sqlite3.OperationalError as e:
        raise e

dbentradas = conn.execute('''SELECT * FROM tareas ORDER BY completada ASC''')

entradas = [formatear_entrada(entrada) for entrada in dbentradas]

para_stdin = "\n".join(entradas) + '\n' if len(entradas) > 0 else ''

print(para_stdin)

entrada = subprocess.run(
    [
        'rofi',
        '-dmenu',
        '-markup-rows',
        '-p',
        'Tareas',
        '-kb-custom-1',
        'Alt+d',
        '-kb-custom-2',
        'Alt+a',
        '-columns',
        '1'
    ],
    input=para_stdin, encoding="utf-8", stdout=subprocess.PIPE)

print(entrada)

expression = pattern.search(entrada.stdout)
if expression:
    if entrada.returncode == 0:
        texto = expression.groups()[1]
        query = 'UPDATE tareas SET completada = {} WHERE tarea = "{}"'.format(
            1 if expression.groups()[0] == 'b' else '0', texto)
        conn.execute(query)
    elif entrada.returncode == 10:
        texto = expression.groups()[1]
        query = 'DELETE FROM tareas WHERE tarea = "{}"'.format(texto)
        conn.execute(query)
else:
    if entrada.stdout and entrada.returncode == 0:
        texto = entrada.stdout[:-1]
        query = '''INSERT INTO tareas VALUES ("{}", 0)'''.format(texto)
        conn.execute(query)

if entrada.returncode == 11:
    conn.execute('DROP TABLE tareas')

conn.commit()
conn.close()
