-- create database test

use test
go

create table Company (
Id uniqueidentifier unique not null,
Name nvarchar(100) not null,
Type nvarchar(100) null,
Website nvarchar(300) null,
Country nvarchar(50) null,

constraint IdCompany primary key(Id))

create table DataSource (
Id uniqueidentifier unique not null,
Url nvarchar(500) unique not null,
UserNote nvarchar(max) null,
LastProcessingDate datetime null,

constraint IdDataSource primary key(Id))

create table Vacancy (
Id uniqueidentifier unique not null default NEWID(),
Url nvarchar(500) not null,
DataSourceId uniqueidentifier not null,
CompanyId uniqueidentifier null,
Position nvarchar(200) not null,
Location nvarchar(100) null,
Description nvarchar(max) null,
SiteAddingDate date null,
DbAddingDate datetime not null,

constraint IdVacancy primary key(Id),
constraint IdVacancyDataSource foreign key(DataSourceId) references DataSource(Id),
constraint IdVacancyCompany foreign key(CompanyId) references Company(Id))