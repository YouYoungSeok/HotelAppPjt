CREATE PROCEDURE [dbo].[spRoomType_GetAvailableTypes]
	@startDate date,
	@endDate date

	
	--RoomTypes에서 예약날짜가 없는 방 찾기
AS
begin
	set nocount on

	select t.Id, t.Title,T.Description, T.Price 
	from dbo.Rooms r
	inner join dbo.RoomTypes t on t.Id = r.RoomTypeId
	where r.Id not in (
	select b.RoomId 
	from dbo.Bookings b
	where (@startDate < b.StartDate and @endDate > b.EndDate)
		or (b.StartDate <= @endDate and @endDate < b.EndDate)
		or (b.StartDate <= @startDate and @startDate < b.EndDate)
	)
	group by t.Id, t.Title, t.Description, t.Price

end
