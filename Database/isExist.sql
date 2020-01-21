use test
go

create function IsExist(@Url nvarchar(500), @Position nvarchar(200), @CompanyId uniqueidentifier)
returns bit

begin
	declare @Result bit

	if exists(select * from Vacancy where Url = @Url) or
		exists(select * from Vacancy where Position = @Position and CompanyId = @CompanyId)
		set @Result = 1
	else set @Result = 0

	return @Result
end