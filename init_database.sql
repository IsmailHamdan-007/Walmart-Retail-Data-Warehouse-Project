/*
=============================================================
Create Database and Schemas
=============================================================
Script Purpose:
    This script creates a new database named 'Walmart_DatawarehouseDB' after checking if it already exists. 
    If the database exists, it is dropped and recreated. Additionally, the script sets up three schemas 
    within the database: 'Bronze', 'Silver', and 'Gold'.
	
WARNING:
    Running this script will drop the entire 'Walmart_DatawarehouseDB' database if it exists. 
    All data in the database will be permanently deleted. Proceed with caution 
    and ensure you have proper backups before running this script.
*/


USE master;
Go

IF EXISTS (SELECT 1 FROM sys.databases WHERE name = 'Walmart_DatawarehouseDB')
BEGIN 
	ALTER Database Walmart_DatawarehouseDB SET SINGLE_USER WITH ROLLBACK IMMEDIATE;
	DROP Database Walmart_DatawarehouseDB;
END

-- Crearting Walmart_DatawarehouseDB Database.
CREATE DATABASE Walmart_DatawarehouseDB;
Go

USE Walmart_DatawarehouseDB;
Go

-- Creating the Schemas(Bronze, Silver, Gold).

CREATE SCHEMA Bronze;
Go

CREATE SCHEMA Silver;
Go

CREATE SCHEMA Gold;
GO









