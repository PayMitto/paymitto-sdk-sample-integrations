package com.brightwell.readyremit.androisample.network

import com.brightwell.readyremit.androisample.network.model.AuthRequest
import com.brightwell.readyremit.androisample.network.model.AuthResponse
import retrofit2.Response
import retrofit2.http.Body
import retrofit2.http.Headers
import retrofit2.http.POST

interface ReadyRemitService {

    @POST("/v1/oauth/token")
    @Headers("Content-Type: application/json")
    suspend fun auth(@Body authRequest: AuthRequest): AuthResponse

}