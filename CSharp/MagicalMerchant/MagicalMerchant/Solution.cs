using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;

namespace MagicalMerchant
{
    public class Solution
    {
        static void Main(string[] args)
        {
            var streamReader = GetStreamReader();
            var inputs = streamReader.ReadLine().Split(' ');
            var _citiesCount = int.Parse(inputs[0]);
            var roadsCount = int.Parse(inputs[1]);
            var startingGold = int.Parse(inputs[2]);
            var _cityRoads = new List<Tuple<int, int>>[_citiesCount];
            for (var i = 0; i < _citiesCount; i++)
            {
                _cityRoads[i] = new List<Tuple<int, int>>();
            }

            for (var i = 0; i < roadsCount; i++)
            {
                inputs = streamReader.ReadLine().Split(' ');
                _cityRoads[int.Parse(inputs[0]) - 1].Add(new Tuple<int, int>(int.Parse(inputs[1]) - 1, int.Parse(inputs[2])));
                _cityRoads[int.Parse(inputs[1]) - 1].Add(new Tuple<int, int>(int.Parse(inputs[0]) - 1, int.Parse(inputs[2])));
            }

            inputs = streamReader.ReadLine().Split(' ');
            var _cityGold = new int[_citiesCount];
            for (var i = 0; i < _citiesCount; i++)
            {
                _cityGold[i] = int.Parse(inputs[i]);
            }

            var _obtainedGold = new int[_citiesCount];
            _obtainedGold[0] = startingGold;
            var newMaxFound = true;
            while (newMaxFound)
            {
                newMaxFound = false;
                for (var i = 0; i < _citiesCount; i++)
                {
                    for (var j = 0; j < _cityRoads[i].Count; j++)
                    {
                        var currentCity = _cityRoads[i][j].Item1;
                        var goldAtDestination = (_obtainedGold[i] - _cityRoads[i][j].Item2 + _cityGold[currentCity]) / 2;
                        if (goldAtDestination > _obtainedGold[currentCity])
                        {
                            _obtainedGold[currentCity] = goldAtDestination;
                            newMaxFound = true;
                        }
                    }
                }                
            }

            Console.WriteLine(_obtainedGold[_citiesCount - 1]);
        }

        private static TextReader GetStreamReader()
        {
            //return new StreamReader("input00.txt");
            return Console.In;
        }
    }
}
