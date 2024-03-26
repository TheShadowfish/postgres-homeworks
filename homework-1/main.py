"""Скрипт для заполнения данными таблиц в БД Postgres."""
import psycopg2
import os
import csv



def script_in_main_py():
    """
    Написать скрипт в main.py, который заполнит созданные таблицы данными из north_data
    Для подключения к БД использовать библиотеку psycopg2
    Зайти в pgAdmin и убедиться, что данные в таблицах есть
    """
    # customers_data
    #data_list = read_from_file("customers_data.csv")
    #print(data_list)
    print_database_table("customers_data")
    # write_to_database("customers_data", data_list)

    # employees_data
    data_list = read_from_file("employees_data.csv")
    print(data_list)
    print_database_table("employees_data")
    write_to_database("employees_data", data_list)

    pass

def read_from_file(filename: str = '') -> dict:
    """
    Загружает информацию из файла csv в папке north_data
    filename - название файла
    list[] - возвращает список словарей
    """
    filepath = os.path.join('north_data', filename)
    if not os.path.exists(filepath):
        raise FileNotFoundError(f"file {filepath} not found!")
        data_csv = []

    with open(filepath) as my_csv:
        reader = csv.DictReader(my_csv)
        data_csv = list(reader)
    return data_csv

def print_database_table(tablename):
    conn_params = {
        "host": "localhost",
        "database": "north",
        "user": "postgres",
        "password": "12345"
    }
    print(f"Таблица в базе north(localhost) {tablename}: \n")

    with psycopg2.connect(**conn_params) as conn:
        with conn.cursor() as cur:
            # cur.execute("INSERT INTO mytable VALUES (%s, %s, %s)", (4, name, description))
            cur.execute(f"SELECT * FROM {tablename}")
            rows = cur.fetchall()
            for row in rows:
                print(row)
    conn.close()


def write_to_database(tablename, cvs_data: list[dict]):
    conn_params = {
        "host": "localhost",
        "database": "north",
        "user": "postgres",
        "password": "12345"
    }
    # dict_0 = cvs_data[0]
    # print(dict_0)
    # print(dict_0.keys())
    num_of_par = len(cvs_data[0])
    print(f"num_of_par = {num_of_par}")

    string_s = ', '.join(['%s' for i in range(num_of_par)])
    print(f"%s: ({string_s})")

    tuple_par = tuple(cvs_data[0].values())
    print(f"vars: {tuple_par}")

    if (tablename == 'customers_data'):
        tuple_string = [tuple(line.values()) for line in cvs_data]
    elif tablename == 'employees_data':
        '''    !!! employee_id int PRIMARY KEY,
	first_name varchar(50) NOT NULL,
    last_name varchar(50) NOT NULL,
	title varchar(50) NOT NULL,
	!!! birth_date date NOT NULL,
	? notes text NOT NULL'''


        return


    # return


    conn2 = psycopg2.connect(**conn_params)
    cur = conn2.cursor()
    print(f"INSERT INTO {tablename} VALUES ({string_s}) {tuple_string}")


    try:
        cur.executemany(f"INSERT INTO {tablename} VALUES ({string_s})", tuple_string)
    except Exception as e:
        print(f'Ошибка: {e}')
    else:
        # если запрос без ошибок - заносим в БД
        conn2.commit()
    finally:
        cur.close()
        conn2.close()



# начало программы
if __name__ == '__main__':
    script_in_main_py()



"""
    orders_data.csv

order_id
customer_id
employee_id
order_date
ship_city

10248
VINET
5
1996-07-04
Reims


    employees_data.csv

employee_id
first_name
last_name
title
birth_date
notes

1
Nancy
Davolio
Sales Representative
1948-12-08
Education includes a BA in psychology from Colorado State University in 1970.  She also completed The Art of the Cold Call.  Nancy is a member of Toastmasters International.

    customers_data.csv

customer_id
company_name
contact_name

ALFKI
Alfreds Futterkiste
Maria Anders
"""
