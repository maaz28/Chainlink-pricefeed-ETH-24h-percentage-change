// SPDX-License-Identifier: MIT

pragma solidity >=0.8.0 <0.9.0;
import "@chainlink/contracts/src/v0.8/interfaces/AggregatorV3Interface.sol";

contract PriceFeedEthPrice  {
    AggregatorV3Interface internal priceFeed;
    
    constructor() {
           /**
            * Network: Rinkeby testnet
            * Aggregator: ETH/USD
            * Address: 0x8A753747A1Fa494EC906cE90E9f37563A8AF630e
            * Change address to the relevant price feed contract
            * https://docs.chain.link/docs/ethereum-addresses/
            */
        priceFeed = AggregatorV3Interface(
            0x8A753747A1Fa494EC906cE90E9f37563A8AF630e
        );
    }

    function getHistoricalPrice(uint80 roundId) private view returns (int256) {
        // returns ETH price past 24 hours, change this number to get 1h, 4h pricedata
        (, int256 price, , , ) = priceFeed.getRoundData(roundId - 24); 
        return price;
    }

    function percentageChange() public view returns (int256) {
        // get latest data
        (uint80 roundId, int256 price, , , ) = priceFeed.latestRoundData();
        // get 24h back historical price
        int256 histPrice = getHistoricalPrice(roundId);
        // 24h percentge change formula
        int256 change = (price - histPrice) / 1000000000;
        return change; 
    }
}
