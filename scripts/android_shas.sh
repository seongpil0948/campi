# cd android && ./gradlew signingReport
# # Debug
# keytool -list -v -keystore ~/.android/debug.keystore -alias androiddebugkey -storepass android -keypass android
# Relase
keytool -list -v -keystore ../campi-secret/keystore.jks  -alias campi-keystore -storepass 'campi123!)' -keypass 'campi123!)'