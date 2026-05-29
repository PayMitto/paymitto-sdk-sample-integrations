package com.brightwell.composeSampleApp.network.model

import com.squareup.moshi.Json
import com.squareup.moshi.JsonClass

@JsonClass(generateAdapter = true)
data class AuthResponse(
    @Json(name = "access_token") val token: String,
    @Json(name = "expires_in") val expiresIn: Int,
    @Json(name = "scope") val scope: String,
    @Json(name = "token_type") val tokenType: String
)
