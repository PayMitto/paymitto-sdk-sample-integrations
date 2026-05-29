package com.paymitto.composeSampleApp.network.model

import com.squareup.moshi.JsonClass

@JsonClass(generateAdapter = true)
data class ErrorResponse(
    val code: String = "",
    val message: String = "",
    val description: String = ""
)