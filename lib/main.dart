import 'package:flutter/material.dart';
import 'dart:math' as math;

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: WeeklyCalendar(),
    );
  }
}

class WeeklyCalendar extends StatelessWidget {
  const WeeklyCalendar({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      body: Column(
        children: [
          
          // Contenedor como AppBar (Header de la aplicación)
          Container(
            height: 60,
            padding: const EdgeInsets.symmetric(horizontal: 12),
            decoration: const BoxDecoration(color: Colors.white),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: Colors.grey.shade300),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.05),
                            blurRadius: 2,
                            offset: const Offset(0, 1),
                          ),
                        ],
                      ),
                      // Caja de texto con icono y texto "Hoy"
                      child: Row(
                        children: [
                          const SizedBox(width: 20),
                          Icon(
                            Icons.calendar_today,
                            size: 18,
                            color: Colors.grey[700],
                          ),
                          const SizedBox(width: 20),
                          const Text(
                            'Hoy',
                            style: TextStyle(
                              fontWeight: FontWeight.w500,
                              color: Colors.black87,
                            ),
                          ),
                          const SizedBox(width: 20),
                        ],
                      ),
                    ),

                    const SizedBox(width: 10),

                    // Botón de flecha izquierda
                    IconButton(
                      icon: const Icon(Icons.chevron_left),
                      color: Colors.grey[700],
                      onPressed: () {
                        debugPrint('Semana anterior');
                      },
                    ),

                    // Botón de flecha derecha
                    IconButton(
                      icon: const Icon(Icons.chevron_right),
                      color: Colors.grey[700],
                      onPressed: () {
                        debugPrint('Semana siguiente');
                      },
                    ),

                    const SizedBox(width: 10),

                    // Texto con la semana
                    const Text(
                      "Semana: 22 - 28 Septiembre 2025",
                      style: TextStyle(color: Colors.black, fontSize: 20),
                    ),

                    const SizedBox(width: 10),

                    // Botón de flecha abajo
                    IconButton(
                      icon: const Icon(Icons.arrow_drop_down),
                      color: Colors.grey[700],
                      onPressed: () {
                        debugPrint('Semana siguiente');
                      },
                    ),
                  ],
                ),

                // Botón de menú desplegable
                PopupMenuButton<String>(
                  itemBuilder: (context) => const [
                    PopupMenuItem(child: Text('Editar')),
                    PopupMenuItem(child: Text('Eliminar')),
                    PopupMenuItem(child: Text('Compartir')),
                  ],
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: Colors.grey.shade300),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.05),
                          blurRadius: 2,
                          offset: const Offset(0, 1),
                        ),
                      ],
                    ),

                    // Botón de filtro que activa el menú desplegable
                    child: const Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.filter_alt, color: Colors.black),
                        SizedBox(width: 6),
                        Text(
                          'Filtrar',
                          style: TextStyle(
                            color: Colors.black87,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Contenido principal
          const Expanded(
            child: _CalendarBody(),
          ),
        ],
      ),
    );
  }
}


class _CalendarBody extends StatefulWidget {
  const _CalendarBody();

  @override
  State<_CalendarBody> createState() => _CalendarBodyState();
}

class _CalendarBodyState extends State<_CalendarBody> {
  final ScrollController _scrollController = ScrollController();

  // Dimensiones
  static const double _hourRowHeight = 56;
  static const double _dayHeaderHeight = 50;
  static const double _gutterWidth = 60;
  static const double _minEventHeight = 88;

  // Semana actual
  DateTime get _startOfWeek {
    final now = DateTime.now();
    final monday = now.subtract(Duration(days: (now.weekday + 6) % 7));
    return DateTime(monday.year, monday.month, monday.day);
  }

  List<DateTime> get _daysOfWeek =>
      List.generate(7, (i) => _startOfWeek.add(Duration(days: i)));

