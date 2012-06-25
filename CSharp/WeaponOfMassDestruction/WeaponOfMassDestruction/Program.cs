using System;
using System.Collections;
using System.Collections.Generic;
using System.IO;
using System.Linq;

namespace WeaponOfMassDestruction
{
    public class Solution
    {
        static void Main(string[] args)
        {
            var textReader = GetTextReader();
            var k = int.Parse(textReader.ReadLine());
            var values = textReader.ReadLine().Split(' ').Select(int.Parse).ToList();
            var bitArrays = new List<BitArray>();
            for (var i = 0; i < k; i++)
            {
                var blockConnections = textReader.ReadLine();
                var bitArray = new BitArray(k);
                for (var j = 0; j < k; j++)
                {
                    bitArray[j] = blockConnections[j] == 'N' ? false : true;
                }

                AddNewLine(bitArrays, bitArray);
            }

            Console.WriteLine(SortList(bitArrays, values).Aggregate(string.Empty, (result, value) => result + value + " ").Trim());
            //Console.ReadKey();
        }

        private static TextReader GetTextReader()
        {
            return Console.In;
            //return new StreamReader("input00.txt");
        }

        public static void AddNewLine(List<BitArray> bitArrays, BitArray bitArray)
        {
            if (!bitArrays.Any())
            {
                bitArrays.Add(bitArray);
            }
            else
            {
                var valueIndex = bitArrays.Count;
                var connectedPoints = bitArrays.Where(p => p[valueIndex]).ToList();
                var orResult = connectedPoints.Aggregate(new BitArray(bitArray), (current, connectedPoint) => current.Or(connectedPoint));
                foreach (var connectedPoint in connectedPoints)
                {
                    var indexOfPoint = bitArrays.IndexOf(connectedPoint);
                    bitArrays.Remove(connectedPoint);
                    bitArrays.Insert(indexOfPoint, orResult);
                }

                bitArrays.Add(orResult);
            }
        }

        public static IList<int> SortList(List<BitArray> bitArrays, List<int> values)
        {
            var sortedList = new int?[bitArrays.Count];
            for (var i = bitArrays.Count - 1; i >= 0; i--)
            {
                var actualNumber = i + 1;
                var indexAtEntry = values.IndexOf(actualNumber);
                var elementPaths = bitArrays[indexAtEntry];
                if (IsFalseArray(elementPaths))
                {
                    sortedList[indexAtEntry] = actualNumber;
                }
                else
                {
                    for (var j = elementPaths.Count - 1; j >= 0; j--)
                    {
                        if (elementPaths[j] && !sortedList[j].HasValue)
                        {
                            sortedList[j] = actualNumber;
                            break;
                        }
                    }
                }
            }

            return sortedList.Select(ni => ni.Value).ToList();
        }

        private static bool IsFalseArray(BitArray bitArray)
        {
            var orResult = false;
            for (var i = 0; i < bitArray.Length; i++)
            {
                orResult |= bitArray[i];
            }

            return orResult == false;
        }
    }
}
