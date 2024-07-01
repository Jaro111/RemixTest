// SPDX-License-Identifier: MIT
pragma solidity 0.8.25;


contract StructExample {

    address payable sender = payable(msg.sender);

    struct PaymentReceived {
        address from;
        uint amount;
    }

    mapping (address => PaymentReceived) paymentFromAddress;

    PaymentReceived public payment;

    function getContractBalance () public view returns(uint) {
        return address(this).balance;
    }
    function getPaymentFromAddress (address _addr) public view returns (uint) {
        return paymentFromAddress[_addr].amount;
    }

    function payContract () public payable {
        payment = PaymentReceived(msg.sender, msg.value);
        paymentFromAddress[msg.sender].from  = msg.sender;
        paymentFromAddress[msg.sender].amount += msg.value;
    }


    function withdrawEth (uint amount) public payable {
        require(paymentFromAddress[msg.sender].amount >= amount, "Not enough money" );
        paymentFromAddress[msg.sender].amount -= amount;
        sender.transfer(amount);

    }

    receive() external payable {
        payContract();
        paymentFromAddress[msg.sender].from  = msg.sender;
        paymentFromAddress[msg.sender].amount += msg.value;
     }
}