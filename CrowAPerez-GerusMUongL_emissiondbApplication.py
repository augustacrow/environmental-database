import pymysql
import matplotlib.pyplot as plt

# Prompt the user for their MySQL username and password
username = input('Enter your MySQL username: ')
password = input('Enter your MySQL password: ')

# connect to emissionDB using prompted username and password
connection = pymysql.connect(
        host='localhost',
        user=username,
        password=password,
        database='emissiondb',
        charset='utf8mb4',
        cursorclass=pymysql.cursors.DictCursor)


while True:
    # ask user whether they want to insert, delete, view, or update data
    operation = input("Choose an operation: insert, delete, view, update (or exit): ")

    if operation == "insert":
        c = connection.cursor()
        try:
            # Retrieve all table names from the database
            show_tables_query = "SHOW TABLES"
            c.execute(show_tables_query)
            tables = c.fetchall()

            # Extract the table names from the result
            table_names = [table['Tables_in_emissiondb'] for table in tables]

            # Print the table names to the user
            print("Available tables:")
            for table_name in table_names:
                print(table_name)

            # prompt user for the table they want to insert data into
            table = input("Choose a table to add data to: ")

            # Check if the table exists in the database
            check_table_query = f"SELECT TABLE_NAME FROM information_schema.TABLES WHERE TABLE_NAME = '{table}'"
            c.execute(check_table_query)
            if c.fetchone() is None:
                print(f"The table '{table}' does not exist in the database.")
                continue

            # get user's input on the data they want to add
            values = input("Choose input values: ")

            # insert the data into the table
            sql = f"INSERT INTO {table} VALUES ({values})"
            # Execute the query
            c.execute(sql)

            # Commit the changes to the database
            connection.commit()
            print("Your data has been added!")

        finally:
            # Close the cursor
            c.close()

    elif operation == "delete":
        c = connection.cursor()
        try:
            # Retrieve all table names from the database
            show_tables_query = "SHOW TABLES"
            c.execute(show_tables_query)
            tables = c.fetchall()

            # Extract the table names from the result
            table_names = [table['Tables_in_emissiondb'] for table in tables]

            # Print the table names to the user
            print("Available tables:")
            for table_name in table_names:
                print(table_name)

            # ask user which table they would like to delete data from
            table_del = input("Choose a table to delete from: ")

            # Check if the table exists in the database
            check_table_query = f"SELECT TABLE_NAME FROM information_schema.TABLES WHERE TABLE_NAME = '{table_del}'"
            c.execute(check_table_query)
            if c.fetchone() is None:
                print(f"The table '{table_del}' does not exist in the database.")
                continue

            # ask user which row of data they would like to delete
            condition_del = input("What condition do you want to delete on? ")

            # Prepare the SQL query
            query = f"DELETE FROM {table_del} WHERE {condition_del}"
            # Execute the query
            c.execute(query)

            # Commit the changes to the database
            connection.commit()
            print("Tuple deleted successfully.")

        finally:
            # Close the cursor
            c.close()

    elif operation == "view":
        c = connection.cursor()
        try:
            # Retrieve all table names from the database
            show_tables_query = "SHOW TABLES"
            c.execute(show_tables_query)
            tables = c.fetchall()

            # Extract the table names from the result
            table_names = [table['Tables_in_emissiondb'] for table in tables]

            # Print the table names to the user
            print("Available tables:")
            for table_name in table_names:
                print(table_name)

            # prompt user for the table they want to view
            read_table = input("Choose a table to read data from: ")

            # check if the user's table is in the database
            check_table_query = f"SELECT TABLE_NAME FROM information_schema.TABLES WHERE TABLE_NAME = '{read_table}'"
            c.execute(check_table_query)
            if c.fetchone() is None:
                print(f"The table '{read_table}' does not exist in the database.")
                continue

            # ask user if they want to view all the data from a table or if they want to view certain rows
            view_option = input("Choose an option: 'all' to view all data, 'condition' to apply a specific condition: ")
            if view_option == "all":
                # Prepare SQL query to view all data
                read_query = f"SELECT * FROM {read_table}"
            elif view_option == "condition":
                # Prompt user for the condition
                condition = input("Enter the condition: ")
                # Prepare SQL query with  condition
                read_query = f"SELECT * FROM {read_table} WHERE {condition}"
            else:
                print("Invalid option. Please try again.")
                continue

            # prepare the SQL query
            c.execute(read_query)

            # Retrieve data
            for row in c.fetchall():
                print(row)

        finally:
            # Close the cursor
            c.close()

    elif operation == "update":
        c = connection.cursor()
        try:
            # Retrieve all table names from the database
            show_tables_query = "SHOW TABLES"
            c.execute(show_tables_query)
            tables = c.fetchall()

            # Extract the table names from the result
            table_names = [table['Tables_in_emissiondb'] for table in tables]

            # Print the table names to the user
            print("Available tables:")
            for table_name in table_names:
                print(table_name)

            # prompt user for the table they want to update data for
            table_update = input("Choose a table to update: ")

            # Check if the table exists in the database
            check_table_query = f"SELECT TABLE_NAME FROM information_schema.TABLES WHERE TABLE_NAME = '{table_update}'"
            c.execute(check_table_query)
            if c.fetchone() is None:
                print(f"The table '{table_update}' does not exist in the database.")
                continue

            # Retrieve the column names from chosen table
            column_query = f"SELECT COLUMN_NAME FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = '{table_update}'"
            c.execute(column_query)
            columns = c.fetchall()

            # Print the column names
            print("Columns:")
            for column in columns:
                print(column['COLUMN_NAME'])

            # gather the column and what new data they want to replace old data with
            column = input("Enter the column to update: ")
            current_value = input("Enter the current value: ")
            new_value = input("Enter the new value: ")

            # Fetch all matching rows
            select_query = f"SELECT * FROM {table_update} WHERE {column} = '{current_value}'"
            c.execute(select_query)
            rows = c.fetchall()

            # in the case where there are no rows with the current_value
            if len(rows) == 0:
                print("No matching rows found.")

            # in the case there is exactly one row with the current_value
            elif len(rows) == 1:
                update_query = f"UPDATE {table_update} SET {column} = %s WHERE {column} = %s"
                c.execute(update_query, (new_value, current_value))
                print("Successfully updated the row.")

            # in the case there is more than one row with the current_value
            else:
                print("Matching rows:")
                for index, row in enumerate(rows):
                    print(f"{index + 1}. {row}")

                # Prompt user for the condition
                condition = input("Enter the condition (column = value): ")

                # Split the condition into column and value
                condition_column, condition_value = condition.split('=')
                condition_column = condition_column.strip()
                condition_value = condition_value.strip()

                # Prepare the SQL query to update the rows matching the condition
                update_query = f"UPDATE {table_update} SET {column} = %s WHERE {condition_column} = %s"

                # Execute the update query with the new value and condition value as parameters
                c.execute(update_query, (new_value, condition_value))

                # Check the affected rows count
                affected_rows = c.rowcount
                print(f"Successfully updated {affected_rows} row(s).")

            # Commit the changes to the database
            connection.commit()

        finally:
            # Close the cursor
            c.close()

    elif operation == "exit":
        break

    else:
        print("Invalid operation. Please try again.")

