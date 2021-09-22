CREATE PROCEDURE [dbo].[spBooking_CheckIn]
	@Id int
	
AS
begin
	set nocount on;

	update dbo.Bookings
	set CheckedIn = 1
	where Id = @Id;

end

