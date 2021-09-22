/*
배포 후 스크립트 템플릿							
--------------------------------------------------------------------------------------
 이 파일에는 빌드 스크립트에 추가될 SQL 문이 있습니다.		
 SQLCMD 구문을 사용하여 파일을 배포 후 스크립트에 포함합니다.			
 예:      :r .\myfile.sql								
 SQLCMD 구문을 사용하여 배포 후 스크립트의 변수를 참조합니다.		
 예:      :setvar TableName MyTable							
               SELECT * FROM [$(TableName)]					
--------------------------------------------------------------------------------------
*/



if not exists (select 1 from dbo.RoomTypes)
begin 
    insert into dbo.RoomTypes(Title, Description, Price) values
    ('King Size Bed', 'A room with a king-size bed and a windows.', 100),
    ('Two Queen Size Beds','A room with two queen-size beds and a windows', 115),
    ('Executive Suite','Two rooms each with a king-size bed and a windows', 205);
end


if not exists (select 1 from dbo.Rooms)
begin 
    declare @roomId1 int;
    declare @roomId2 int;
    declare @roomId3 int;

    select @roomId1 = Id from dbo.RoomTypes where Title = 'King Size Bed';
    select @roomId2 = Id from dbo.RoomTypes where Title = 'Two Queen Size Beds';
    select @roomId3 = Id from dbo.RoomTypes where Title = 'Executive Suite';

    insert into dbo.Rooms (RoomNumber, RoomTypeId) values
    ('101', @roomId1),
    ('102', @roomId1),
    ('103', @roomId1),
    ('201', @roomId2),
    ('202', @roomId2),
    ('301', @roomId3);
end
    
