import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';

import '../styles/colors.dart';

Widget myDivider() => Padding(
      padding: const EdgeInsetsDirectional.only(start: 20),
      child: Container(
        width: double.infinity,
        height: 1,
        color: Colors.grey[300],
      ),
    );

Widget defaultButton({
  double width = double.infinity,
  Color background = Colors.blue,
  required Function function,
  bool isUpperCase = true,
  double radius = 0,
  required String text,
}) =>
    Container(
      width: width,
      height: 40,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(radius),
        color: background,
      ),
      child: MaterialButton(
        onPressed: () {
          function();
        },
        child: Text(
          isUpperCase ? text.toUpperCase() : text,
          style: const TextStyle(color: Colors.white, fontSize: 18),
        ),
      ),
    );

Widget defaultTextButton({
  required Function function,
  required String text,
}) =>
    TextButton(
      onPressed: () {
        function();
      },
      child: Text(
        text.toUpperCase(),
        style: const TextStyle(fontSize: 18, color: Colors.blue),
      ),
    );

Widget defaultFormField({
  required TextEditingController controller,
  required TextInputType type,
  Function? onSubmitted,
  Function? onChanged,
  Function? onTap,
  required validate,
  String? labelText,
  String? hint,
  IconData? prefix,
  ImageIcon? suffix,
  bool isPassword = false,
  Function? suffixPressed,
  bool readonly = false,
  int maxLines = 1,
}) =>
    TextFormField(
      readOnly: readonly,
      controller: controller,
      keyboardType: type,
      onFieldSubmitted: (value) {
        if (onSubmitted != null) {
          onSubmitted(value);
        }
      },
      onChanged: (String value) {
        if (onChanged != null) {
          onChanged(value);
        }
      },
      onTap: () {
        onTap;
      },
      validator: validate,
      maxLines: maxLines,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      decoration: InputDecoration(
          border: const OutlineInputBorder(
              borderSide: BorderSide(color: Colors.red),
              borderRadius: BorderRadius.all(Radius.circular(12))),
          labelText: labelText,
          hintText: hint,
          prefixIcon: prefix != null
              ? Icon(
                  prefix,
                )
              : null,
          suffixIcon: suffix != null
              ? IconButton(
                  onPressed: () {
                    if (suffixPressed == null) {
                    } else {
                      suffixPressed();
                    }
                  },
                  icon: suffix)
              : null),
      obscureText: isPassword,
    );

Widget defaultNumberField({
  required TextEditingController controller,
  required TextEditingController dialController,
}) =>
    Container(
      decoration: BoxDecoration(
          border: Border.all(color: Colors.black45),
          borderRadius: BorderRadius.circular(12)),
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: InternationalPhoneNumberInput(
        initialValue: PhoneNumber(isoCode: 'EG'),
        onInputChanged: (PhoneNumber number) {
          dialController.text = number.dialCode!;
          controller.text = number.phoneNumber!;
        },
        formatInput: true,
        selectorConfig: const SelectorConfig(
          selectorType: PhoneInputSelectorType.BOTTOM_SHEET,
          useBottomSheetSafeArea: true,
        ),
        validator: (value) {
          if (value!.isEmpty) {
            return 'Invalid phone number';
          }
          return null;
        },
        spaceBetweenSelectorAndTextField: 20,
        inputDecoration:
            const InputDecoration.collapsed(hintText: '123 456-7890'),
      ),
    );

void navigateTo(context, widget) =>
    Navigator.push(context, MaterialPageRoute(builder: (context) => widget));

void navigateAndFinish(context, widget) => Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => widget),
      (Route<dynamic> route) => false,
    );

void showToast({
  required String text,
  required ToastState state,
}) =>
    Fluttertoast.showToast(
        msg: text,
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 5,
        backgroundColor: chooseToastColor(state),
        textColor: Colors.white,
        fontSize: 16.0);

// ignore: constant_identifier_names
enum ToastState { SUCCESS, ERROR, WARNING }

