package com.brightwell.composeSampleApp.network

import com.brightwell.composeSampleApp.network.model.AuthRequest
import com.brightwell.composeSampleApp.network.model.AuthResponse
import com.brightwell.composeSampleApp.network.model.ReadQuoteDetailsResponse
import com.brightwell.composeSampleApp.network.model.TransferRequest
import com.brightwell.readyremit.androisample.network.model.TransferResponse
import retrofit2.Response
import retrofit2.http.Body
import retrofit2.http.GET
import retrofit2.http.Header
import retrofit2.http.Headers
import retrofit2.http.POST
import retrofit2.http.Url

interface ReadyRemitService {

    @POST("/v1/oauth/token")
    @Headers("Content-Type: application/json")
    suspend fun auth(@Body authRequest: AuthRequest): AuthResponse

    @POST("v1/transfers")
    @Headers(
        "Content-Type: application/json",
        "ACCEPT-LANGUAGE: en_US"
    )
    suspend fun transfer(
        @Header("Authorization") token: String,
        @Body transferRequest: TransferRequest
    ): Response<TransferResponse>

    @GET
    suspend fun readQuoteDetails(
        @Url url: String,
        @Header("authorization") token: String,
        @Header("accept-language") acceptLanguage: String,
        @Header("content-type") contentType: String
    ): Response<ReadQuoteDetailsResponse>

}