package com.brightwell.readyremit.androisample.ui

import androidx.lifecycle.LiveData
import androidx.lifecycle.MutableLiveData
import androidx.lifecycle.ViewModel
import androidx.lifecycle.viewModelScope
import com.brightwell.readyremit.androisample.network.ReadyRemitService
import com.brightwell.readyremit.androisample.network.model.AuthRequest
import com.brightwell.readyremit.sdk.ReadyRemitAuth
import com.brightwell.readyremit.sdk.ReadyRemitAuthCallback
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.launch
import kotlinx.coroutines.runBlocking
import kotlinx.coroutines.withContext
import okhttp3.OkHttpClient
import okhttp3.logging.HttpLoggingInterceptor
import retrofit2.Retrofit
import retrofit2.converter.moshi.MoshiConverterFactory

class MainViewModel: ViewModel() {

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

    private val _auth = MutableLiveData<ReadyRemitAuth>()
    val auth: LiveData<ReadyRemitAuth>
        get() = _auth

    private val _error = MutableLiveData<String>()
    val error: LiveData<String>
        get() = _error

    fun doAuth(
        clientId: String,
        clientSecret: String,
        senderId: String,
        callback: ReadyRemitAuthCallback
    ) {
        val request = AuthRequest(clientId, clientSecret, senderId)
        viewModelScope.launch {
            try {
                val token = service.auth(request).token
                withContext(Dispatchers.Main) {
                    _auth.value = ReadyRemitAuth(token, token)
                    callback.onAuthSucceeded(ReadyRemitAuth(token, token))
                }
            } catch (e: Exception) {
                withContext(Dispatchers.Main) {
                    _error.value = e.message
                    callback.onAuthFailed()
                }
            }
        }
    }
}