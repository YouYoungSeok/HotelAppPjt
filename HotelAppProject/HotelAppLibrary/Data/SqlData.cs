using HotelAppLibrary.Database;
using HotelAppLibrary.Models;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace HotelAppLibrary.Data
{
    public class SqlData : IDatabaseData
    {
        private readonly ISqlDataAccess _db;
        private const string connectionStringName = "SqlDb";


        public SqlData(ISqlDataAccess db)
        {
            _db = db;
        }

        // 예약 가능한 방 검색하기(RoomType)
        public List<RoomTypeModel> GetAvailableRoomType(DateTime startDate, DateTime endDate)
        {
            return _db.LoadData<RoomTypeModel, dynamic>("dbo.spRoomType_GetAvailableTypes",
                                                        new { startDate, endDate },
                                                        connectionStringName,
                                                        true);
        }

        public void BookGuest(string firstName,
                              string lastName,
                              DateTime startDate,
                              DateTime endDate,
                              int roomTypeId)
        {
            GuestModel guest = _db.LoadData<GuestModel, dynamic>("dbo.spGuest_Insert",
                                                                 new { firstName, lastName },
                                                                 connectionStringName,
                                                                 true).First();

            RoomTypeModel roomType = _db.LoadData<RoomTypeModel, dynamic>("select * from dbo.RoomTypes where Id = @Id",
                                                                          new { Id = roomTypeId },
                                                                          connectionStringName,
                                                                          false).First();

            TimeSpan timeStaying = endDate.Date.Subtract(startDate.Date);


            List<RoomModel> availableRooms = _db.LoadData<RoomModel, dynamic>("dbo.spRooms_GetAvailableRooms",
                                                                              new { startDate, endDate, roomTypeId },
                                                                              connectionStringName,
                                                                              true);

            _db.SaveData("dbo.spBooking_Insert",
                new
                {
                    roomId = availableRooms.First().Id,
                    guestId = guest.Id,
                    startDate = startDate,
                    endDate = endDate,
                    totalCost = timeStaying.Days * roomType.Price
                }, connectionStringName, true);

        }

        //예약한 날짜(방) 조회하기 
        public List<BookingFullModel> SearchBookings(string lastName)
        {
            return _db.LoadData<BookingFullModel, dynamic>("dbo.spBooking_Search",
                                                     new { lastName, startDate = DateTime.Now.Date },
                                                     connectionStringName,
                                                     true);

        }

        //해당 방 예약 시 체크인 상태로 변경
        public void CheckInGuest(int bookingId)
        {
            _db.SaveData("dbo.spBooking_CheckIn", new { Id = bookingId }, connectionStringName, true);
        }

        public RoomTypeModel GetRoomTypeById(int id)
        {
            return _db.LoadData<RoomTypeModel, dynamic>("dbo.spRoomType_GetById",
                                                        new { id },
                                                        connectionStringName,
                                                        true).FirstOrDefault();
        }
    }

}
