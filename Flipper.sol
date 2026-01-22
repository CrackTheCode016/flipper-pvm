// SPDX-License-Identifier: Apache-2.0

pragma solidity ^0.8.0;

interface Flipper {
    /// Event emitted when the value is flipped
    event Flipped(bool new_value);
    /// Flip the boolean value
    function flip() external;
    /// Get the current boolean value
    function get() external view returns (bool);
}
