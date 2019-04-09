import Foundation
import SwiftyJSON

class Parser {

    init() {
    }

    func parse(response: BinanceChain.Response, data: Data) throws {
        guard let json = try? JSON(data: data) else {
            // TODO error
            return
        }
        self.parse(json, response: response)
    }

    func parse(_ json: JSON, response: BinanceChain.Response) {
        // Subclasses to override
    }

    func parseTimes(_ json: JSON) -> Times {
        let times = Times()
        times.apTime = json["ap_time"].stringValue
        times.blockTime = json["block_time"].stringValue
        return times
    }
    
    func parsePeer(_ json: JSON) -> Peer {
        let peer = Peer()
        peer.id = json["id"].stringValue
        peer.listenAddr = json["listen_addr"].stringValue
        peer.originalListenAddr = json["original_listen_addr"].stringValue
        peer.accessAddr = json["access_addr"].stringValue
        peer.streamAddr = json["stream_addr"].stringValue
        peer.network = json["network"].stringValue
        peer.version = json["version"].stringValue
        peer.capabilities = json["capabilities"].map({ $0.1.stringValue })
        peer.accelerated = json["accelerated"].boolValue
        return peer
    }

    func parseToken(_ json: JSON) -> Token {
        let token = Token()
        token.name = json["name"].stringValue
        token.symbol = json["symbol"].stringValue
        token.originalSymbol = json["original_symbol"].stringValue
        token.totalSupply = json["total_supply"].stringValue
        token.owner = json["owner"].stringValue
        return token
    }
    
    func parseTrade(_ json: JSON) -> Trade {
        let trade = Trade()
        trade.baseAsset = json["baseAsset"].stringValue
        trade.blockHeight = json["blockHeight"].intValue
        trade.buyFee = json["buyFee"].stringValue
        trade.buyerId = json["buyerId"].stringValue
        trade.price = json["price"].stringValue
        trade.quantity = json["quantity"].stringValue
        trade.quoteAsset = json["quoteAsset"].stringValue
        trade.sellFee = json["sellFee"].stringValue
        trade.sellerId = json["sellerId"].stringValue
        trade.symbol = json["symbol"].stringValue
        // TODO
        //trade.time = Date(json["time"].doubleValue)
        trade.tradeId = json["tradeId"].stringValue
        return trade
    }
    
    func parseMarketDepth(_ json: JSON) -> MarketDepth {
        let marketDepth = MarketDepth()
        marketDepth.asks = json["asks"].map({ self.parsePriceQuantity($0.1) })
        marketDepth.bids = json["bids"].map({ self.parsePriceQuantity($0.1) })
        return marketDepth
    }
    
    func parsePriceQuantity(_ json: JSON) -> PriceQuantity {
        let priceQuantity = PriceQuantity()
        priceQuantity.price = json.arrayValue[0].stringValue
        priceQuantity.quantity = json.arrayValue[1].stringValue
        return priceQuantity
    }
    
    func parseValidators(_ json: JSON) -> Validators {
        let validators = Validators()
        validators.blockHeight = json["block_height"].intValue
        validators.validators = json["validators"].map({ self.parseValidator($0.1) })
        return validators
    }
    
    func parseValidator(_ json: JSON) -> Validator {
        let validator = Validator()
        validator.address = json["address"].stringValue
        // TODO
        //validator.publicKey = json["pub_key"].dataValue
        validator.votingPower = json["voting_power"].intValue
        return validator
    }

    func parseTransactions(_ json: JSON) -> Transactions {
        let transactions = Transactions()
        transactions.total = json["total"].intValue
        transactions.tx = json["tx"].map({ self.parseTx($0.1) })
        return transactions
    }

    func parseTx(_ json: JSON) -> Tx {
        let tx = Tx()
        tx.blockHeight = json["blockHeight"].doubleValue
        tx.code = json["code"].intValue
        tx.confirmBlocks = json["confirm_blocks"].doubleValue
        tx.data = json["data"].stringValue
        tx.fromAddr = json["from_addr"].stringValue
        tx.orderId = json["orderId"].stringValue
        // TODO
        //tx.timeStamp = json["timeStamp"].stringValue
        tx.toAddr = json["toAddr"].stringValue
        // TODO
        //tx.txAge = json["tx_age"].doubleValue
        tx.txAsset = json["txAsset"].stringValue
        tx.txFee = json["txFee"].stringValue
        tx.txHash = json["txHash"].stringValue
        tx.txType = json["txType"].stringValue
        tx.value = json["value"].stringValue
        return tx
    }

