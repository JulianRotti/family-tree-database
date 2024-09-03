# MySQL Database Setup

This documentation provides a brief overview of setting up a MySQL database in an OS-agnostic manner.

1. **Install MySQL**: Begin by installing MySQL on your system. Refer to the official MySQL documentation for detailed installation instructions specific to your operating system.

2. **Database and User Creation**: Once MySQL is installed, navigate to the directory containing the `setup.sql` file.

    - **Step 2.1: Login to MySQL**: Open a terminal and login to MySQL as the root user using the following command:

        ```
        mysql -u root -p
        ```

        Enter your password when prompted.

    - **Step 2.2: Source the setup files**: After logging in to MySQL, use the following command to execute the `setup.sql` script:

        ```
        source schema.sql
        source seeds/fill_test_data.sql
        source setup_dev_user.sql
        ```

