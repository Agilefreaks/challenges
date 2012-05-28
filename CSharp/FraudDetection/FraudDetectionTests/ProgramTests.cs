using System.Collections.Generic;
using FraudDetection;
using NUnit.Framework;

namespace FraudDetectionTests
{
    [TestFixture]
    public class ProgramTests
    {
        [Test]
        public void Detect_Always_ReturnsAListOfInts()
        {
            IList<decimal> fraudulentOrderIds = Solution.DetectFraudulentOrders(new List<Order>());

            Assert.NotNull(fraudulentOrderIds);
        }

        [Test]
        public void Detect_GivenAListOfTwoOrdersWithTheSameEmailAddressAndDealIdButDifferentCCCNo_WillReturnBothIds()
        {
            Order order1 = new Order { OrderId = 1, EmailAddress = "email@a.a", DealId = 1, CreditCardNo = "12345689010" };
            Order order2 = new Order { OrderId = 2, EmailAddress = "email@a.a", DealId = 1, CreditCardNo = "12345689011" };

            var detect = Solution.DetectFraudulentOrders(new List<Order> { order1, order2 });

            CollectionAssert.Contains(detect, 1);
            CollectionAssert.Contains(detect, 2);
        }

        [Test]
        public void Detect_GivenAListOfTwoOrdersWithTheSameEmailAddressAndDealIdButDifferentCCCNo_WillReturnBothIdsInAscendingOrder()
        {
            Order order1 = new Order { OrderId = 1, EmailAddress = "email@a.a", DealId = 1, CreditCardNo = "12345689010" };
            Order order2 = new Order { OrderId = 2, EmailAddress = "email@a.a", DealId = 1, CreditCardNo = "12345689011" };

            var detect = Solution.DetectFraudulentOrders(new List<Order> { order1, order2 });

            Assert.AreEqual(1, detect[0]);
            Assert.AreEqual(2, detect[1]);
        }

        [Test]
        public void Detect_GivenAListOfTwoOrdersWithEmailOnlyDifferentByCaseAndSameDealIdButDifferentCCCNo_WillReturnBothIds()
        {
            Order order1 = new Order { OrderId = 1, EmailAddress = "emAiL@a.a", DealId = 1, CreditCardNo = "12345689010" };
            Order order2 = new Order { OrderId = 2, EmailAddress = "Email@a.a", DealId = 1, CreditCardNo = "12345689011" };

            var detect = Solution.DetectFraudulentOrders(new List<Order> { order1, order2 });

            CollectionAssert.Contains(detect, 1);
            CollectionAssert.Contains(detect, 2);
        }

        [Test]
        public void Detect_GivenAListOfTwoOrdersWithEmailOnlyDifferentByADotInTheUserPartButDifferentCCCNo_WillReturnBothIds()
        {
            Order order1 = new Order { OrderId = 1, EmailAddress = "emAi.L@abc.com", DealId = 1, CreditCardNo = "12345689010" };
            Order order2 = new Order { OrderId = 2, EmailAddress = "Email@abc.com", DealId = 1, CreditCardNo = "12345689011" };

            var detect = Solution.DetectFraudulentOrders(new List<Order> { order1, order2 });

            CollectionAssert.Contains(detect, 1);
            CollectionAssert.Contains(detect, 2);
        }

        [Test]
        public void Detect_GivenAListOfTwoOrdersWithDifferentEmailsAndSameDealId_WillReturnEmptyList()
        {
            Order order1 = new Order { OrderId = 1, EmailAddress = "emAiL1@abc.com", DealId = 1, CreditCardNo = string.Empty };
            Order order2 = new Order { OrderId = 2, EmailAddress = "Email2@abc.com", DealId = 1, CreditCardNo = string.Empty };

            var detect = Solution.DetectFraudulentOrders(new List<Order> { order1, order2 });

            CollectionAssert.IsEmpty(detect);
        }

        [Test]
        public void Detect_GivenAListOfTwoOrdersWithEmailDifferentOnlyByPartAfterPlusButDifferentCCCNo_ReturnsBothIds()
        {
            Order order1 = new Order { OrderId = 1, EmailAddress = "emAiL+1@abc.com", DealId = 1, CreditCardNo = "12345689010" };
            Order order2 = new Order { OrderId = 2, EmailAddress = "Email+2@abc.com", DealId = 1, CreditCardNo = "12345689011" };

            var detect = Solution.DetectFraudulentOrders(new List<Order> { order1, order2 });

            CollectionAssert.Contains(detect, 1);
            CollectionAssert.Contains(detect, 2);
        }

