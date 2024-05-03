package com.b2b

/*import com.aeps.aepslib.ICICIEKYCActivity
import com.aeps.aepslib.fragments.EKYCActivity
import com.aeps.aepslib.newCode.AepsActivity
import com.aeps.aepslib.utils.Utils.createMultipleTransactionID
import com.paysprint.onboardinglib.activities.HostActivity*/
import android.app.Activity
import android.app.Activity.RESULT_CANCELED
import android.app.Activity.RESULT_OK
import android.content.ComponentName
import android.content.Intent
import android.os.Build
import android.widget.FrameLayout
import android.widget.Toast
import androidx.annotation.RequiresApi
import com.easebuzz.payment.kit.PWECouponsActivity
import com.fingpay.microatmsdk.MicroAtmLoginScreen
import com.fingpay.microatmsdk.utils.Constants
import com.google.gson.Gson
import com.mosambee.lib.Currency
import com.mosambee.lib.MosCallback
import com.mosambee.lib.ResultData
import com.mosambee.lib.TransactionResult
import com.paysprint.onboardinglib.activities.HostActivity
import datamodels.PWEStaticDataModel
import `in`.credopay.payment.sdk.CredopayPaymentConstants
import `in`.credopay.payment.sdk.PaymentActivity
import `in`.credopay.payment.sdk.PaymentManager
import `in`.credopay.payment.sdk.Utils
import io.flutter.Log
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.Result
import java.util.Base64
import org.json.JSONObject

class MainActivity : FlutterActivity(), TransactionResult {

