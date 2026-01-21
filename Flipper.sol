// SPDX-License-Identifier: Apache-2.0

pragma solidity ^0.8.0;

interface Flipper {
    function flip() external;
    function get() external view returns (bool);
}
