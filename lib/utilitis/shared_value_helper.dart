import 'package:shared_value/shared_value.dart';

SharedValue<bool> isLogin = SharedValue(
    value: false, //initial value
    key: "isLogin"
);
SharedValue<bool> isChecked = SharedValue(
    value: false, //initial value
    key: "isChecked"
);

SharedValue<String> sharedEmail=SharedValue(value: "",key: "sharedEmail");
SharedValue<String> sharedPass=SharedValue(value: "",key: "sharedPass");
SharedValue<String> userToken=SharedValue(value: "",key: "userToken");
SharedValue<String> userName=SharedValue(value: "",key: "userName");
SharedValue<String> userId=SharedValue(value: "",key: "userId");



