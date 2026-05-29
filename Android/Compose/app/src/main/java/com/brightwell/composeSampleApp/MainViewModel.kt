package com.brightwell.composeSampleApp

import android.util.Log
import androidx.lifecycle.ViewModel
import androidx.lifecycle.viewModelScope
import com.brightwell.composeSampleApp.network.ReadyRemitService
import com.brightwell.composeSampleApp.network.model.AuthRequest
import com.brightwell.composeSampleApp.network.model.ReadQuoteDetailsResponse
import com.brightwell.composeSampleApp.network.model.TransferRequest
import com.brightwell.readyremit.androisample.network.model.ErrorResponse
import com.paymitto.android.sdk.AccessTokenDetails
import com.paymitto.android.sdk.AuthenticationResult
import com.paymitto.android.sdk.Localization
import com.paymitto.android.sdk.PayMitto
import com.paymitto.android.sdk.PayMittoConfiguration
import com.paymitto.android.sdk.PayMittoEnvironment
import com.paymitto.android.sdk.PayMittoError
import com.paymitto.android.sdk.PayMittoEvent
import com.paymitto.android.sdk.PayMittoTransferRequest
import com.paymitto.android.sdk.SDKClosed
import com.paymitto.android.sdk.SDKLaunched
import com.paymitto.android.sdk.SourceAccount
import com.paymitto.android.sdk.SupportedAppearance
import com.paymitto.android.sdk.TransferSubmissionResult
import com.squareup.moshi.Moshi
import com.squareup.moshi.Types.newParameterizedType
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.flow.MutableStateFlow
import kotlinx.coroutines.flow.StateFlow
import kotlinx.coroutines.launch
import kotlinx.coroutines.withContext
import okhttp3.OkHttpClient
import okhttp3.logging.HttpLoggingInterceptor
import retrofit2.Retrofit
import retrofit2.converter.moshi.MoshiConverterFactory
import java.math.BigDecimal

class MainViewModel : ViewModel() {

    private val _state = MutableStateFlow(MainState(createSdkConfig()))
    val state: StateFlow<MainState> = _state

    private var tokenValue: String = ""

    private val service: ReadyRemitService by lazy {
        Retrofit.Builder().baseUrl("https://sandbox-api.readyremit.com")
            .client(
                OkHttpClient.Builder()
                    .addInterceptor(HttpLoggingInterceptor().apply {
                        level = HttpLoggingInterceptor.Level.BODY
                    })
                    .build()
            )
            .addConverterFactory(MoshiConverterFactory.create())
            .build().create(ReadyRemitService::class.java)
    }

    fun createSdkConfig(): PayMittoConfiguration {
        return PayMittoConfiguration(
            defaultCountry = null, // CountryIso3Code.USA
            environment = PayMittoEnvironment.SANDBOX,
            fixedRemittanceServiceProvider = null, // RemittanceServiceProvider.VISA
            fixedTransferMethod = null, // allows any transfer method
            localization = Localization.enUS,
            sourceAccounts = listOf(
                SourceAccount(
                    alias = "Account 1",
                    balance = BigDecimal("8909.99"),
                    last4 = "5590",
                    sourceProviderId = "asd12-asc123-vdsf3"
                )
            ),
            idleTimeoutInterval = 3 * 60, // measured in seconds
            appearance = "", // pass JSON value for appearance
            supportedAppearance = SupportedAppearance.Device, // adapts to light or dark mode
            authenticateIntoTheSdk = {
                withContext(Dispatchers.IO) {
                    try {
                        val senderId = "< your sender id >"
                        val clientId = "<your client id>"
                        val clientSecret = "<your client secret>"
                        val request = AuthRequest(
                            clientId = clientId,
                            clientSecret = clientSecret,
                            senderId = senderId
                        )
                        val authResponse = service.auth(request)
                        tokenValue = authResponse.token
                        withContext(Dispatchers.Main) {
                            AuthenticationResult.Success(
                                AccessTokenDetails(
                                    accessToken = authResponse.token,
                                    expiresIn = authResponse.expiresIn,
                                    scope = authResponse.scope,
                                    tokenType = authResponse.tokenType
                                )
                            )
                        }
                    } catch (e: Exception) {
                        withContext(Dispatchers.Main) {
                            AuthenticationResult.Error(
                                PayMittoError(
                                    code = "",
                                    message = e.message.orEmpty(),
                                    description = e.message.orEmpty()
                                )
                            )
                        }
                    }
                }
            },
            submitTransfer = { transferRequest ->
                try {
                    val quoteDetails = readQuoteDetails(transferRequest.quoteHistoryId)
                    return@PayMittoConfiguration submitReadyRemitTransfer(
                        transferRequest = transferRequest,
                        quoteDetails = quoteDetails
                    )
                } catch (e: QuoteDetailsException) {
                    return@PayMittoConfiguration TransferSubmissionResult.Error(e.error)
                }
            },
            sdkEventListener = { event: PayMittoEvent ->
                viewModelScope.launch {
                    when (event) {
                        SDKLaunched -> {
                            // do something
                        }

                        SDKClosed -> {
                            // do something
                        }
                    }
                }
            }
        )
    }

