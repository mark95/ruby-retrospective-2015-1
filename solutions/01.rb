def convert_to_bgn(price, currency)
  currencies = { bgn: 1, usd: 1.7408, eur: 1.9557, gbp: 2.6415 }
  currencies[currency] * price.round(2)
end

def compare_prices(price1, currency1, price2, currency2)
  value1 = convert_to_bgn(price1, currency1)
  value2 = convert_to_bgn(price2, currency2)
  value1 <=> value2
end
