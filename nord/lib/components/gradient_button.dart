import 'package:flutter/material.dart';

class GradientButton extends StatelessWidget {
  const GradientButton({
    Key? key,
    this.style,
    required this.onPressed,
    required this.child,
  }) : super(key: key);

  final Widget child;
  final VoidCallback? onPressed;
  final ButtonStyle? style;

  factory GradientButton.icon({
    Key? key,
    ButtonStyle? style,
    required VoidCallback? onPressed,
    required Widget icon,
    required Widget label,
  }) = _GradientButtonWithIcon;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(4.0),
        gradient: LinearGradient(colors: [Colors.red, Colors.yellow]),
      ),
      child: ElevatedButton(
        style: style?.copyWith(
                foregroundColor:
                    MaterialStateProperty.all(Colors.transparent)) ??
            ElevatedButton.styleFrom(primary: Colors.transparent),
        key: key,
        onPressed: onPressed,
        child: child,
      ),
    );
  }
}

class _GradientButtonWithIcon extends GradientButton {
  _GradientButtonWithIcon({
    Key? key,
    this.style,
    required this.onPressed,
    required this.icon,
    required this.label,
  }) : super(
          key: key,
          style: style,
          onPressed: onPressed,
          child: Row(children: [icon, label]),
        );

  final Widget icon;
  final Widget label;
  final VoidCallback? onPressed;
  final ButtonStyle? style;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(4.0),
        gradient: LinearGradient(colors: [Colors.red, Colors.yellow]),
      ),
      child: ElevatedButton.icon(
        style: style?.copyWith(
                backgroundColor:
                    MaterialStateProperty.all(Colors.transparent)) ??
            ElevatedButton.styleFrom(primary: Colors.transparent),
        key: key,
        onPressed: onPressed,
        icon: icon,
        label: label,
      ),
    );
  }
}

/* class GradientButton extends ElevatedButton {
  GradientButton({
    Key? key,
    required VoidCallback? onPressed,
    VoidCallback? onLongPress,
    ValueChanged<bool>? onHover,
    ValueChanged<bool>? onFocusChange,
    ButtonStyle? style,
    FocusNode? focusNode,
    bool autofocus = false,
    Clip clipBehavior = Clip.none,
    required Widget? child,
  }) : super(
          key: key,
          onPressed: onPressed,
          onLongPress: onLongPress,
          onHover: onHover,
          onFocusChange: onFocusChange,
          style: style, //?? ElevatedButton.styleFrom(padding: EdgeInsets.zero),
          focusNode: focusNode,
          autofocus: autofocus,
          clipBehavior: clipBehavior,
          child: Container(
              constraints: BoxConstraints(),
              //padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 23),
              alignment: Alignment.center,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(4),
                gradient: LinearGradient(colors: [Colors.red, Colors.yellow]),
              ),
              child: child),
        );

  factory GradientButton.icon({
    Key? key,
    required VoidCallback? onPressed,
    VoidCallback? onLongPress,
    ValueChanged<bool>? onHover,
    ValueChanged<bool>? onFocusChange,
    ButtonStyle? style,
    FocusNode? focusNode,
    bool? autofocus,
    Clip? clipBehavior,
    required Widget icon,
    required Widget label,
  }) = _GradientButtonWithIcon;
}

class _GradientButtonWithIcon extends GradientButton {
  _GradientButtonWithIcon({
    Key? key,
    required VoidCallback? onPressed,
    VoidCallback? onLongPress,
    ValueChanged<bool>? onHover,
    ValueChanged<bool>? onFocusChange,
    ButtonStyle? style,
    FocusNode? focusNode,
    bool? autofocus,
    Clip? clipBehavior,
    required Widget icon,
    required Widget label,
  })  : assert(icon != null),
        assert(label != null),
        super(
            key: key,
            onPressed: onPressed,
            onLongPress: onLongPress,
            onHover: onHover,
            onFocusChange: onFocusChange,
            style:
                style, // ?? ElevatedButton.styleFrom(padding: EdgeInsets.zero),
            focusNode: focusNode,
            autofocus: autofocus ?? false,
            clipBehavior: clipBehavior ?? Clip.none,
            child: Row(
              children: [icon, label],
            ));
}
 */
