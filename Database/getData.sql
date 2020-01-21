use Test
go

create function [dbo].[getData]()
returns @ret table(vacancyId uniqueidentifier,url nvarchar(500),position nvarchar(200),location nvarchar(100),Description nvarchar(max),
					SiteAddingDate date,Name nvarchar(100), Website nvarchar(300),country nvarchar(50), type nvarchar(100))
as
	begin
	insert @ret
	select Vacancy.Id,url,position,location,Description,SiteAddingDate,Name,Website,Country,Type from Vacancy,
			Company where Vacancy.CompanyId = Company.Id
	return
end
