import React, { useState } from 'react';
import {
  Alert,
  Button,
  SafeAreaView,
  StyleSheet,
  Text,
  View,
} from 'react-native';
import {
  startSDK,
  PayMittoEnvironment,
  PayMittoSupportedAppearance,
  PayMittoLocalization,
  type PayMittoConfiguration,
  type PayMittoTokenResponse,
  type PayMittoTransferRequest,
  type PayMittoError,
} from 'react-native-paymitto-sdk';

// SECURITY NOTE
// --------------
// This sample fetches the OAuth access token directly from the device using
// CLIENT_SECRET, to keep the demo self-contained and easy to run. This is NOT
// the pattern production apps should follow — shipping a client_secret in a
// mobile bundle exposes it to anyone who inspects the binary or network traffic.
//
// In production, your mobile app should call YOUR backend, which performs the
// OAuth client_credentials exchange against PayMitto and returns only the
// access_token to the device. Keep CLIENT_SECRET on the server side only.
const SENDER_ID = '<SENDER_ID>';
const CLIENT_ID = '<CLIENT_ID>';
const CLIENT_SECRET = '<CLIENT_SECRET>';

const AUTH_URL = 'https://sandbox-api.readyremit.com/v1/oauth/token';
const AUTH_AUDIENCE = 'https://sandbox-api.readyremit.com';

const sdkConfiguration: PayMittoConfiguration = {
  environment: PayMittoEnvironment.Sandbox,
  supportedAppearance: PayMittoSupportedAppearance.Device,
  localization: PayMittoLocalization.EN_US,
  appearance: {
    foundations: {
      colorPrimary: { light: '#4451F6', dark: '#7B86FF' },
      colorTextPrimary: { light: '#120F0D', dark: '#F5F3F0' },
      colorTextSecondary: { light: '#63615E', dark: '#9A968F' },
      colorTextLink: { light: '#F45858', dark: '#F87474' },
      colorForeground: { light: '#FEFDFC', dark: '#1C1B1A' },
      colorBackground: { light: '#F8F6F3', dark: '#121110' },
      colorDivider: { light: '#E7E5E2', dark: '#2A2927' },
      colorSuccess: { light: '#008761', dark: '#3DBA92' },
      colorWarning: { light: '#F5B900', dark: '#FFCB33' },
      colorDanger: { light: '#AA220F', dark: '#E5614F' },
    },
    components: {
      button: {
        buttonPrimaryBackgroundColor: { light: '#1F1093', dark: '#5C68FF' },
        buttonPrimaryTextColor: { light: '#FEFDFC', dark: '#FEFDFC' },
        buttonSecondaryBorderColor: { light: '#F45858', dark: '#F87474' },
        buttonSecondaryTextColor: { light: '#F45858', dark: '#F87474' },
        buttonRadius: 8,
      },
      inputFields: {
        inputBorderColor: { light: '#BFBDBA', dark: '#3A3937' },
        inputBackgroundColor: { light: '#FEFDFC', dark: '#1C1B1A' },
        inputRadius: 8,
      },
      loading: {
        loadingBackgroundColor: { light: '#1F1093', dark: '#5C68FF' },
        loadingTextColor: { light: '#FFFFFF', dark: '#FEFDFC' },
        loadingSpinnerColor: { light: '#4451F6', dark: '#7B86FF' },
      },
    },
  },
};

async function fetchAccessTokenDetails(): Promise<
  PayMittoTokenResponse | PayMittoError
> {
  try {
    const response = await fetch(AUTH_URL, {
      method: 'POST',
      headers: { 'Content-Type': 'application/json' },
      body: JSON.stringify({
        grant_type: 'client_credentials',
        sender_id: SENDER_ID,
        audience: AUTH_AUDIENCE,
        client_id: CLIENT_ID,
        client_secret: CLIENT_SECRET,
      }),
    });

    const json = await response.json();

    if (!response.ok || !json.access_token) {
      return {
        code: 'AUTH_FAILED',
        message: json.description ?? json.message ?? 'Authentication failed',
      };
    }

    return {
      accessToken: json.access_token,
      tokenType: json.token_type ?? 'Bearer',
      expiresIn: json.expires_in ?? 3600,
      scope: json.scope ?? 'openid',
    };
  } catch (error) {
    return {
      code: 'NETWORK_ERROR',
      message:
        error instanceof Error ? error.message : 'Network request failed',
    };
  }
}

export default function App() {
  const [sdkStatus, setSdkStatus] = useState<string>('Ready');

  const handleStartSDK = () => {
    setSdkStatus('Loading...');

    startSDK({
      configuration: sdkConfiguration,
      fetchAccessTokenDetails,
      verifyFundsAndCreateTransfer: async (
        request: PayMittoTransferRequest,
      ) => {
        Alert.alert('Transfer Request', JSON.stringify(request, null, 2));
        return { transferId: `sample-${Date.now()}` };
      },
      onLoad: async () => {
        setSdkStatus('SDK Open');
      },
      onClose: async () => {
        setSdkStatus('Ready');
      },
    });
  };

  return (
    <SafeAreaView style={styles.container}>
      <View style={styles.content}>
        <Text style={styles.title}>PayMitto SDK</Text>
        <Text style={styles.subtitle}>Expo Sample</Text>
        <Text style={styles.status}>{sdkStatus}</Text>
        <View style={styles.buttonContainer}>
          <Button title="Launch PayMitto SDK" onPress={handleStartSDK} />
        </View>
      </View>
    </SafeAreaView>
  );
}

const styles = StyleSheet.create({
  container: {
    flex: 1,
    backgroundColor: '#F5F5F5',
  },
  content: {
    flex: 1,
    alignItems: 'center',
    justifyContent: 'center',
    paddingHorizontal: 24,
  },
  title: {
    fontSize: 28,
    fontWeight: '700',
    color: '#1A1A1A',
    marginBottom: 4,
  },
  subtitle: {
    fontSize: 16,
    color: '#666',
    marginBottom: 24,
  },
  status: {
    fontSize: 14,
    color: '#999',
    marginBottom: 32,
  },
  buttonContainer: {
    width: '100%',
    maxWidth: 300,
  },
});