# call biggerGDP function
while True:
    operation = input("Would you like to compare two country's GDPs? (yes/no): ")

    if operation == 'yes':
        # Create a cursor object to execute SQL queries
        c2 = connection.cursor()

        try:
            # Prompt the user for country1, country2, and year
            country1 = input("Enter country 1 (Canada, Mexico, or United States): ")
            country2 = input("Enter country 2 (Canada, Mexico, or United States): ")
            year = input("Enter the year (2011-2020): ")

            # Prepare the SQL query to call the function with user inputs
            query = f"SELECT biggerGDP('{country1}', '{country2}', {year})"

            # Execute the query
            c2.execute(query)

            # Fetch the result
            result = c2.fetchone()

            # Print the result
            print("Comparison Result:", result)

        finally:
            c2.close()

    elif operation == 'no':
        break

# call pollutedWater function
while True:
    operation = input("Would you like to see how many times a body of water is polluted? (yes/no): ")

    if operation == 'yes':
        c3 = connection.cursor()

        try:
            # Retrieve all water body names from the database
            query = "SELECT name FROM waterBody"
            c3.execute(query)
            water_bodies = c3.fetchall()

            # Print the water body options
            print("Water Body Options:")
            for index, body in enumerate(water_bodies):
                print(f"{body['name']}")

            # Prompt the user for the water body name
            water_body_name = input("Which body of water would you like to look at it?: ")

            # Prepare the SQL query to call the function with the user input
            query = f"SELECT pollutedWater('{water_body_name}')"

            # Execute the query
            c3.execute(query)

            # Fetch the result
            result = c3.fetchone()

            # Print the result
            print("Polluted Water Count:", result)

        finally:
            c3.close()

    elif operation == 'no':
        break

# call totalEmissions procedure
while True:
    operation = input("Would you like to see each country's total emissions? (yes/no): ")

    if operation == 'yes':
        try:
            # Create a cursor object
            c4 = connection.cursor()

            # Call the stored procedure
            c4.callproc("totalEmissions")

            # Fetch all the results
            results = c4.fetchall()

            # Iterate over the results
            for row in results:
                country = row['country']
                total_emissions = row['total_emissions']
                print(f"Country: {country}, Total Emissions: {total_emissions}")
            break

        finally:
            c4.close()

    elif operation == 'no':
        break

# call procedure createEmissionSource
while True:
    operation = input("Would you like to create a new emission source? (yes/no): ")

    if operation == 'yes':
        try:
            c5 = connection.cursor()

            # Prompt the user for their inputs
            s_type = input("Enter the source type: ")
            e_type = input("Enter the emission type: ")
            c_name = input("Enter the country name (Canada, Mexico, or United States): ")
            c_lat = input("Enter the country latitude: ")
            c_long = input("Enter the country longitude: ")
            c_pd = float(input("Enter the country population density (in sqm): "))

            # Call the stored procedure with user input
            procedure_call = """
                CALL createEmissionSource(%s, %s, %s, %s, %s, %s)
            """

            # execute the procedure
            c5.execute(procedure_call, (s_type, e_type, c_name, c_lat, c_long, c_pd))

            # Commit the changes to the database
            connection.commit()

        finally:
            c5.close()

    if operation == 'no':
        break

