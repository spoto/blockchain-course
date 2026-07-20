// SPDX-License-Identifier: CC-BY-SA-4.0
pragma solidity >=0.8.0 <0.9.0;

contract Visibilities {
    address public sender;

    function test1() public returns (address) {
        sender = msg.sender;
        return sender;
    }

    function test2() external returns (address) {
        sender = msg.sender;
        return sender;
    }

    function test3() public returns (address) {
        // test1() keeps our sender and runs inside our same transaction
        return test1();
    }

    function test4() public returns (address) {
        // test1() receives this contract as sender and runs in an inner transaction
        return this.test1();
    }

    function test5() public returns (address) {
        // test1() receives this contract as sender and runs in an inner transaction
        Visibilities vs = this;
        return vs.test1();
    }

    function test6() public returns (address) {
        // without "this.", the following does not compile
        // test2() receives this contract as sender and runs in an inner transaction
        return this.test2();
    }

    function foo() private returns (address) {
        sender = msg.sender;
        return sender;
    }

    function test7() public returns (address) {
        // foo() keeps our sender and runs inside our same transaction
        return foo();
    }

    // it does not compile
    /*function test8() public returns (address) {
        return this.foo();
    }*/

    function goo() internal returns (address) {
        sender = msg.sender;
        return sender;
    }

    function test9() public returns (address) {
        // goo() keeps our sender and runs inside our same transaction
        return goo();
    }

    // it does not compile
    /*function test10() public returns (address) {
        return this.goo();
    }*/
}
