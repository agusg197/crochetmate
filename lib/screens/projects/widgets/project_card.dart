import 'package:flutter/material.dart';
import '../../../models/project.dart';
import '../../../services/localization_service.dart';
import 'package:provider/provider.dart';

class ProjectCard extends StatefulWidget {
  final Project project;
  final VoidCallback onTap;
  final int index;

  const ProjectCard({
    required this.project,
    required this.onTap,
    required this.index,
    super.key,
  });

  @override
  State<ProjectCard> createState() => _ProjectCardState();
}

class _ProjectCardState extends State<ProjectCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  late Animation<double> _opacityAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 400),
      vsync: this,
    );

    _scaleAnimation = Tween<double>(begin: 0.95, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOutCubic),
    );

    _opacityAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOutCubic),
    );

    Future.delayed(Duration(milliseconds: 100 * widget.index), () {
      _controller.forward();
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) => Transform.scale(
        scale: _scaleAnimation.value,
        child: Opacity(
          opacity: _opacityAnimation.value,
          child: Card(
            clipBehavior: Clip.antiAlias,
            child: InkWell(
              onTap: widget.onTap,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Imagen o placeholder
                  Expanded(
                    flex: 3,
                    child: widget.project.images.isNotEmpty
                        ? Image.network(
                            widget.project.images.first,
                            fit: BoxFit.cover,
                            width: double.infinity,
                          )
                        : Container(
                            color: Colors.grey[200],
                            child: const Center(
                              child: Icon(
                                Icons.photo_outlined,
                                size: 48,
                                color: Colors.grey,
                              ),
                            ),
                          ),
                  ),
                  // Información del proyecto
                  Expanded(
                    flex: 2,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            widget.project.name,
                            style: Theme.of(context).textTheme.titleMedium,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 4),
                          Text(
                            widget.project.description.isEmpty
                                ? context
                                    .read<LocalizationService>()
                                    .translate('no_description')
                                : widget.project.description,
                            style: Theme.of(context).textTheme.bodySmall,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const Spacer(),
                          // Barra de progreso y estado
                          Row(
                            children: [
                              Expanded(
                                child: LinearProgressIndicator(
                                  value: widget.project.progress,
                                  backgroundColor: Colors.grey[200],
                                ),
                              ),
                              const SizedBox(width: 8),
                              Container(
                                width: 8,
                                height: 8,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: widget.project.status.color,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
