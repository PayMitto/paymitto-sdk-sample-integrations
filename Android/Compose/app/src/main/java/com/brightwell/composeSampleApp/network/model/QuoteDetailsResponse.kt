package com.brightwell.composeSampleApp.network.model

import com.squareup.moshi.JsonClass

@JsonClass(generateAdapter = true)
data class ReadQuoteDetailsResponse(
    val destinationCountryISO3Code: String,
    val destinationCurrencyISO3Code: String,
    val sendAmount: SendAmount,
    val sourceCurrencyIso3Code: String,
    val transferMethod: String
) {
    @JsonClass(generateAdapter = true)
    data class SendAmount(
        val value: Int
    )
}
