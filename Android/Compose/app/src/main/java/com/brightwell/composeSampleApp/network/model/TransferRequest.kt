package com.brightwell.composeSampleApp.network.model

import com.squareup.moshi.JsonClass

@JsonClass(generateAdapter = true)
data class TransferRequest(
    // properties from ReadyRemitTransferRequest
    val fields: List<Field>?,
    val quoteBy: String,
    val quoteHistoryId: String,
    val recipientAccountId: String?,
    val recipientId: String,
    val sourceAccountId: String? = null,
    val nonce: String,

    // properties from GET /quote/{quoteHistoryId}
    val amount: Int,
    val dstCountryIso3Code: String,
    val dstCurrencyIso3Code: String,
    val srcCurrencyIso3Code: String,
    val transferMethod: String
) {
    @JsonClass(generateAdapter = true)
    data class Field(
        val id: String,
        val type: String,
        val value: String
    )
}
