package com.brightwell.readyremit.androisample.network.model

import com.squareup.moshi.Json
import com.squareup.moshi.JsonClass

@JsonClass(generateAdapter = true)
data class TransferResponse(
    @Json(name = "transferId") var transferId: String
)