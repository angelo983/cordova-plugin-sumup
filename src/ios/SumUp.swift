import SumUpSDK;

@objc(SumUp) class SumUp : CDVPlugin {
    private let SUCCESS: Int = 1;

    private let LOGIN_ERROR: Int = 100;
    private let LOGIN_CANCELED: Int = 101;
    private let CHECK_FOR_LOGIN_STATUS_FAILED: Int = 102;
    private let LOGOUT_FAILED: Int = 103;
    private let FAILED_CLOSE_CARD_READER_CONN: Int = 104;
    private let CARDREADER_INSTANCE_NOT_DEFINED: Int = 105;
    private let STOP_CARD_READER_ERROR: Int = 106;
    private let SHOW_SETTINGS_FAILED: Int = 107;
    private let SETTINGS_DONE: Int = 108;
    private let PREPARE_PAYMENT_ERROR: Int = 109;
    private let CARDREADER_NOT_READY_TO_TRANSMIT: Int = 110;
    private let ERROR_PREPARING_CHECKOUT: Int = 111;
    private let AUTH_ERROR: Int = 112;
    private let NO_ACCESS_TOKEN: Int = 113;
    private let AUTH_SUCCESSFUL: Int = 114;
    private let CANT_PARSE_AMOUNT: Int = 115;
    private let CANT_PARSE_CURRENCY: Int = 116;
    private let PAYMENT_ERROR: Int = 117;

    @objc(login:)
    func login(command: CDVInvokedUrlCommand) {
        let affiliate_key = getAffiliateKey(); print(affiliate_key);

        // Access token provided
        if((command.arguments != nil) && command.arguments.count > 0) {
            var accessToken = command.arguments[0]; print(accessToken);

            SumUpSDK.login(withToken: accessToken as! String){ (success: Bool, error: Error?) in
                if(success) {
                    let obj = self.createReturnObject(code: self.SUCCESS, message: "User sucessfully logged in");
                    self.returnCordovaPluginResult(status: CDVCommandStatus_OK, obj: obj, command: command);
                }

                guard error == nil else {
                    let obj = self.createReturnObject(code: self.LOGIN_ERROR, message: error!.localizedDescription);
                    self.returnCordovaPluginResult(status: CDVCommandStatus_ERROR, obj: obj, command: command);
                    return
                }
            }
        } else {
            SumUpSDK.presentLogin(from: self.viewController, animated: true) { (success: Bool, error: Error?) in
                if(success) {
                    let obj = self.createReturnObject(code: self.SUCCESS, message: "User sucessfully logged in");
                    self.returnCordovaPluginResult(status: CDVCommandStatus_OK, obj: obj, command: command);
                }

                guard error == nil else {
                    let obj = self.createReturnObject(code: self.LOGIN_ERROR, message: error!.localizedDescription);
                    self.returnCordovaPluginResult(status: CDVCommandStatus_OK, obj: obj, command: command);
                    return
                }
            }
        }
    }

    @objc(auth:)
    func auth(command: CDVInvokedUrlCommand) {
        let obj = createReturnObject(code: 112, message: "Authenticate is not available on iOS");
        returnCordovaPluginResult(status: CDVCommandStatus_OK, obj: obj, command: command);
    }

    @objc(getSettings:)
    func getSettings(command: CDVInvokedUrlCommand) {
        SumUpSDK.presentCheckoutPreferences(from: self.viewController, animated: true) { (success: Bool, error: Error?) in
            if(success) {
                let obj = self.createReturnObject(code: self.SUCCESS, message: "Settings shown");
                self.returnCordovaPluginResult(status: CDVCommandStatus_OK, obj: obj, command: command);
            }

            guard error == nil else {
                let obj = self.createReturnObject(code: self.SHOW_SETTINGS_FAILED, message: error!.localizedDescription);
                self.returnCordovaPluginResult(status: CDVCommandStatus_ERROR, obj: obj, command: command);
                return
            }
        }
    }

    @objc(logout:)
    func logout(command: CDVInvokedUrlCommand) {
        SumUpSDK.logout { (success: Bool, error: Error?) in
            if(success){
                let obj = self.createReturnObject(code: self.SUCCESS, message: "Logout successful");
                self.returnCordovaPluginResult(status: CDVCommandStatus_OK, obj: obj, command: command);
            }

            guard error == nil else {
                let obj = self.createReturnObject(code: self.LOGOUT_FAILED, message: error!.localizedDescription);
                self.returnCordovaPluginResult(status: CDVCommandStatus_ERROR, obj: obj, command: command);
                return
            }
        }

        let obj = createReturnObject(code: 103, message: "Logout method will be implemented soon");
        returnCordovaPluginResult(status: CDVCommandStatus_OK, obj: obj, command: command);
    }

    @objc(isLoggedIn:)
    func isLoggedIn(command: CDVInvokedUrlCommand) {
        let loggedIn: Bool = SumUpSDK.isLoggedIn;
        let obj: [AnyHashable : Any] = ["code" : SUCCESS, "isLoggedIn": loggedIn];
        returnCordovaPluginResult(status: CDVCommandStatus_OK, obj: obj, command: command);
    }

    @objc(prepare:)
    func prepare(command: CDVInvokedUrlCommand) {
        SumUpSDK.prepareForCheckout();
        let obj = createReturnObject(code: SUCCESS, message: "SumUp checkout prepared successfully");
        returnCordovaPluginResult(status: CDVCommandStatus_OK, obj: obj, command: command);
    }

    @objc(closeConnection:)
    func closeConnection(command: CDVInvokedUrlCommand) {
        let obj = createReturnObject(code: 104, message: "Close connection is not available on iOS");
        returnCordovaPluginResult(status: CDVCommandStatus_OK, obj: obj, command: command);
    }

    @objc(pay:)
    func pay(command: CDVInvokedUrlCommand) {
        let obj = createReturnObject(code: 117, message: "Pay method will be implemented soon");
        returnCordovaPluginResult(status: CDVCommandStatus_OK, obj: obj, command: command);
    }

    // returns the affiliate key, which is provided in package.json
    private func getAffiliateKey() -> String {
        return (Bundle.main.infoDictionary?["SUMUP_API_KEY"] as? String)!;
    }

    private func createReturnObject(code: Int, message: String) -> [AnyHashable : Any] {
        let logResult: [AnyHashable : Any] = ["code" : code, "message": message];
        return logResult;
    }

    private func returnCordovaPluginResult(status: CDVCommandStatus, obj: [AnyHashable : Any], command: CDVInvokedUrlCommand) {
        let pluginResult = CDVPluginResult(status: status, messageAs: obj);
        self.commandDelegate!.send(pluginResult, callbackId: command.callbackId);
    }
}