    func parseNodeInfo(_ json: JSON) -> NodeInfo {
        let nodeInfo = NodeInfo()
        nodeInfo.id = json["id"].stringValue
        nodeInfo.listenAddr = json["listen_addr"].stringValue
        nodeInfo.network = json["network"].stringValue
        nodeInfo.version = json["version"].stringValue
        nodeInfo.channels = json["channels"].stringValue
        nodeInfo.moniker = json["moniker"].stringValue
        // TODO
        // nodeInfo.other
        // nodeInfo.syncInfo
        nodeInfo.validatorInfo = self.parseValidator(json["validator_info"])
        return nodeInfo
    }
    
    func parseMarket(_ json: JSON) -> Market {
        let market = Market()
        market.baseAssetSymbol = json["base_asset_symbol"].stringValue
        market.quoteAssetSymbol = json["quote_asset_symbol"].stringValue
        market.price = json["list_price"].stringValue
        market.tickSize = json["tick_size"].stringValue
        market.lotSize = json["lot_size"].stringValue
        // TODO
        return market
    }

    func parseAccount(_ json: JSON) -> Account {
        let account = Account()
        account.accountNumber = json["account_number"].intValue
        account.address = json["address"].stringValue
        account.balances = json["balances"].map({ self.parseBalance($0.1) })
        // TODO
        // account.publicKey = json["public_key"]
        account.sequence = json["sequence"].intValue
        return account
    }
    
    func parseBalance(_ json: JSON) -> Balance {
        let balance = Balance()
        balance.symbol = json["symbol"].stringValue
        balance.free = json["free"].stringValue
        balance.locked = json["locked"].stringValue
        balance.frozen = json["frozen"].stringValue
        return balance
    }

    func parseCandlestick(_ json: JSON) -> Candlestick {
        let candlestick = Candlestick()
        // TODO
        //candlestick.closeTime = json.arrayValue[0].stringValue
        candlestick.close = json.arrayValue[0].intValue
        candlestick.high = json.arrayValue[2].stringValue
        candlestick.low = json.arrayValue[3].stringValue
        candlestick.numberOfTrades = json.arrayValue[4].stringValue
        candlestick.open = json.arrayValue[5].stringValue
        // TODO
        //candlestick.openTime = json.arrayValue[6].intValue
        candlestick.quoteAssetVolume = json.arrayValue[7].stringValue
        candlestick.volume = json.arrayValue[8].intValue
        return candlestick
    }

    func parseTickerStatistics(_ json: JSON) -> TickerStatistics {
        let ticker = TickerStatistics()
        ticker.askPrice = json["askPrice"].stringValue
        ticker.askQuantity = json["askQuantity"].stringValue
        ticker.bidPrice = json["bidPrice"].stringValue
        ticker.bidQuantity = json["bidQuantity"].stringValue
        // TODO
        //ticker.closeTime = TimeInterval = 0
        ticker.count = json["count"].intValue
        ticker.firstId = json["firstId"].stringValue
        ticker.highPrice = json["high_price"].stringValue
        ticker.lastId = json["lastId"].stringValue
        ticker.lastPrice = json["lastPrice"].stringValue
        ticker.lastQuantity = json["lastQuantity"].stringValue
        ticker.lowPrice = json["lowPrice"].stringValue
        ticker.openPrice = json["openTime"].stringValue
        //TODO
        //ticker.openTime = TimeInterval = 0
        ticker.prevClosePrice = json["prevClosePrice"].stringValue
        ticker.priceChange = json["priceChange"].stringValue
        ticker.priceChangePercent = json["priceChangePercent"].stringValue
        ticker.quoteVolume = json["quoteVolume"].stringValue
        ticker.symbol = json["symbol"].stringValue
        ticker.volume = json["volume"].stringValue
        ticker.weightedAvgPrice = json["weightedAvgPrice"].stringValue
        return ticker
    }
    
    func parseOrder(_ json: JSON) -> Order {
        let order = Order()
        order.cumulateQuantity = json["cumulateQuantity"].stringValue
        order.fee = json["fee"].stringValue
        order.lastExecutedPrice = json["lastExecutedPrice"].stringValue
        order.lastExecuteQuantity = json["lastExecutedQuantity"].stringValue
        // TODO
        //order.orderCreateTime: Date = Date()
        order.orderId = json["orderId"].stringValue
        order.owner = json["owner"].stringValue
        order.price = json["price"].stringValue
        order.status = json["status"].stringValue
        order.symbol = json["symbol"].stringValue
        order.timeInForce = json["timeInForce"].intValue
        order.tradeId = json["tradeId"].stringValue
        order.transactionHash = json["transactionHash"].stringValue
        // TODO
        //order.transactionTime: Date = Date()
        order.type = json["type"].intValue
        return order
    }
    
