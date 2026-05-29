package com.brightwell.composeSampleApp

import android.os.Bundle
import androidx.activity.ComponentActivity
import androidx.activity.compose.setContent
import androidx.activity.enableEdgeToEdge
import androidx.activity.viewModels
import androidx.compose.foundation.background
import androidx.compose.foundation.layout.Arrangement
import androidx.compose.foundation.layout.Column
import androidx.compose.foundation.layout.fillMaxSize
import androidx.compose.foundation.layout.padding
import androidx.compose.material3.Button
import androidx.compose.material3.Scaffold
import androidx.compose.material3.Text
import androidx.compose.runtime.Composable
import androidx.compose.runtime.getValue
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import androidx.compose.ui.graphics.Color
import androidx.compose.ui.platform.LocalContext
import androidx.compose.ui.tooling.preview.Preview
import androidx.compose.ui.unit.dp
import androidx.lifecycle.compose.collectAsStateWithLifecycle
import com.brightwell.composeSampleApp.ui.theme.ComposeSampleAppTheme
import com.brightwell.composeSampleApp.util.getActivity
import com.brightwell.readyremit.sdk.AccessTokenDetails
import com.brightwell.readyremit.sdk.AuthenticationResult
import com.brightwell.readyremit.sdk.ReadyRemit
import com.brightwell.readyremit.sdk.ReadyRemitConfiguration
import com.brightwell.readyremit.sdk.TransferSubmissionResult

internal class MainActivity : ComponentActivity() {

    private val viewModel: MainViewModel by viewModels()

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        enableEdgeToEdge()
        setContent {
            ComposeSampleAppTheme {
                Scaffold(modifier = Modifier.fillMaxSize()) { innerPadding ->
                    MainView(
                        modifier = Modifier.padding(innerPadding),
                        viewModel = viewModel
                    )
                }
            }
        }
    }

}

@Composable
internal fun MainView(
    modifier: Modifier = Modifier,
    viewModel: MainViewModel
) {
    val state by viewModel.state.collectAsStateWithLifecycle()
    HomeView(modifier, state)
}

@Composable
internal fun HomeView(
    modifier: Modifier = Modifier,
    state: MainState
) {
    val activity = LocalContext.current.getActivity()

    Column(
        modifier = modifier.then(
            Modifier
                .background(Color.White)
                .fillMaxSize()
        ),
        verticalArrangement = Arrangement.Center,
        horizontalAlignment = Alignment.CenterHorizontally
    ) {
        Button(
            modifier = Modifier.padding(16.dp), onClick = {
                if (activity != null) {
                    ReadyRemit.startSdk(
                        activity = activity,
                        readyRemitConfiguration = state.config
                    )
                }
            }
        ) {
            Text("Start ReadyRemitSDK")
        }
    }
}

@Preview(showBackground = true)
@Composable
internal fun HomePreview() {
    ComposeSampleAppTheme {
        HomeView(
            modifier = Modifier,
            state = MainState(
                config = ReadyRemitConfiguration(
                    authenticateIntoTheSdk = {
                        AuthenticationResult.Success(
                            AccessTokenDetails(
                                accessToken = "",
                                expiresIn = 10000,
                                scope = "",
                                tokenType = ""
                            )
                        )
                    },
                    submitTransfer = {
                        TransferSubmissionResult.Success(
                            transferId = ""
                        )
                    }
                )
            )
        )
    }
}