Color chooseToastColor(ToastState state) {
  Color color;

  switch (state) {
    case ToastState.SUCCESS:
      color = Colors.green;
      break;
    case ToastState.ERROR:
      color = Colors.red;
      break;
    case ToastState.WARNING:
      color = Colors.amber;
      break;
  }
  return color;
}

Widget defaultToDoButton(
  context, {
  Function? function,
  required String text,
  ImageIcon? icon,
  bool isButtonLoading = false,
}) =>
    Padding(
      padding: const EdgeInsets.symmetric(horizontal: 2),
      child: MaterialButton(
        onPressed: () {
          if (function == null) {
          } else {
            function();
          }
        },
        color: defaultColor,
        height: 50,
        shape: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none),
        child: ConditionalBuilder(
            condition: isButtonLoading,
            builder: (context) =>
                const Center(child: CircularProgressIndicator()),
            fallback: (context) => Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      text,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            color: textInWidgetsColor,
                          ),
                    ),
                    if (icon != null)
                      Padding(
                        padding: const EdgeInsets.only(left: 8),
                        child: icon,
                      ),
                  ],
                )),
      ),
    );

Widget defaultDropDown({
  required String value,
  required List<String> items,
  required ValueChanged<String?> onChanged,
}) {
  return Container(
    width: double.infinity,
    padding: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 20.0),
    decoration: BoxDecoration(
      color: Colors.purple.shade50,
      borderRadius: BorderRadius.circular(12.0),
    ),
    child: DropdownButton<String>(
      isExpanded: true,
      value: value,
      icon: Icon(Icons.arrow_drop_down, color: defaultColor),
      iconSize: 24,
      elevation: 16,
      style: TextStyle(color: defaultColor),
      underline: Container(
        height: 0,
      ),
      onChanged: onChanged,
      items: items.map<DropdownMenuItem<String>>((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Row(
            children: [
              ImageIcon(
                const AssetImage(
                  'assets/icons/flag.png',
                ),
                size: 24,
                color: defaultColor,
              ),
              const SizedBox(width: 8.0),
              Text(
                value,
                style: TextStyle(
                  fontSize: 16.0,
                  fontWeight: FontWeight.bold,
                  color: defaultColor,
                ),
              ),
            ],
          ),
        );
      }).toList(),
    ),
  );
}

Widget defaultDotBox({
  required function,
}) =>
    DottedBorder(
      color: defaultColor.withOpacity(.5),
      strokeWidth: 1.5,
      borderType: BorderType.RRect,
      radius: const Radius.circular(12.0),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12.0),
        child: InkWell(
          onTap: () {
            function();
          },
          child: Padding(
            padding:
                const EdgeInsets.symmetric(vertical: 12.0, horizontal: 24.0),
            child: SizedBox(
              height: 35,
              child: Center(
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Icon(Icons.add_a_photo, color: defaultColor),
                    const SizedBox(width: 8.0),
                    Text(
                      'Add Img',
                      style: TextStyle(
                        color: defaultColor,
                        fontSize: 16.0,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );

Widget dataPreviewFiled({
  String? title,
  required String value,
  IconButton? icon,
  Color? color,
  Color? textColor,
  ImageIcon? preIcon,
}) =>
    Container(
      margin: const EdgeInsets.only(bottom: 16.0),
      padding: const EdgeInsets.only(
        left: 24.0,
        top: 8,
        bottom: 8,
      ),
      decoration: BoxDecoration(
        color: color ?? Colors.grey[200],
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (title != null)
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 12.0,
                    color: Colors.grey,
                  ),
                ),
              if (title != null) const SizedBox(height: 12.0),
              Row(
                children: [
                  if (preIcon != null) preIcon,
                  if (preIcon != null)
                    const SizedBox(
                      width: 20,
                    ),
                  Text(
                    value,
                    style: TextStyle(
                      fontSize: 16.0,
                      fontWeight: FontWeight.bold,
                      color: textColor,
                    ),
                  ),
                ],
              ),
            ],
          ),
          if (icon != null) icon,
        ],
      ),
    );

ImageIcon leadingIcon({
  double? size,
}) =>
    ImageIcon(
      const AssetImage(
        'assets/icons/arrow_left.png',
      ),
      size: size ?? 24,
    );
