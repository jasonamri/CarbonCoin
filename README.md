# CarbonCoin
Response to ChainSafe's bounty (see https://github.com/ChainSafeSystems/ECOHacks)


Putting the Paris agreement on the blockchain? Cryptocurrency and Climate Change? Meet CarbonCoin! Implementing internationally transferable mitigation outcomes (ITMOs) on the Ethereum blockchain.

Article 6.2 of the Paris Agreement requests a method for tranfering and accounting for ITMOs. CarbonCoin uses a solidity smart contract to track, transfer, create, and mitigate (burn) ITMOs using the ERC721 standard for non-fungible tokens.

### Events
All events emit the ID, date, country, description of emmission, and tonnes of CO2 associated with each token.
  
- Created (Event type 0) - also emits creator's address
- Transfered (Event type 1) - also emits orgin and destination address
- Absorbed (Event type 2) - also emits mitigator's addresss


 
Read more on my blog! https://www.jasonamri.com/?p=137