  // Eventos semanales
  final List<_CalendarEvent> _events = const [
    _CalendarEvent(
      day: 0,
      startHour: 9.0,
      endHour: 11.5,
      title: 'Reunión de Coordinación',
      description: 'Seguimiento semanal con el equipo',
      icon: Icons.group,
      color: Color(0xFFB8E6C7),
    ),
    _CalendarEvent(
      day: 1,
      startHour: 8.5,
      endHour: 9.0,
      title: 'Daily Smart',
      description: 'Status diario del proyecto',
      icon: Icons.bolt,
      color: Color(0xFFCCE1FF),
    ),
    _CalendarEvent(
      day: 1,
      startHour: 13.0,
      endHour: 14.0,
      title: 'Reunión Interna',
      description: 'Planificación y pendientes',
      icon: Icons.meeting_room,
      color: Color(0xFFE6F6EC),
    ),
    _CalendarEvent(
      day: 2,
      startHour: 9.0,
      endHour: 11.0,
      title: 'Temas del día',
      description: 'Revisión de issues y PRs',
      icon: Icons.topic,
      color: Color(0xFFD9C7F7),
    ),
    _CalendarEvent(
      day: 3,
      startHour: 10.0,
      endHour: 11.0,
      title: 'Demo Sprint',
      description: 'Presentación de avances',
      icon: Icons.present_to_all,
      color: Color(0xFFFFE7C2),
    ),
    _CalendarEvent(
      day: 4,
      startHour: 16.0,
      endHour: 17.0,
      title: 'Cierre Semanal',
      description: 'Retro y próximos pasos',
      icon: Icons.flag,
      color: Color(0xFFB8E6C7),
    ),
    _CalendarEvent(
      day: 5,
      startHour: 9.0,
      endHour: 12.0,
      title: 'Clases',
      description: 'Módulo de Multiplataforma',
      icon: Icons.school,
      color: Color(0xFFCFE8E8),
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    const int startHour = 8;  // Hora de inicio
    const int endHour = 24;   // Hora de fin
    const int totalHours = endHour - startHour;
    const double totalHeight = totalHours * _hourRowHeight;

    return Column(
      children: [
        // Cabecera de los días
        Container(
          height: _dayHeaderHeight,
          decoration: BoxDecoration(
            color: Colors.white,
            border: Border(bottom: BorderSide(color: Colors.grey.shade300)),
          ),
          child: Row(
            children: [
              SizedBox(
                width: _gutterWidth,
                child: Center(
                  child: Text(
                    'Hora',
                    style: theme.textTheme.labelMedium?.copyWith(
                      color: Colors.grey[600],
                    ),
                  ),
                ),
              ),
              ..._daysOfWeek.map((date) {
                final isToday = _isSameDate(date, DateTime.now());
                return Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      border: Border(left: BorderSide(color: Colors.grey.shade300)),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          _weekdayShort(date.weekday),
                          style: theme.textTheme.labelMedium?.copyWith(
                            color: Colors.grey[700],
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                          decoration: BoxDecoration(
                            color: isToday ? Colors.blue.shade50 : Colors.transparent,
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: Text(
                            '${date.day}',
                            style: theme.textTheme.titleSmall?.copyWith(
                              color: isToday ? Colors.blue : Colors.black,
                              fontWeight: isToday ? FontWeight.bold : FontWeight.w500,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }),
            ],
          ),
        ),

        // Grid de dias y eventos semanales
        Expanded(
          child: Scrollbar(
            controller: _scrollController,
            thumbVisibility: true,
            child: SingleChildScrollView(
              controller: _scrollController,
              child: SizedBox(
                height: totalHeight,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // Columna de horas
                    SizedBox(
                      width: _gutterWidth,
                      child: Column(
                        children: List.generate(totalHours, (i) {
                          final hour = startHour + i;
                          return SizedBox(
                            height: _hourRowHeight,
                            child: Stack(
                              children: [
                                Align(
                                  alignment: Alignment.topCenter,
                                  child: Container(height: 1, color: Colors.grey.shade300),
                                ),
                                Positioned(
                                  top: 2,
                                  right: 8,
                                  child: Text(
                                    _formatHour(hour),
                                    style: theme.textTheme.labelSmall?.copyWith(color: Colors.grey[700]),
                                  ),
                                ),
                              ],
                            ),
                          );
                        }),
                      ),
                    ),

                    // Layout de días y eventos
                    Expanded(
                      child: LayoutBuilder(
                        builder: (context, constraints) {
                          final dayWidth = constraints.maxWidth / 7;
                          return Stack(
                            children: [
                              // Líneas horizontales por cada hora
                              Positioned.fill(
                                child: Column(
                                  children: List.generate(totalHours, (i) {
                                    return Container(
                                      height: _hourRowHeight,
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        border: Border(
                                          top: BorderSide(color: Colors.grey.shade300),
                                        ),
                                      ),
                                    );
                                  }),
                                ),
                              ),
                              // Separadores verticales por día
                              Positioned.fill(
                                child: Row(
                                  children: List.generate(7, (d) {
                                    return Expanded(
                                      child: Container(
                                        decoration: BoxDecoration(
                                          border: Border(left: BorderSide(color: Colors.grey.shade300)),
                                        ),
                                      ),
                                    );
                                  }),
                                ),
                              ),
                              // Eventos
                              ..._events.map((e) {
                                if (e.endHour <= startHour || e.startHour >= endHour) {
                                  return const SizedBox.shrink();
                                }
                                final visibleStart = e.startHour.clamp(startHour.toDouble(), endHour.toDouble());
                                final visibleEnd = e.endHour.clamp(startHour.toDouble(), endHour.toDouble());
                                final top = (visibleStart - startHour) * _hourRowHeight;
                                final cardWidth = dayWidth - 12;
                                final contentHeight = _computeEventContentHeight(e, cardWidth, theme);
                                final height = math.max((visibleEnd - visibleStart) * _hourRowHeight, contentHeight);
                                final left = e.day * dayWidth;
                                return Positioned(
                                  top: top + 2,
                                  left: left + 6,
                                  width: cardWidth,
                                  height: height - 4,
                                  child: _EventCard(event: e),
                                );
                              }),
                            ],
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  // Calcula la altura necesaria para el cuadro del evento
  double _computeEventContentHeight(_CalendarEvent e, double cardWidth, ThemeData theme) {
    const double horizontalPadding = 16;
    const double iconSize = 16;
    const double iconSpacing = 8;
    final double contentWidth = cardWidth - horizontalPadding - iconSize - iconSpacing;

    final titleStyle = theme.textTheme.labelMedium?.copyWith(
          color: Colors.black,
          fontWeight: FontWeight.w700,
        ) ?? const TextStyle(fontSize: 14, fontWeight: FontWeight.w700);

    final descStyle = theme.textTheme.bodySmall?.copyWith(
          color: Colors.black87,
          height: 1.2,
        ) ?? const TextStyle(fontSize: 12, height: 1.2);

    final titleTP = TextPainter(
      text: TextSpan(text: e.title, style: titleStyle),
      textDirection: TextDirection.ltr,
      maxLines: 1,
    )..layout(maxWidth: contentWidth);

    final descTP = TextPainter(
      text: TextSpan(text: e.description, style: descStyle),
      textDirection: TextDirection.ltr,
      maxLines: null,
    )..layout(maxWidth: contentWidth);

    const double verticalPadding = 16;
    const double gap = 2;

    final contentHeight = verticalPadding +
        math.max(iconSize, titleTP.height) +
        gap +
        descTP.height;

    return math.max(contentHeight, _minEventHeight);
  }

  // Listado de días
  String _weekdayShort(int weekday) {
    switch (weekday) {
      case DateTime.monday:
        return 'Lun';
      case DateTime.tuesday:
        return 'Mar';
      case DateTime.wednesday:
        return 'Mié';
      case DateTime.thursday:
        return 'Jue';
      case DateTime.friday:
        return 'Vie';
      case DateTime.saturday:
        return 'Sáb';
      case DateTime.sunday:
        return 'Dom';
      default:
        return '';
    }
  }

  // Formatea una hora
  String _formatHour(int hour) {
    final h = hour.toString().padLeft(2, '0');
    return '$h:00';
  }

  // Compara dos fechas
  bool _isSameDate(DateTime a, DateTime b) {
    return a.year == b.year && a.month == b.month && a.day == b.day;
  }
}

// Clase que representa un evento
class _CalendarEvent {
  final int day;
  final double startHour;
  final double endHour;
  final String title;
  final String description;
  final IconData icon;
  final Color color;

  const _CalendarEvent({
    required this.day,
    required this.startHour,
    required this.endHour,
    required this.title,
    required this.description,
    required this.icon,
    required this.color,
  });
}

// Componente de un evento
class _EventCard extends StatelessWidget {
  final _CalendarEvent event;
  const _EventCard({required this.event});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: event.color,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.black12),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(event.icon, size: 18, color: Colors.black87),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  event.title,
                  softWrap: true,
                  style: theme.textTheme.labelMedium?.copyWith(
                    color: Colors.black,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  event.description,
                  softWrap: true,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: Colors.black87,
                    height: 1.2,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
