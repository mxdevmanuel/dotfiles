#!/usr/bin/python3
import sqlite3

db = sqlite3.connect('file:/home/manuel/tareas.db?mode=ro', uri=True)
try:
    entradas = db.execute(
        'SELECT completada,count(*) FROM tareas GROUP BY completada')

    cantidades = [x for x in entradas]

    if len(cantidades) < 1:
        cantidades.insert(0, (0, 0))
    if len(cantidades) < 2:
        cantidades.append((0, 0))

    pendientes = cantidades[0][1]

    completados = cantidades[1][1]

    print("{} / {}".format(pendientes, completados))
except sqlite3.OperationalError:
    print('0 / 0')

db.close()