# call naturalDisasterCasualties procedures
while True:
    operation = input("Would you like to see the casualties of each natural disaster? (yes/no) ")

    if operation == 'yes':
        try:
            c6 = connection.cursor()

            # Call the procedure
            c6.callproc("naturalDisasterCasualties")

            # Fetch the result set
            results = c6.fetchall()

            # Print the results
            print("Disaster Type\tTotal Casualties")
            for result in results:
                disaster_type = result['type']
                total_casualties = result['totalCasualties']
                print(f"{disaster_type}\t\t{total_casualties}")

        finally:
            c6.close()

    if operation == 'no':
        break

# provides visualization
while True:

    # asks if the user wants to see a visualization
    operation = input("Would you like to see a visualization of the data?? (yes/no): ")

    try:
        # operations if a user wants to see one
        if operation == 'yes':

            # asks which visual the user wants to see
            vis = int(input('Which visualization would you like to see (1:average temperature, 2:natural disasters,'
                            ' 3:GDP, 4:total emissions)? Please enter the number: '))

            # if the visual is 1, show the graph of average temp
            if vis == 1:

                # create a cursor object
                c7 = connection.cursor()

                # execute an SQL query
                sql = "SELECT country, avgTemp_c  FROM climate"
                c7.execute(sql)

                # get the data
                data = c7.fetchall()

                # put the data in lists for visualization
                country = [row['country'] for row in data]
                temps = [row['avgTemp_c'] for row in data]

                # create a bar chart
                plt.bar(country, temps)
                plt.xlabel('Country')
                plt.ylabel('Average Temp')
                plt.title('The Average Temperature of Countries')

                # show the chart
                plt.show()

                # close the cursor
                c7.close()

            # if the visual is 2, show the number of natural disasters in each country
            elif vis == 2:

                # create a cursor object
                c7 = connection.cursor()

                # execute an SQL query
                sql = "SELECT country, COUNT(*) as count FROM naturalDisaster GROUP BY country"
                c7.execute(sql)

                # get the data
                data = c7.fetchall()

                # put the data in a list for visualization
                countries = [row['country'] for row in data]
                counts = [row['count'] for row in data]

                # create a bar chart
                plt.bar(countries, counts)
                plt.xlabel('Country')
                plt.ylabel('County')
                plt.title('Number of Natural Disasters in Each Country')

                # show the chart
                plt.show()

                # close the cursor
                c7.close()

            # if the visual is 2, show scatter of different countries GDP over time
            elif vis == 3:

                # create a cursor object
                c7 = connection.cursor()

                # execute an SQL query
                sql_us = "SELECT GDPcapita_USD, year FROM GDPperCapita WHERE countryName='United States'"
                c7.execute(sql_us)

                # get the data
                data_us = c7.fetchall()

                # put the data for US in lists
                gdp_us = [row['GDPcapita_USD'] for row in data_us]
                year_us = [row['year'] for row in data_us]

                # execute an SQL query
                sql_can = "SELECT GDPcapita_USD, year FROM GDPperCapita WHERE countryName='Canada'"
                c7.execute(sql_can)

                # get the data
                data_can = c7.fetchall()

                # put the data for canada in lists
                gdp_can = [row['GDPcapita_USD'] for row in data_can]
                year_can = [row['year'] for row in data_can]

                # execute an SQL query
                sql_mex = "SELECT GDPcapita_USD, year FROM GDPperCapita WHERE countryName='Mexico'"
                c7.execute(sql_mex)

                # get the data
                data_mex = c7.fetchall()

                # put the data from mexico in lists
                gdp_mex = [row['GDPcapita_USD'] for row in data_mex]
                year_mex = [row['year'] for row in data_mex]

                # create scatter plot separated by country
                plt.scatter(year_us, gdp_us, label='United States')
                plt.scatter(year_can, gdp_can, label='Canada')
                plt.scatter(year_mex, gdp_mex, label='Mexico')
                plt.legend()
                plt.xlabel('Date')
                plt.ylabel('GDP')
                plt.title('GDP of Countries Over Time')

                # show the chart
                plt.show()

                # close the cursor
                c7.close()

            # if the visual is 4, show the total emissions for each country
            elif vis == 4:

                # create a cursor object
                c7 = connection.cursor()

                # execute an SQL query
                c7.callproc("totalEmissions", ())

                # get the data
                data = c7.fetchall()

                # put the data in lists for the visualization
                country = [row['country'] for row in data]
                measure = [row['total_emissions'] for row in data]

                # create a bar chart
                plt.bar(country, measure)
                plt.xlabel('Country')
                plt.ylabel('Total Emission Measured')
                plt.title('Total Amount of Emissions By Country')

                # show the chart
                plt.show()

                # close the cursor
                c7.close()

        # if the user doesn't want to see any visualizations, close the connection
        elif operation == 'no':
            break

    finally:
        connection.close()