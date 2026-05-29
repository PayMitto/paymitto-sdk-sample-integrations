package com.brightwell.readyremit.androisample.network.model

import com.squareup.moshi.Json
import com.squareup.moshi.JsonClass

@JsonClass(generateAdapter = true)
data class AuthRequest(
    @Json(name = "client_id") var clientId: String,
    @Json(name = "client_secret") var clientSecret: String,
    @Json(name = "sender_id") var senderId: String,
    @Json(name = "audience") val audience: String = "https://sandbox-api.readyremit.com",
    @Json(name = "grant_type") val grantType: String = "client_credentials"
)
