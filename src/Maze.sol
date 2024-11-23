pragma solidity ^0.8.25;

contract Setup {
    address public maze;

    constructor() {
        bytes
            memory code = hex"61025e80600a3d393df35f3560e01c63deadbeef146100135761001c565b5f545f5260205ff35b7f41327924f1b91fe820120120804b93f9248e3926010092082080000036fbefb85f527f8c4f3a002402480003238db6237239920124124120b1db1249271c64120924006020527f24904920be1b9249246fa082092492003238e493c6fc9900120804824b7e47e46040527ff9fb9ff9dc9804020920904b927ee49249da0804004920131c9230c30c4990486060527f260920100904132493f7230df1904804120804c7e3fe7fe3e2640200000008316080527f4000b7279ff93bee64100000820831f11bf1c93ce804920104800ced89e7718f60a0526a013feff7ff7ffe8008040060c052610232610140525f610100525b6101005180361461024557600190610120376101205160f81c80607714610149578060611461018857806073146101c75780606414610206575b6101006031610140510361065090068080929004602002519061010090061c6001901660011461025c576101405250610100516001016101005261010f565b6101006001610140510361065090068080929004602002519061010090061c6001901660011461025c576101405250610100516001016101005261010f565b6101006031610140510161065090068080929004602002519061010090061c6001901660011461025c576101405250610100516001016101005261010f565b6101006001610140510161065090068080929004602002519061010090061c6001901660011461025c576101405250610100516001016101005261010f565b6101405161064f146102565761025c565b60015f55005b00";
        address _maze;
        assembly {
            _maze := create(0, add(code, 0x20), mload(code))
        }
        maze = _maze;
    }

    function isSolved() public returns (bool) {
        (bool success, bytes memory result) = maze.call(hex"DEADBEEF");
        uint256 ret = abi.decode(result, (uint256));
        if (ret == 0x1) {
            return true;
        }

        return false;
    }
}
