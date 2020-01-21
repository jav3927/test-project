use test
go

alter procedure InsertNewVacancy @json nvarchar(max)
as

declare @DataSourceId uniqueidentifier

if exists(select * from DataSource where convert(nvarchar(255), Url) = json_value(@json, '$.url'))
begin
	select @DataSourceId = Id from DataSource where Url = json_value(@json, '$.url')
	update DataSource set LastProcessingDate = getdate() where Id = @DataSourceId
end
else
begin
	set @DataSourceId = newid()
	insert into DataSource values(@DataSourceId, json_value(@json, '$.url'), null, getdate())
end

declare @Company_name nvarchar(100),
	@Type nvarchar(100),
	@Website nvarchar(300),
	@Country nvarchar(50),
	@Url nvarchar(500),
	@Position nvarchar(200),
	@Location nvarchar(100),
	@Description nvarchar(max),
	@SiteAddingDate date 

declare cur1 cursor local
for select *
from openjson(@json, '$.positions')
with (
    Company_name nvarchar(100) '$.company_name',
	Type nvarchar(100) '$.industry',
	Website nvarchar(300) '$.website',
	Country nvarchar(50) '$.company_country',
	Url nvarchar(500) '$.url',
	Position nvarchar(200) '$.position',
	Location nvarchar(100) '$.location',
	Description nvarchar(max) '$.description',
	SiteAddingDate date '$.date'
)

begin try
	open cur1

	fetch next from cur1 into @Company_name, @Type, @Website, @Country, @Url, @Position, @Location, @Description, @SiteAddingDate

	while @@fetch_status = 0
	begin
		declare @CompanyId uniqueidentifier
		if @Company_name is not null
		begin
			if exists(select * from Company where Name = @Company_name)
				select @CompanyId = Id from Company where Name = @Company_name
			else
			begin
				set @CompanyId = newid()
				insert into Company values(@CompanyId, @Company_name, @Type, @Website, @Country)
			end
		end
		else set @CompanyId = null

		if dbo.isExist(@Url, @Position, @CompanyId) < 1
			insert into Vacancy(Url, DataSourceId, CompanyId, Position, Location, Description, SiteAddingDate, DbAddingDate)
				values(@Url, @DataSourceId, @CompanyId, @Position, @Location, @Description, @SiteAddingDate, getdate())

		fetch next from cur1 into @Company_name, @Type, @Website, @Country, @Url, @Position, @Location, @Description, @SiteAddingDate
	end 

	close cur1
end try
begin catch
	close cur1
end catch
