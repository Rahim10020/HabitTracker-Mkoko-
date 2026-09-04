import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';

enum AppIcon {
  add('add.svg'),
  arrowLeft('arrow-left.svg'),
  award('award.svg'),
  bell('bell.svg'),
  check('check.svg'),
  delete('delete.svg'),
  dislike('dislike.svg'),
  drag('drag.svg'),
  edit('edit.svg'),
  gAdd('g-add.svg'),
  heart('heart.svg'),
  home('home.svg'),
  like('like.svg'),
  search('search.svg'),
  settings('settings.svg'),
  stats('stats.svg'),
  timer('timer.svg');

  final String fileName;
  const AppIcon(this.fileName);
}

class _SvgCache {
  static final Map<String, String> _cache = {};

  static Future<String> load(AppIcon icon, double? strokeWidth) async {
    final key = '${icon.fileName}:${strokeWidth ?? 0}';
    if (_cache.containsKey(key)) return _cache[key]!;

    final raw = await rootBundle.loadString('assets/icons/${icon.fileName}');
    var processed = raw;

    if (strokeWidth != null) {
      processed =
          processed.replaceAll('<path', '<path stroke-width="$strokeWidth"');
    }

    _cache[key] = processed;
    return processed;
  }
}

class AppSvgIcon extends StatefulWidget {
  final AppIcon icon;
  final Color? color;
  final double size;
  final double? strokeWidth;

  const AppSvgIcon({
    super.key,
    required this.icon,
    this.color,
    this.size = 16,
    this.strokeWidth,
  });

  @override
  State<AppSvgIcon> createState() => _AppSvgIconState();
}

class _AppSvgIconState extends State<AppSvgIcon> {
  late Future<String> _svgFuture;

  @override
  void initState() {
    super.initState();
    _svgFuture = _SvgCache.load(widget.icon, widget.strokeWidth);
  }

  @override
  void didUpdateWidget(covariant AppSvgIcon oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.icon != widget.icon ||
        oldWidget.strokeWidth != widget.strokeWidth) {
      _svgFuture = _SvgCache.load(widget.icon, widget.strokeWidth);
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<String>(
      future: _svgFuture,
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const SizedBox.square(dimension: 24);
        }
        return SvgPicture.string(
          snapshot.data!,
          width: widget.size,
          height: widget.size,
          fit: BoxFit.contain,
          colorFilter: ColorFilter.mode(
            widget.color ?? Theme.of(context).colorScheme.onSurface,
            BlendMode.srcIn,
          ),
        );
      },
    );
  }
}
