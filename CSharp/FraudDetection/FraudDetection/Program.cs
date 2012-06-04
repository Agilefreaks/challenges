using System;
using System.Collections.Generic;

namespace FraudDetection
{
    public class Order
    {
        public decimal OrderId { get; set; }

        public decimal DealId { get; set; }

        public string EmailAddress { get; set; }

        public string StreetAddress { get; set; }

        public string City { get; set; }

        public string State { get; set; }

        public string ZipCode { get; set; }

        public string CreditCardNo { get; set; }

        public Order()
        {
            EmailAddress = "a@a.a";
            StreetAddress = string.Empty;
            City = string.Empty;
            State = string.Empty;
            ZipCode = string.Empty;
        }

        public bool IsFraud { get; set; }
    }

    public class Solution
    {
        private static readonly IDictionary<string, string> stateReplacers = new Dictionary<string, string>
                                                                        {
                                                                            {"illinois", "il"}, 
                                                                            {"california", "ca"}, 
                                                                            {"new york", "ny"}, 
                                                                        };
        private static readonly IDictionary<string, string> addressReplacers = new Dictionary<string, string>
                                                                        {
                                                                            {"street", "st."}, 
                                                                            {"road", "rd."}, 
                                                                        };

        public static Func<string> ConsoleReadFunc { get; set; }

        public static Func<Order> ReadOrderFunc { get; set; }

        static Solution()
        {
            ConsoleReadFunc = ConsoleRead;
            ReadOrderFunc = ReadOrder;
        }

        static void Main(string[] args)
        {
            var readOrders = ReadOrders();
            var detectFraudulentOrders = DetectFraudulentOrders(readOrders);
            Console.WriteLine(string.Join(",", detectFraudulentOrders));
        }

        public static IList<Order> ReadOrders()
        {
            IList<Order> orders = new List<Order>();
            var numberOfOrdersToRead = Int32.Parse(ConsoleReadFunc());
            for (int i = 0; i < numberOfOrdersToRead; i++)
            {
                orders.Add(ReadOrderFunc());
            }

            return orders;
        }

        public static Order ReadOrder()
        {
            var orderString = ConsoleReadFunc();
            var orderParts = orderString.Split(',');

            return new Order
                       {
                           OrderId = decimal.Parse(orderParts[0]),
                           DealId = decimal.Parse(orderParts[1]),
                           EmailAddress = orderParts[2],
                           StreetAddress = orderParts[3],
                           City = orderParts[4],
                           State = orderParts[5],
                           ZipCode = orderParts[6],
                           CreditCardNo = orderParts[7]
                       };
        }

        public static IList<decimal> DetectFraudulentOrders(IList<Order> orders)
        {
            Normalize(orders);
            var fraudulentOrders = new List<decimal>();
            for (int i = 0; i < orders.Count; i++)
            {
                bool isFraudulent = false;
                for (int j = i + 1; j < orders.Count; j++)
                {
                    if (AreFraudulent(orders[i], orders[j]))
                    {
                        orders[j].IsFraud = true;
                        isFraudulent = true;
                        fraudulentOrders.Add(orders[j].OrderId);
                    }
                }

                if (isFraudulent)
                {
                    fraudulentOrders.Add(orders[i].OrderId);
                }
            }

            fraudulentOrders.Sort();
            return fraudulentOrders;
        }

        public static void Normalize(IList<Order> orders)
        {
            foreach (var order in orders)
            {
                NormalizeOrder(order);
            }
        }

        private static void NormalizeOrder(Order order)
        {
            NormalizeAddress(order);
            order.EmailAddress = NormalizeEmailAddress(order);
        }

        private static string ConsoleRead()
        {
            return Console.ReadLine();
        }

        private static void NormalizeAddress(Order order)
        {
            order.StreetAddress = order.StreetAddress.ToLowerInvariant();
            order.City = order.City.ToLowerInvariant();
            order.State = order.State.ToLowerInvariant();
            order.ZipCode = order.ZipCode.ToLowerInvariant();

            foreach (var stateReplacer in stateReplacers)
            {
                order.State = order.State.Replace(stateReplacer.Key, stateReplacers[stateReplacer.Key]);
            }

            foreach (var addressReplacer in addressReplacers)
            {
                order.StreetAddress = order.StreetAddress.Replace(addressReplacer.Key, addressReplacers[addressReplacer.Key]);
            }
        }

        private static string NormalizeEmailAddress(Order order)
        {
            var emailAddress = order.EmailAddress.ToLowerInvariant();
            var emailParts = emailAddress.Split('@');
            var userName = emailParts[0].Replace(".", string.Empty);
            userName = userName.Split('+')[0];
            var address = string.Join("@", userName, emailParts[1]);
            return address;
        }

        private static bool AreFraudulent(Order order1, Order order2)
        {
            var areFraudulent = order1.DealId == order2.DealId;
            areFraudulent &= !(order1.CreditCardNo.Equals(order2.CreditCardNo, StringComparison.InvariantCulture));
            areFraudulent &= (order1.EmailAddress == order2.EmailAddress) || IsSameAddress(order1, order2);

            return areFraudulent;
        }

        private static bool IsSameAddress(Order order1, Order order2)
        {
            return order1.StreetAddress == order2.StreetAddress
                && order1.City == order2.City
                && order1.State == order2.State
                && order1.ZipCode == order2.ZipCode;
        }
    }
}