    private val CHANNEL = "intent_method_channel"
    private lateinit var responseResult: Result
    var container: FrameLayout? = null
    private var startPayment = true
    var moscCallback: MosCallback? = null

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        startPayment = true
        val methodChannel = MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL)
        methodChannel.setMethodCallHandler { call, result ->
            when (call.method) {
                "MANTRA",
                "MANTRAIRIS",
                "MORPHO",
                "STARTEK",
                "SECUGEN" -> {
                    responseResult = result
                    callCaptureFingerprint(call.arguments as HashMap<String, Any>)
                }
                "MASFPL" -> {
                    responseResult = result
                    callSmartSdkCaptureFingerprint(call.arguments as HashMap<String, Any>)
                }
                "paysprintOnboarding" -> {
                    responseResult = result
                    callPaysprintOnboarding(call.arguments as HashMap<String, Any>)
                }
                "fingpayMatm" -> {
                    responseResult = result
                    callFingpayMatm(call.arguments as HashMap<String, Any>)
                }
                "payWithEasebuzz" -> {
                    responseResult = result
                    startPayment = true

                    try {
                        if (startPayment) {
                            startPayment = false
                            startPaymentMethod(call.arguments)
                        }
                    } catch (e: Exception) {
                        Log.e("[payWithEasebuzz Intent] => ", e.toString())
                    }
                }
                "credoPayPayment" -> {
                    try {
                        responseResult = result
                        callCredoPayment(call.arguments as HashMap<String, Any>);

                        /*  val intent = Intent(this, PaymentActivity::class.java)
                          intent.putExtra("TRANSACTION_TYPE", CredopayPaymentConstants.BALANCE_ENQUIRY)
                          intent.putExtra("DEBUG_MODE", false)
                          intent.putExtra("PRODUCTION", true)
                          intent.putExtra("AMOUNT", amount * 100)
                          intent.putExtra("MOBILE_NUMBER", mobileumber)
                          intent.putExtra("LOGIN_ID", loginid)
                          intent.putExtra("LOGIN_PASSWORD", password)
                          intent.putExtra("CUSTOM_FIELD1", "")
                          intent.putExtra("CUSTOM_FIELD2", "")
                          intent.putExtra("CUSTOM_FIELD3", "")
                          intent.putExtra("CRN_U", crnu)
                          intent.putExtra("SUCCESS_DISMISS_TIMEOUT", 10000L)
                          //intent.putExtra("LOGO", Utils.getVariableImage(ContextCompat.getDrawable(getApplicationContext(), R.mipmap.ic_launcher)));
                          intent.addFlags(Intent.FLAG_ACTIVITY_CLEAR_TOP)
                          startActivityForResult(intent, 1)*/


                    } catch (e: Exception) {
                        System.out.print("intent: " + e.toString());
                    }
                }
                "startMosambePayment" -> {
                    try {
                        responseResult = result
                        startMosambePayment()
                    } catch (e: Exception) {
                        System.out.print("Exception: " + e.toString())
                    }
                }
                /* "yesBankOnboarding" -> {
                    responseResult = result
                    callYesBankOnboarding(call.arguments as HashMap<String, Any>)
                }
                "iciciBankOnboarding" -> {
                    responseResult = result
                    callIciciBankOnboarding(call.arguments as HashMap<String, Any>)
                }
                "bankitOnboarding" -> {
                    responseResult = result
                    callBankitOnboarding(call.arguments as HashMap<String, Any>)
                }*/
                else -> {
                    result.notImplemented()
                }
            }
        }
    }

    // Capture fingerprint
    private fun callCaptureFingerprint(args: HashMap<String, Any>) {
        try {
            val packageName = args["packageName"] as String
            val setAction = args["setAction"] as String
            val pidOption = args["pidOption"] as String
            val intent = Intent(packageName)
            intent.setPackage(packageName)
            intent.setAction(setAction)
            intent.putExtra("PID_OPTIONS", pidOption)
            startActivityForResult(intent, 17)
        } catch (e: Exception) {
            Log.e("[Capture Fingerprint Intent] => ", e.toString())
        }
    }

    // Smart sdk capture fingerprint
    private fun callSmartSdkCaptureFingerprint(args: HashMap<String, Any>) {
        try {
            val packageName = args["packageName"] as String
            val isFromApp = args["IsFromApp"] as String
            val type = args["Type"] as String
            val userName = args["UserName"] as String
            val authKey = args["AuthKey"] as String
            val agentId = args["AgentId"] as String
            val merchantId = args["MerchantId"] as String

            val intent = Intent(packageName)
            intent.putExtra("IsFromApp", isFromApp)
            intent.putExtra("Type", type)
            intent.putExtra("UserName", userName)
            intent.putExtra("AuthKey", authKey)
            intent.putExtra("AgentId", agentId)
            intent.putExtra("MerchantId", merchantId)
            intent.component = ComponentName("com.masfplsdk", "com.masfplsdk.MainActivity")
            startActivityForResult(intent, 555)
        } catch (e: Exception) {
            Log.e("[Smart SDK Capture Fingerprint Intent] => ", e.toString())
        }
    }

    // Paysprint onboarding
    private fun callPaysprintOnboarding(args: HashMap<String, Any>) {
        try {
            val intent =
                Intent(applicationContext, HostActivity::class.java).apply {
                    putExtra("pId", args["pId"] as String)
                    putExtra("pApiKey", args["pApiKey"] as String)
                    putExtra("mCode", args["mCode"] as String)
                    putExtra("mobile", args["mobile"] as String)
                    putExtra("lat", args["lat"] as String)
                    putExtra("lng", args["lng"] as String)
                    putExtra("firm", args["firm"] as String)
                    putExtra("email", args["email"] as String)
                    addFlags(Intent.FLAG_ACTIVITY_NO_ANIMATION)
                }
            startActivityForResult(intent, 999)
        } catch (e: Exception) {
            Log.e("[Paysprint Intent] => ", e.toString())
        }
    }

    // Fingpay Matm
    private fun callFingpayMatm(args: HashMap<String, Any>) {
        try {
            val selectedType = args["type"] as String
            val intent = Intent(applicationContext, MicroAtmLoginScreen::class.java)
            if (selectedType == "Cash Withdrawal") {
                intent.putExtra(Constants.TYPE, Constants.CASH_WITHDRAWAL)
            } else if (selectedType == "Cash Deposit") {
                intent.putExtra(Constants.TYPE, Constants.CASH_DEPOSIT)
            } else if (selectedType == "Balance Enquiry") {
                intent.putExtra(Constants.TYPE, Constants.BALANCE_ENQUIRY)
            } else if (selectedType == "Mini Statement") {
                intent.putExtra(Constants.TYPE, Constants.MINI_STATEMENT)
            } else if (selectedType == "Pin Reset") {
                intent.putExtra(Constants.TYPE, Constants.PIN_RESET)
            } else if (selectedType == "Change Pin") {
                intent.putExtra(Constants.TYPE, Constants.CHANGE_PIN)
            } else if (selectedType == "Card Activation") {
                intent.putExtra(Constants.TYPE, Constants.CARD_ACTIVATION)
            } else if (selectedType == "Purchase") {
                intent.putExtra(Constants.TYPE, Constants.PURCHASE)
            }
            intent.putExtra(Constants.MERCHANT_USERID, args["merchantUserId"] as String)
            intent.putExtra(Constants.MERCHANT_PASSWORD, args["merchantPassword"] as String)
            intent.putExtra(Constants.MOBILE_NUMBER, args["mobileNumber"] as String)
            intent.putExtra(Constants.AMOUNT, args["amount"] as String)
            intent.putExtra(Constants.REMARKS, args["remarks"] as String)
            intent.putExtra(Constants.AMOUNT_EDITABLE, false)
            intent.putExtra(Constants.TXN_ID, args["txnId"] as String)
            intent.putExtra(Constants.SUPER_MERCHANTID, args["superMerchantId"] as String)
            intent.putExtra(Constants.IMEI, args["imei"] as String)
            intent.putExtra(Constants.LATITUDE, args["latitude"] as Double)
            intent.putExtra(Constants.LONGITUDE, args["longitude"] as Double)
            intent.putExtra(Constants.MICROATM_MANUFACTURER, Constants.MoreFun)
            startActivityForResult(intent, 16)
        } catch (e: Exception) {
            Log.e("[Fingpay Matm Intent Error] => ", e.toString())
        }
    }

  //CredoPay Matm
    private fun callCredoPayment(args: HashMap<String, Any>) {
        // Implement the Credo Pay SDK payment initiation here
        val type = args["txntype"] ?: 1
        val amount = args["amount"] ?: 0
        val mobileumber = args["mobileumber"] ?: ""
        val loginid = args["loginid"] ?: ""
        val password = args["password"] ?: ""
        val crnu = args["crnu"] ?: ""


        try {
            val intent = Intent(this, PaymentActivity::class.java)
            if (type == 0) {
                intent.putExtra("TRANSACTION_TYPE", CredopayPaymentConstants.MICROATM)

            } else if (type == 1) {
                intent.putExtra("TRANSACTION_TYPE", CredopayPaymentConstants.BALANCE_ENQUIRY)

            } else if (type == 2) {
                intent.putExtra("TRANSACTION_TYPE", CredopayPaymentConstants.PURCHASE)

            }
            intent.putExtra("DEBUG_MODE", true)
            intent.putExtra("PRODUCTION", true)
            intent.putExtra("AMOUNT", args["amount"] as Int)
            /* if (amount==0 || type == 1) {
                 intent.putExtra("AMOUNT", 0)
             } else {
                 intent.putExtra("AMOUNT", amount)
             }*/
            intent.putExtra("MOBILE_NUMBER", args["mobileumber"] as String)
            intent.putExtra("LOGIN_ID", args["loginid"] as String)
            intent.putExtra("LOGIN_PASSWORD", args["password"] as String)
            //intent.putExtra("LOGIN_PASSWORD", "[C@d64dc2e");
            intent.putExtra("CUSTOM_FIELD1", "")
            intent.putExtra("CUSTOM_FIELD2", "")
            intent.putExtra("CUSTOM_FIELD3", "")
            intent.putExtra("CRN_U", args["crnu"] as String)
            intent.putExtra("SUCCESS_DISMISS_TIMEOUT", 10000L)
            //intent.putExtra("LOGO", Utils.getVariableImage(ContextCompat.getDrawable(getApplicationContext(), R.mipmap.ic_launcher)));
            //intent.putExtra("CUSTOM_FIELD1", "test")
            //intent.putExtra("CRN_U", "6161461")
            //intent.addFlags(Intent.FLAG_ACTIVITY_CLEAR_TOP)
            startActivityForResult(intent, 123)

        } catch (e: Exception) {
            System.out.print("intent: " + e.toString());
        }
        /*try {
            val intent = Intent(this, PaymentActivity::class.java)
            intent.putExtra("TRANSACTION_TYPE", CredopayPaymentConstants.BALANCE_ENQUIRY)
            intent.putExtra("DEBUG_MODE", false)
            intent.putExtra("PRODUCTION", true)
            intent.putExtra("AMOUNT", 0)
            intent.putExtra("MOBILE_NUMBER", "9999999999")
            intent.putExtra("LOGIN_ID", "2000055115")
            intent.putExtra("LOGIN_PASSWORD", "hm8Zqp@vic")
            //intent.putExtra("LOGIN_PASSWORD", "[C@d64dc2e");
            intent.putExtra("CUSTOM_FIELD1", "")
            intent.putExtra("CUSTOM_FIELD2", "")
            intent.putExtra("CUSTOM_FIELD3", "")
            intent.putExtra("CRN_U", "8464642782")
            intent.putExtra("SUCCESS_DISMISS_TIMEOUT", 10000L)
            //intent.putExtra("LOGO", Utils.getVariableImage(ContextCompat.getDrawable(getApplicationContext(), R.mipmap.ic_launcher)));
            //intent.putExtra("CUSTOM_FIELD1", "test")
            //intent.putExtra("CRN_U", "6161461")
            //intent.addFlags(Intent.FLAG_ACTIVITY_CLEAR_TOP)
            startActivityForResult(intent, 123)

        } catch (e: Exception) {
            System.out.print("intent: " + e.toString());
        }*/
    }

    // Easebuzz PG start payment
    private fun startPaymentMethod(arguments: Any) {
        try {
            val gson = Gson()
            val parameters = JSONObject(gson.toJson(arguments))
            val intentProceed = Intent(baseContext, PWECouponsActivity::class.java)
            intentProceed.flags = Intent.FLAG_ACTIVITY_REORDER_TO_FRONT

            intentProceed.putExtra("access_key", parameters.getString("access_key"))
            intentProceed.putExtra("pay_mode", parameters.getString("pay_mode"))

            if (parameters.has("custom_options")) {
                intentProceed.putExtra("custom_options", parameters.optString("custom_options"))
            }

            startActivityForResult(intentProceed, PWEStaticDataModel.PWE_REQUEST_CODE)
        } catch (e: Exception) {
            startPayment = true
            val error_map: MutableMap<String, Any> = HashMap()
            val error_desc_map: MutableMap<String, Any> = HashMap()
            val error_desc = "exception occured:" + e.message
            error_desc_map["error"] = "Exception"
            error_desc_map["error_msg"] = error_desc
            error_map["result"] = PWEStaticDataModel.TXN_FAILED_CODE
            error_map["payment_response"] = error_desc_map
            responseResult!!.success(error_map)
        }
    }

    // Mosambee matm sdk
    private fun startMosambePayment() {
        try {

            moscCallback = MosCallback(context)
            moscCallback!!.initialise("9810881428", "3315", this)
            moscCallback!!.setInternalUi(activity, false)
            moscCallback!!.initializeSignatureView(container, "#55004A", "#750F5A")
            moscCallback!!.initialiseFields(
                "BALANCE ENQUIRY",
                "9810881428",
                "cGjhE$@fdhj4675riesae",
                false,
                "SHYAM.JEE@RELIGARE.COM",
                "9810881428",
                "bt",
                "",
                ""
            )
            moscCallback!!.processTransaction("95784545", "95784545", 0.0, "675466".toDouble(), "879209", Currency.INR)
        } catch (e: Exception) {
            Log.e("Mosambe SDK error", e.toString())
        }
    }

    /*// Yes bank onboarding
    private fun callYesBankOnboarding(args: HashMap<String, Any>) {
        try {
            val intent =
                Intent(applicationContext, EKYCActivity::class.java).apply {
                    putExtra("agent_id", args["agent_id"] as String)
                    putExtra("developer_id", args["developer_id"] as String)
                    putExtra("password", args["password"] as String)
                    putExtra("mobile", args["mobile"] as String)
                    putExtra("aadhaar", args["aadhaar"] as String)
                    putExtra("email", args["email"] as String)
                    putExtra("pan", args["pan"] as String)
                    putExtra("primary_color", R.color.primary_color)
                    putExtra("accent_color", R.color.accent_color)
                    putExtra("primary_dark_color", R.color.primary_dark_color)
                    addFlags(Intent.FLAG_ACTIVITY_CLEAR_TOP)
                }
            startActivityForResult(intent, 400)
        } catch (e: Exception) {
            Log.e("[Bankit Intent] => ", e.toString())
        }
    }

    // Icici bank onboarding
    private fun callIciciBankOnboarding(args: HashMap<String, Any>) {
        try {
            val intent =
                Intent(applicationContext, ICICIEKYCActivity::class.java).apply {
                    putExtra("agent_id", args["agent_id"] as String)
                    putExtra("developer_id", args["developer_id"] as String)
                    putExtra("password", args["password"] as String)
                    putExtra("primary_color", R.color.primary_color)
                    putExtra("accent_color", R.color.accent_color)
                    putExtra("primary_dark_color", R.color.primary_dark_color)
                    addFlags(Intent.FLAG_ACTIVITY_CLEAR_TOP)
                }
            startActivityForResult(intent, 400)
        } catch (e: Exception) {
            Log.e("[Bankit Intent] => ", e.toString())
        }
    }

    // Bankit onboarding
    private fun callBankitOnboarding(args: HashMap<String, Any>) {
        try {
            val intent =
                Intent(applicationContext, AepsActivity::class.java).apply {
                    putExtra("agent_id", args["agent_id"] as String)
                    putExtra("developer_id", args["developer_id"] as String)
                    putExtra("password", args["password"] as String)
                    putExtra("primary_color", R.color.primary_color)
                    putExtra("accent_color", R.color.accent_color)
                    putExtra("primary_dark_color", R.color.primary_dark_color)
                    putExtra("clientTransactionId", createMultipleTransactionID())
                    putExtra("bankVendorType", args["bankVendorType"] as String)
                    addFlags(Intent.FLAG_ACTIVITY_CLEAR_TOP)
                }
            startActivityForResult(intent, 300)
        } catch (e: Exception) {
            Log.e("[Bankit Intent] => ", e.toString())
        }
    }*/

    @RequiresApi(Build.VERSION_CODES.O)
    override fun onActivityResult(requestCode: Int, resultCode: Int, data: Intent?) {
        super.onActivityResult(requestCode, resultCode, data)
        if (requestCode == 123) {
            println("Into the credopay requestCode")
            when (resultCode) {
                //println("intent: result!"+resultCode)

                CredopayPaymentConstants.TRANSACTION_COMPLETED -> {
                    PaymentManager.getInstance().logout()
                    println("intent Result=> TRANSACTION_COMPLETED")
                    responseResult.success("TRANSACTION_COMPLETED")
                    showToast("TRANSACTION_COMPLETED")
                }
                CredopayPaymentConstants.TRANSACTION_CANCELLED -> {
                    PaymentManager.getInstance().logout()
                    println("intent Result=> TRANSACTION_CANCELLED")
                    responseResult.success("TRANSACTION_CANCELLED")
                    showToast("TRANSACTION_CANCELLED")
                }
                CredopayPaymentConstants.VOID_CANCELLED -> {
                    PaymentManager.getInstance().logout()
                    println("intent Result=> VOID_CANCELLED")
                    responseResult.success("VOID_CANCELLED")
                    showToast("VOID_CANCELLED")
                }
                CredopayPaymentConstants.LOGIN_FAILED -> {
                    println("intent Result=> LOGIN_FAILED")
                    responseResult.success("LOGIN_FAILED")
                    showToast("LOGIN_FAILED")


                }
                CredopayPaymentConstants.CHANGE_PASSWORD -> {
                    Toast.makeText(this@MainActivity, "CHANGE_PASSWORD", Toast.LENGTH_LONG)
                        .show()
                    println("intent Result=> CHANGE_PASSWORD")
                    responseResult.success("CHANGE_PASSWORD")
                    showToast("CHANGE_PASSWORD")

                }
                CredopayPaymentConstants.CHANGE_PASSWORD_FAILED -> {
                    println("intent Result=> CHANGE_PASSWORD_FAILED")
                    responseResult.success("CHANGE_PASSWORD_FAILED")
                    showToast("CHANGE_PASSWORD_FAILED")


                }
                CredopayPaymentConstants.CHANGE_PASSWORD_SUCCESS -> {
                    println("intent Result=> CHANGE_PASSWORD_SUCCESS")
                    responseResult.success("CHANGE_PASSWORD_SUCCESS")
                    //showToast("CHANGE_PASSWORD_SUCCESS")

                }
                else -> {
                    Toast.makeText(
                        this@MainActivity,
                        "DEFAULT Credopay",
                        Toast.LENGTH_SHORT
                    ).show()
                    println("intent Result=> DEFAULT Credopay")
                }
            }
        } else if (resultCode == Activity.RESULT_OK && data != null) {
        when (requestCode) {
            17 -> {
                if (resultCode == Activity.RESULT_OK) {
                    try {
                        if (data != null && data.hasExtra("PID_DATA")) {
                            val intentResult = data.getStringExtra("PID_DATA")
                            if (intentResult != null) {
                                if (
                                    intentResult.toLowerCase().trim().contains("errinfo") &&
                                        intentResult.toLowerCase().trim().contains("device not ready")
                                ) {
                                    showToast("Device not ready")
                                    responseResult.error("720", "Device not ready", "")
                                } else if (
                                    intentResult.toLowerCase().trim().contains("errinfo") &&
                                        intentResult.toLowerCase().trim().contains("capture timed out")
                                ) {
                                    showToast("Capture timed out")
                                    responseResult.error("700", "Capture timed out", "")
                                } else if (
                                    intentResult.trim().contains("STARTEK") &&
                                        intentResult.toLowerCase().trim().contains("capture aborted")
                                ) {
                                    responseResult.error("ErrorCode", "Fingerprint didn't capture, try again", "")
                                } else if (
                                    intentResult.trim().contains("errCode=\"0\"") ||
                                        intentResult.toLowerCase().trim().contains("capture success")
                                ) {
                                    val xmlBytes = intentResult.toByteArray(Charsets.UTF_8)
                                    val base64Encoded = Base64.getEncoder().encodeToString(xmlBytes)
                                    val pidData = base64Encoded
                                    responseResult.success(pidData)
                                } else {
                                    showToast("Something Went Wrong")
                                    responseResult.error("ErrorCode", "Something Went Wrong", "")
                                }
                            }
                        } else {
                            showToast("Unable to fetch device information")
                            responseResult.error("ErrorCode", "Unable to fetch device information", "")
                        }
                    } catch (e: Exception) {
                        showToast(e.toString())
                        responseResult.error("ErrorCode", e.toString(), "")
                    }
                } else if (resultCode == Activity.RESULT_CANCELED) {
                    showToast("CANCELED")
                } else {
                    showToast("Something went wrong")
                }
            }
            555 -> {
                if (resultCode == RESULT_OK && data != null) {
                    Log.e("[MASFPL Response] => ", data.toString())
                } else if (resultCode == RESULT_CANCELED) {
                    showToast("CANCELED")
                } else {
                    showToast("Something went wrong")
                }
            }
            999 -> {
                if (resultCode == RESULT_OK && data != null) {
                    Log.e("[Paysprint Response] => ", data.toString())
                    val status: Boolean = data.getBooleanExtra("status", false)
                    val response: Int = data.getIntExtra("response", 0)
                    val message: String? = data.getStringExtra("message")
                    val jsonObject =
                        JSONObject().apply {
                            put("status", status)
                            put("response", response)
                            put("message", message.orEmpty())
                        }
                    val jsonString: String = jsonObject.toString()
                    responseResult.success(jsonString)
                } else if (resultCode == RESULT_CANCELED) {
                    showToast("CANCELED")
                } else {
                    showToast("Something went wrong")
                }
            }
            16 -> {
                if (resultCode == RESULT_OK && data != null) {
                    val status: Boolean = data.getBooleanExtra(Constants.TRANS_STATUS, false)
                    val response: String? = data.getStringExtra(Constants.MESSAGE)
                    val transAmount: Double = data.getDoubleExtra(Constants.TRANS_AMOUNT, 0.0)
                    val balAmount: Double = data.getDoubleExtra(Constants.BALANCE_AMOUNT, 0.0)
                    val bankRrn: String? = data.getStringExtra(Constants.RRN)
                    val transType: String? = data.getStringExtra(Constants.TRANS_TYPE)
                    val type: Int = data.getIntExtra(Constants.TYPE, Constants.CASH_WITHDRAWAL)
                    val cardNum: String? = data.getStringExtra(Constants.CARD_NUM)
                    val bankName: String? = data.getStringExtra(Constants.BANK_NAME)
                    val cardType: String? = data.getStringExtra(Constants.CARD_TYPE)
                    val terminalId: String? = data.getStringExtra(Constants.TERMINAL_ID)
                    val fpId: String? = data.getStringExtra(Constants.FP_TRANS_ID)
                    val transId: String? = data.getStringExtra(Constants.TRANS_ID)

                    val jsonObject =
                        JSONObject().apply {
                            put("status", status)
                            put("response", response.orEmpty())
                            put("transAmount", transAmount)
                            put("balAmount", balAmount)
                            put("bankRrn", bankRrn.orEmpty())
                            put("transType", transType.orEmpty())
                            put("type", type)
                            put("cardNum", cardNum.orEmpty())
                            put("bankName", bankName.orEmpty())
                            put("cardType", cardType.orEmpty())
                            put("terminalId", terminalId.orEmpty())
                            put("fpId", fpId.orEmpty())
                            put("transId", transId.orEmpty())
                        }

                    val jsonString: String = jsonObject.toString()
                    responseResult.success(jsonString)
                }
            }
            400 -> {
                if (resultCode == RESULT_OK && data != null) {
                    Log.e("[Bankit Yes Bank Response] => ", data.toString())
                    responseResult.success(data)
                } else if (resultCode == RESULT_CANCELED) {
                    showToast("CANCELED")
                } else {
                    showToast("Something went wrong")
                }
            }
            300 -> {
                if (resultCode == RESULT_OK && data != null) {
                    Log.e("[Bankit Response] => ", data.toString())
                    responseResult.success(data)
                } else if (resultCode == RESULT_CANCELED) {
                    showToast("CANCELED")
                } else {
                    showToast("Something went wrong")
                }
            }
            1 -> {
                if (resultCode == RESULT_OK && data != null) {
                    when (resultCode) {
                        CredopayPaymentConstants.TRANSACTION_COMPLETED -> {
                            PaymentManager.getInstance().logout()
                            Toast.makeText(this, "TRANSACTION_COMPLETED", Toast.LENGTH_LONG).show()
                        }
                        CredopayPaymentConstants.TRANSACTION_CANCELLED -> {
                            PaymentManager.getInstance().logout()
                            Toast.makeText(this, "TRANSACTION_CANCELLED", Toast.LENGTH_LONG).show()
                        }
                        CredopayPaymentConstants.VOID_CANCELLED -> {
                            PaymentManager.getInstance().logout()
                            Toast.makeText(this, "VOID_CANCELLED", Toast.LENGTH_LONG).show()
                        }
                        CredopayPaymentConstants.LOGIN_FAILED ->
                            Toast.makeText(this, "LOGIN_FAILED", Toast.LENGTH_SHORT).show()
                        CredopayPaymentConstants.CHANGE_PASSWORD -> {
                            Toast.makeText(this, "CHANGE_PASSWORD", Toast.LENGTH_LONG).show()
                        }
                        CredopayPaymentConstants.CHANGE_PASSWORD_FAILED ->
                            Toast.makeText(this, "CHANGE_PASSWORD_FAILED", Toast.LENGTH_SHORT).show()
                        CredopayPaymentConstants.CHANGE_PASSWORD_SUCCESS -> {
                            Toast.makeText(this, "CHANGE_PASSWORD_SUCCESS", Toast.LENGTH_SHORT).show()
                        }
                        else -> Toast.makeText(this, "DEFAULT", Toast.LENGTH_SHORT).show()
                    }
                } else if (resultCode == RESULT_CANCELED) {
                    showToast("CANCELED")
                } else {
                    showToast("Something went wrong")
                }
            }
            PWEStaticDataModel.PWE_REQUEST_CODE -> {
                Log.e("[PayWithEaseBuzz Response] => ", data.toString())
                if (resultCode == Activity.RESULT_OK) {

                    startPayment = true
                    val response = JSONObject()
                    val error_map: MutableMap<String, Any> = HashMap()
                    if (data != null) {
                        val result = data.getStringExtra("result")
                        val payment_response = data.getStringExtra("payment_response")
                        try {
                            val obj = JSONObject(payment_response)
                            response.put("result", result)
                            response.put("payment_response", obj)
                            responseResult!!.success(JsonConverter.convertToMap(response))
                        } catch (e: Exception) {
                            val error_desc_map: MutableMap<String, Any> = HashMap()
                            /* Used the below code For target 30 api*/
                            error_desc_map["error"] = result.toString()
                            error_desc_map["error_msg"] = payment_response.toString()
                            error_map["result"] = result.toString()
                            /* End code For target 30 api*/
                            error_map["payment_response"] = error_desc_map
                            responseResult!!.success(error_map)
                        }
                    } else {
                        val error_desc_map: MutableMap<String, Any> = HashMap()
                        val error_desc = "Empty payment response"
                        error_desc_map["error"] = "Empty error"
                        error_desc_map["error_msg"] = error_desc
                        error_map["result"] = "payment_failed"
                        error_map["payment_response"] = error_desc_map
                        responseResult!!.success(error_map)
                    }
                } else if (resultCode == RESULT_CANCELED) {
                    // showToast("CANCELED")
                    val error_map: MutableMap<String, Any> = HashMap()
                    error_map["result"] = "Cancelled"
                    error_map["payment_response"] = "Cancelled by user"
                    responseResult!!.success(error_map)
                }
            }
            else -> {
                super.onActivityResult(requestCode, resultCode, data)
            }
        }
        }else if (resultCode == RESULT_CANCELED) {
            showToast("CANCELED")
        } else {
            showToast("Something went wrong")
        }
    }

    private fun showToast(message: String) {
        Toast.makeText(this, message, Toast.LENGTH_LONG).show()
    }

    override fun onResult(resultData: ResultData?) {
        if (resultData != null) {
            System.out.println(
                "\n-----Result: " +
                    resultData.getResult() +
                    "\n-----Reason: " +
                    resultData.getReason() +
                    "\n-----Data: " +
                    resultData.getTransactionData()
            )
        }

        if (resultData != null) {
            if (resultData.result) {
                // Transaction was successful, handle it here
                val transactionData = resultData.transactionData
                io.flutter.Log.e("MOSambee SDK Response", transactionData)
                // Implement your logic for a successful transaction
            } else {
                // Transaction failed, handle it here
                val errorMessage = resultData.reason
                io.flutter.Log.e("MOSambee SDK errorMessage", errorMessage)
                // Implement your logic for a failed transaction
            }
        } else {
            // Handle the case where resultData is null
        }
    }

    override fun onCommand(p0: String?) {}
}
