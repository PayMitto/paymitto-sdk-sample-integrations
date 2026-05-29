import React, {useState} from 'react';
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
  ReadyRemitEnvironment,
  ReadyRemitSupportedAppearance,
  ReadyRemitLocalization,
  type ReadyRemitConfiguration,
  type ReadyRemitTokenResponse,
  type ReadyRemitTransferRequest,
  type ReadyRemitError,
} from 'react-native-ready-remit-sdk';

const SENDER_ID = '<SENDER_ID>';
const CLIENT_ID = '<CLIENT_ID>';
const CLIENT_SECRET = '<CLIENT_SECRET>';

const AUTH_URL = 'https://sandbox-api.readyremit.com/v1/oauth/token';
const AUTH_AUDIENCE = 'https://sandbox-api.readyremit.com';

const sdkConfiguration: ReadyRemitConfiguration = {
  environment: ReadyRemitEnvironment.Sandbox,
  supportedAppearance: ReadyRemitSupportedAppearance.Device,
  localization: ReadyRemitLocalization.EN_US,
  appearance: {
    foundations: {
      colorPrimary: {light: '#2563EB', dark: '#558CF4'},
      colorBackground: {light: '#F3F4F6', dark: '#111111'},
      colorForeground: {light: '#FFFFFF', dark: '#1F1F1F'},
      colorTextPrimary: {light: '#0E0F0C', dark: '#E3E3E3'},
      colorTextSecondary: {light: '#454545', dark: '#B0B0B0'},
      colorDivider: {light: '#E2E2E2', dark: '#313131'},
      colorDanger: {light: '#AA220F', dark: '#AA220F'},
      colorSuccess: {light: '#008761', dark: '#008761'},
    },
    components: {
      button: {
        buttonPrimaryBackgroundColor: {light: '#2563EB', dark: '#558CF4'},
        buttonPrimaryTextColor: {light: '#FFFFFF', dark: '#FFFFFF'},
        buttonRadius: 8,
      },
    },
  },
};

async function fetchAccessTokenDetails(): Promise<
  ReadyRemitTokenResponse | ReadyRemitError
> {
  try {
    const response = await fetch(AUTH_URL, {
      method: 'POST',
      headers: {'Content-Type': 'application/json'},
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
      message: error instanceof Error ? error.message : 'Network request failed',
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
        request: ReadyRemitTransferRequest,
      ) => {
        // Replace with your real transfer submission endpoint
        Alert.alert('Transfer Request', JSON.stringify(request, null, 2));
        return {transferId: `sample-${Date.now()}`};
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
        <Text style={styles.title}>ReadyRemit SDK</Text>
        <Text style={styles.subtitle}>React Native Example</Text>
        <Text style={styles.status}>{sdkStatus}</Text>
        <View style={styles.buttonContainer}>
          <Button title="Launch ReadyRemit SDK" onPress={handleStartSDK} />
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
