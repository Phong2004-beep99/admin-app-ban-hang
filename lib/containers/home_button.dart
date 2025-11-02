import 'package:flutter/material.dart';

class HomeButton extends StatefulWidget {
  final String name;
  final VoidCallback onTap;
  final Color? color;
  final Color? textColor;
  final double? fontSize;
  final double? width;
  final double? height;
  final IconData? icon; // Thêm icon để tăng tính thẩm mỹ

  const HomeButton({
    super.key,
    required this.name,
    required this.onTap,
    this.color,
    this.textColor,
    this.fontSize,
    this.width,
    this.height,
    this.icon,
  });

  @override
  State<HomeButton> createState() => _HomeButtonState();
}

class _HomeButtonState extends State<HomeButton> {
  bool _isPressed = false; // Trạng thái khi bấm nút

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => setState(() => _isPressed = true),
      onTapUp: (_) => setState(() => _isPressed = false),
      onTapCancel: () => setState(() => _isPressed = false),
      onTap: widget.onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        curve: Curves.easeOut,
        height: widget.height ?? 55, // Giảm chiều cao xuống 55px
        width: widget.width ?? MediaQuery.of(context).size.width * .38, // Điều chỉnh chiều rộng hợp lý hơn
        margin: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10), // Bo góc nhẹ hơn
          gradient: LinearGradient(
            colors: _isPressed
                ? [
                    (widget.color ?? Theme.of(context).primaryColor).withOpacity(0.9),
                    (widget.color ?? Theme.of(context).primaryColor).withOpacity(0.6),
                  ]
                : [
                    widget.color ?? Theme.of(context).primaryColor,
                    (widget.color ?? Theme.of(context).primaryColor).withOpacity(0.7),
                  ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          boxShadow: [
            if (!_isPressed)
              BoxShadow(
                color: (widget.color ?? Theme.of(context).primaryColor).withOpacity(0.4),
                blurRadius: 5, // Đổ bóng nhẹ hơn
                offset: const Offset(2, 3),
              ),
          ],
        ),
        child: Center(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (widget.icon != null) ...[
                Icon(widget.icon, color: widget.textColor ?? Colors.white, size: 22),
                const SizedBox(width: 8), // Khoảng cách giữa icon và text
              ],
              Text(
                widget.name,
                style: TextStyle(
                  color: widget.textColor ?? Colors.white,
                  fontSize: widget.fontSize ?? 18, // Giảm font size xuống 18px
                  fontWeight: FontWeight.w600, // Tạo độ đậm vừa phải
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
