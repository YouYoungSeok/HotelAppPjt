CREATE PROCEDURE [dbo].[spGuest_Insert]
	@firstName nvarchar(50),
	@lastName nvarchar(50)

AS
begin  --입력된 @firstName / @lastName 으로 저장이 되어있는지 확인한다 (예약자 이름 확인)
	set nocount on;

	if not exists (select 1 from dbo.Guests where FirstName = @firstName and LastName = @lastName)
	begin
		insert into dbo.Guests (FirstName, LastName) values (@firstName, @lastName);
	end

	select [Id], [FirstName], [LastName]
	from dbo.Guests
	where FirstName = @firstName and LastName = @lastName;

end