    func parseOrderList(_ json: JSON) -> OrderList {
        let orderList = OrderList()
        orderList.total = json["total"].intValue
        orderList.orders = json["order"].map({ self.parseOrder($0.1) })
        return orderList
    }
    
    func parseFee(_ json: JSON) -> Fee {
        let fee = Fee()
        fee.msgType = json["msg_type"].stringValue
        fee.fee = json["fee"].intValue
        fee.feeFor = json["fee_for"].intValue
        fee.multiTransferFee = json["multi_transfer_fee"].stringValue
        fee.lowerLimitAsMulti = json["lower_limit_as_multi"].stringValue
        if json["fixed_fee_params"].exists() {
            fee.fixedFeeParams = self.parseFixedFeeParams(json["fixed_fee_params"])
        }
        return fee
    }
    
    func parseFixedFeeParams(_ json: JSON) -> FixedFeeParams {
        let fixedFeeParams = FixedFeeParams()
        fixedFeeParams.msgType = json["msg_type"].stringValue
        fixedFeeParams.fee = json["fee"].intValue
        fixedFeeParams.feeFor = json["fee_for"].intValue
        return fixedFeeParams
    }
    
}

class TokenParser: Parser {
    override func parse(_ json: JSON, response: BinanceChain.Response) {
        response.tokens = json.map({ self.parseToken($0.1) })
    }
}

class PeerParser: Parser {
    override func parse(_ json: JSON, response: BinanceChain.Response) {
        response.peers = json.map({ self.parsePeer($0.1) })
    }
}

class TradeParser: Parser {
    override func parse(_ json: JSON, response: BinanceChain.Response) {
        response.trades = json["trade"].map({ self.parseTrade($0.1) })
    }
}

class MarketDepthParser: Parser {
    override func parse(_ json: JSON, response: BinanceChain.Response) {
        response.marketDepth = self.parseMarketDepth(json)
    }
}

class TimesParser: Parser {
    override func parse(_ json: JSON, response: BinanceChain.Response) {
        response.times = self.parseTimes(json)
    }
}

class ValidatorsParser: Parser {
    override func parse(_ json: JSON, response: BinanceChain.Response) {
        response.validators = self.parseValidators(json)
    }
}

class TransactionsParser: Parser {
    override func parse(_ json: JSON, response: BinanceChain.Response) {
        response.transactions = self.parseTransactions(json)
    }
}

class NodeInfoParser: Parser {
    override func parse(_ json: JSON, response: BinanceChain.Response) {
        response.nodeInfo = self.parseNodeInfo(json["node_info"])
    }
}

class MarketsParser: Parser {
    override func parse(_ json: JSON, response: BinanceChain.Response) {
        response.markets = json.map({ self.parseMarket($0.1) })
    }
}

class AccountParser: Parser {
    override func parse(_ json: JSON, response: BinanceChain.Response) {
        response.account = self.parseAccount(json)
    }
}

class SequenceParser: Parser {
    override func parse(_ json: JSON, response: BinanceChain.Response) {
        response.sequence = json["sequence"].intValue
    }
}

class TxParser: Parser {
    override func parse(_ json: JSON, response: BinanceChain.Response) {
        response.tx = self.parseTx(json)
    }
}

class CandlestickParser: Parser {
    override func parse(_ json: JSON, response: BinanceChain.Response) {
        response.candlesticks = json.map({ self.parseCandlestick($0.1) })
    }
}

class TickerStatisticsParser: Parser {
    override func parse(_ json: JSON, response: BinanceChain.Response) {
        response.tickerStatistics = json.map({ self.parseTickerStatistics($0.1) })
    }
}

class OrderParser: Parser {
    override func parse(_ json: JSON, response: BinanceChain.Response) {
        response.order = self.parseOrder(json)
    }
}

class OrderListParser: Parser {
    override func parse(_ json: JSON, response: BinanceChain.Response) {
        response.orderList = self.parseOrderList(json)
    }
}

class FeesParser: Parser {
    override func parse(_ json: JSON, response: BinanceChain.Response) {
        response.fees = json.map({ self.parseFee($0.1) })
    }
}