        [Test]
        public void Detect_GivenAListOfTwoOrdersWithSameEmailAndSameDealIdButSameCCCNo_ReturnsEmptyList()
        {
            Order order1 = new Order { OrderId = 1, EmailAddress = "emAiL+1@abc.com", DealId = 1, CreditCardNo = "12345689011" };
            Order order2 = new Order { OrderId = 2, EmailAddress = "Email+2@abc.com", DealId = 1, CreditCardNo = "12345689011" };

            var detect = Solution.DetectFraudulentOrders(new List<Order> { order1, order2 });

            CollectionAssert.IsEmpty(detect);
        }

        [Test]
        public void Detect_GivenAListOfTwoOrdersWithSameAddressButDifferentCCCNoAndDifferentEmailAddresses_ReturnsBothIds()
        {
            Order order1 = new Order { OrderId = 1, StreetAddress = "asd", City = "Asd", State = "Asd", ZipCode = "asd", DealId = 1, CreditCardNo = "12345689010", EmailAddress = "email1@asd.com" };
            Order order2 = new Order { OrderId = 2, StreetAddress = "aSd", City = "asd", State = "asd", ZipCode = "asD", DealId = 1, CreditCardNo = "12345689011", EmailAddress = "email2@asd.com" };

            var detect = Solution.DetectFraudulentOrders(new List<Order> { order1, order2 });

            CollectionAssert.Contains(detect, 1);
            CollectionAssert.Contains(detect, 2);
        }

        [Test]
        public void Detect_GivenAListOfTwoOrdersWithAddressDifferentByFormButDifferentCCCNoAndDifferentEmailAddresses_ReturnsBothIds()
        {
            Order order1 = new Order { OrderId = 1, StreetAddress = "asd St.", City = "Asd", State = "California", ZipCode = "asd", DealId = 1, CreditCardNo = "12345689010", EmailAddress = "email1@asd.com" };
            Order order2 = new Order { OrderId = 2, StreetAddress = "aSd Street", City = "asd", State = "Ca", ZipCode = "asD", DealId = 1, CreditCardNo = "12345689011", EmailAddress = "email2@asd.com" };

            var detect = Solution.DetectFraudulentOrders(new List<Order> { order1, order2 });

            CollectionAssert.Contains(detect, 1);
            CollectionAssert.Contains(detect, 2);
        }

        [Test]
        public void Normalize_Always_ReplacesLongWordsWithTheirShortForms()
        {
            var order = new Order
                            {
                                StreetAddress = "Street Road",
                                State = "Illinois California New York",
                            };
            var orders = new List<Order> { order };

            Solution.Normalize(orders);

            order = orders[0];
            Assert.AreEqual("st. rd.", order.StreetAddress);
            Assert.AreEqual("il ca ny", order.State);
        }

        [Test]
        public void Normalize_Always_NormalizesEmailAddress()
        {
            var order = new Order
            {
                EmailAddress = "eM.ail+1@aSd.com"
            };
            var orders = new List<Order> { order };

            Solution.Normalize(orders);

            order = orders[0];
            Assert.AreEqual("email@asd.com", order.EmailAddress);
        }

        [Test]
        public void GetOrders_Always_ReturnsANumberOfLinesEqualToTheFirstInput()
        {
            Solution.ConsoleReadFunc = () => "2";

            var orders = Solution.ReadOrders();

            Assert.AreEqual(2, orders.Count);
        }

        [Test]
        public void GetOrders_Always_CallsGetOrderForTheGivenNumberOfTimes()
        {
            int readOrderCount = 0;
            Solution.ConsoleReadFunc = () => "2";
            Solution.ReadOrderFunc = () =>
                                        {
                                            readOrderCount++;
                                            return new Order();
                                        };

            Solution.ReadOrders();

            Assert.AreEqual(2, readOrderCount);
        }

        [Test]
        public void ReadOrder_Always_CallsConsoleReadFunc()
        {
            bool wasCalled = false;
            Solution.ConsoleReadFunc = () =>
                                          {
                                              wasCalled = true;
                                              return "1,1,bugs@bunny.com,123 Sesame St.,New York,NY,10011,12345689010";
                                          };

            var order = Solution.ReadOrder();

            Assert.IsTrue(wasCalled);
        }

        [Test]
        public void ReadOrder_Always_SetsTheRightDataOnTheOrder()
        {
            Solution.ConsoleReadFunc = () => "1,1,bugs@bunny.com,123 Sesame St.,New York,NY,10011,12345689010";

            var order = Solution.ReadOrder();

            Assert.AreEqual(1, order.OrderId);
            Assert.AreEqual(1, order.DealId);
            Assert.AreEqual("bugs@bunny.com", order.EmailAddress);
            Assert.AreEqual("123 Sesame St.", order.StreetAddress);
            Assert.AreEqual("New York", order.City);
            Assert.AreEqual("NY", order.State);
            Assert.AreEqual("10011", order.ZipCode);
            Assert.AreEqual("12345689010", order.CreditCardNo);
        }
    }
}
