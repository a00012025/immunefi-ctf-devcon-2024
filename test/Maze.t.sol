// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.25;

import {Test} from "forge-std/Test.sol";
import {Setup} from "../src/Maze.sol";

contract MazeTest is Test {
    Setup public s;

    function setUp() public {
        s = new Setup();
    }

    function testSolveMaze() public {
        (bool success, ) = s.maze().call(
            hex"61616177777777777761616161616161616177776161616161617777616161776161617777646464646464737364646464646464646473"
        );
        assertTrue(success);
        assertTrue(s.isSolved());
    }
}
