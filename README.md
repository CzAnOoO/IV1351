# Soundgood Music School

This project is part of the KTH course (IV1351 HT24) and aims to design and build a relational database from scratch to accomplish specified tasks. 


# Project Overview

The database management system used is `PostgreSQL`, with interaction through psql. Throughout the project, we will gradually learn how to model information requirements based on organizational descriptions and translate the model into a functional database (conceptual model → logical models), using relational databases and query language (SQL). The project covers the fundamental concepts of database design.

## Tutorial (Mac)

If using `psql` as the database management tool, navigate to the directory where the  `main.sql`  file is located and open the terminal, then execute the following commands:

`psql -U <username> -d postgres`  
`CREATE DATABASE <database name>;`  
`\c <database name>`  
`\I main.sql`  

## File Structure
`main.sql`  is the main file, which primarily contains the database creation scripts, including creating various tables and invoking other necessary scripts, such as  `inserts_data.sql`. The purpose is to allow users to simply execute this file after cloning the files from GitHub to their local environment to set up the database.

The script for inserting data is  `inserts_data.sql`, which shows which tables in the database are populated with data. The data files are stored in  `.csv`  format in the  `data`  folder and can be modified or replaced if necessary. 

## Team Members

[Zhengan Chen, zhenganc@ug.kth.se]  
[Jacob Polanco Johansson, jacobpj@ug.kth.se]   


