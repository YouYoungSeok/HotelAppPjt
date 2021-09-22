
declare @startDate date;
declare @endDate date;
declare @roomTypeId int;


set @startDate ='12/5/19'
set @endDate ='12/10/19'
set @roomTypeId = 4;

select r.*
from dbo.Rooms r
	inner join dbo.RoomTypes t on t.Id = r.RoomTypeId
where r.RoomTypeId = @roomTypeId
and r.Id not in (
select b.RoomId 
from dbo.Bookings b
where (@startDate < b.StartDate and @endDate > b.EndDate)
	or (b.StartDate <= @endDate and @endDate < b.EndDate)
	or (b.StartDate <= @startDate and @startDate < b.EndDate)
);