    private suspend fun readQuoteDetails(
        quoteHistoryId: String
    ): ReadQuoteDetailsResponse {
        val response = service.readQuoteDetails(
            url = "https://sandbox-api.readyremit.com/v1/quote/$quoteHistoryId",
            token = "Bearer $tokenValue",
            acceptLanguage = PayMitto.getSdkLanguageLocale()?.getLocalizationForApi()
                ?: Localization.enUS.getLocalizationForApi(), // or the language you set in ReadyRemitConfiguration
            contentType = "application/json"
        )

        if (response.isSuccessful) {
            return response.body()!!
        } else {
            // Parsing json error response
            val errorResponse = mapError(response.errorBody()?.string())

            throw QuoteDetailsException(
                PayMittoError(
                    errorResponse.code,
                    errorResponse.message,
                    errorResponse.description
                )
            )
        }
    }

    private suspend fun submitReadyRemitTransfer(
        transferRequest: PayMittoTransferRequest,
        quoteDetails: ReadQuoteDetailsResponse
    ): TransferSubmissionResult {
        val response = service.transfer(
            token = "Bearer $tokenValue",
            transferRequest = TransferRequest(
                transferRequest.fields?.map { TransferRequest.Field(it.id, it.type, it.value) },
                transferRequest.quoteBy,
                transferRequest.quoteHistoryId,
                transferRequest.recipientAccountId,
                transferRequest.recipientId,
                transferRequest.sourceAccountId,
                transferRequest.nonce,
                quoteDetails.sendAmount.value,
                quoteDetails.destinationCountryISO3Code,
                quoteDetails.destinationCurrencyISO3Code,
                quoteDetails.sourceCurrencyIso3Code,
                quoteDetails.transferMethod
            )
        )
        if (response.isSuccessful) {
            return TransferSubmissionResult.Success(response.body()!!.transferId)
        } else {
            // Parsing json error response
            val errorResponse = mapError(response.errorBody()?.string())
            return TransferSubmissionResult.Error(
                PayMittoError(
                    errorResponse.code,
                    errorResponse.message,
                    errorResponse.description
                )
            )
        }
    }

    fun mapError(response: String?): ErrorResponse {
        return response?.let {
            val moshi: Moshi = Moshi.Builder().build()
            val listType = newParameterizedType(List::class.java, ErrorResponse::class.java)
            val listAdapter = moshi.adapter<List<ErrorResponse>>(listType)
            val objectAdapter = moshi.adapter(ErrorResponse::class.java)
            listAdapter.fromJson(it)?.firstOrNull() ?: objectAdapter.fromJson(it) ?: ErrorResponse()
        } ?: ErrorResponse()
    }

}

data class QuoteDetailsException(
    val error: PayMittoError
) : Throwable("Failed to read quote details: ${error.message}")