using System.Collections;
using System.Collections.Generic;
using NUnit.Framework;
using SharpTestsEx;
using WeaponOfMassDestruction;

namespace WeaponOfMassDestructionTests
{
    [TestFixture]
    public class SolutionTests
    {
        [Test]
        public void AddNewLine_NoOtherLines_AddNewLine()
        {
            var pathMatrix = new List<BitArray>();
            var path = new BitArray(5);

            Solution.AddNewLine(pathMatrix, path);

            pathMatrix.Count.Should().Be.EqualTo(1);
            pathMatrix[0].Should().Be.EqualTo(path);
        }

        [Test]
        public void AddNewLine_PreviousLinesExistButArNotConnectedToCurrentLine_AddsLine()
        {
            var pathMatrix = new List<BitArray> { new BitArray(5) };
            var path = new BitArray(5);

            Solution.AddNewLine(pathMatrix, path);

            pathMatrix.Count.Should().Be.EqualTo(2);
            Assert.AreEqual(path, pathMatrix[1]);
        }

        [Test]
        public void AddNewLine_PreviousLineExistAndArConnectedToCurrentLine_AddsLineAndSetsAllConnectedLinesIncludingSelfToResultOfOrOperation()
        {
            var pathMatrix = new List<BitArray>
                                 {
                                     new BitArray(new[] {false, false, false, true}),
                                     new BitArray(new[] {false, false, true, false}),
                                 };
            var path = new BitArray(new[] { false, true, false, true });

            Solution.AddNewLine(pathMatrix, path);

            pathMatrix.Count.Should().Be.EqualTo(3);
            Assert.AreEqual(new BitArray(new[] { false, false, false, true }), pathMatrix[0]);
            Assert.AreEqual(new BitArray(new[] { false, true, true, true }), pathMatrix[1]);
            Assert.AreEqual(new BitArray(new[] { false, true, true, true }), pathMatrix[2]);
        }

        [Test]
        public void SortList_Always_SetsThePointWithHighestValueToPositionFurthestPosition()
        {
            var bitArrays = new List<BitArray>
                                {
                                    new BitArray(new [] { true, true, true, true }),
                                    new BitArray(new [] { true, true, true, true }),
                                    new BitArray(new [] { true, true, true, true }),
                                    new BitArray(new [] { true, true, true, true }),
                                };

            var sortedList = Solution.SortList(bitArrays, new List<int> { 4, 3, 2, 1 });

            Assert.AreEqual(new List<int> { 1, 2, 3, 4 }, sortedList);
        }
    }
}
