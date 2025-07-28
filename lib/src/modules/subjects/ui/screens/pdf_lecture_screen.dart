// lib/src/modules/subjects/presentation/screens/pdf_lecture_screen.dart
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';

import '../../data/models/lecture.dart' show Lecture;
import '../widgets/completion_button.dart';
import '../widgets/lecture_header.dart';

class PdfLectureScreen extends StatefulWidget {
  final Lecture lecture;

  const PdfLectureScreen({super.key, required this.lecture});

  @override
  State<PdfLectureScreen> createState() => _PdfLectureScreenState();
}

class _PdfLectureScreenState extends State<PdfLectureScreen> {
  bool _isCompletionLoading = false;
  bool _isPdfLoading = true;
  bool _isFullScreen = false;
  String? _localPdfPath;
  String? _error;
  int _currentPage = 0;
  int _totalPages = 0;
  PDFViewController? _pdfViewController;

  @override
  void initState() {
    super.initState();
    _downloadAndLoadPdf();
  }

  Future<void> _downloadAndLoadPdf() async {}

  Future<void> _markAsCompleted() async {
    setState(() {
      _isCompletionLoading = true;
    });

    // Simulate API call
    await Future.delayed(const Duration(seconds: 1));

    // widget.lecture.markAsCompleted();

    setState(() {
      _isCompletionLoading = false;
    });

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('تم تحديد المحاضرة كمكتملة'),
        ),
      );
    }
  }

  void _toggleFullScreen() {
    setState(() {
      _isFullScreen = !_isFullScreen;
    });

    if (_isFullScreen) {
      // إخفاء شريط الحالة وشريط التنقل
      SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
    } else {
      // إظهار شريط الحالة وشريط التنقل
      SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
    }
  }

  void _goToPreviousPage() {
    if (_currentPage > 0) {
      _pdfViewController?.setPage(_currentPage - 1);
    }
  }

  void _goToNextPage() {
    if (_currentPage < _totalPages - 1) {
      _pdfViewController?.setPage(_currentPage + 1);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isFullScreen) {
      return _buildFullScreenView();
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('محاضرة PDF'),
        actions: [
          if (_localPdfPath != null) ...[
            IconButton(
              icon: const Icon(Icons.fullscreen),
              onPressed: _toggleFullScreen,
              tooltip: 'ملء الشاشة',
            ),
            IconButton(
              icon: const Icon(Icons.refresh),
              onPressed: _downloadAndLoadPdf,
              tooltip: 'إعادة تحميل',
            ),
          ],
        ],
      ),
      body: Column(
        children: [
          // Header with lecture info
          Padding(
            padding: const EdgeInsets.all(16),
            child: LectureHeader(
              lecture: widget.lecture,
              actionButton: CompletionButton(
                lecture: widget.lecture,
                onComplete: _markAsCompleted,
                isLoading: _isCompletionLoading,
              ),
            ),
          ),

          // PDF Viewer
          Expanded(
            child: _buildPdfContent(),
          ),

          // Navigation controls
          if (_localPdfPath != null && _totalPages > 0)
            _buildNavigationControls(),
        ],
      ),
    );
  }

  Widget _buildFullScreenView() {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          // PDF Viewer in fullscreen
          _buildPdfContent(),

          // Floating controls
          Positioned(
            top: MediaQuery.of(context).padding.top + 10,
            right: 10,
            child: Container(
              decoration: BoxDecoration(
                color: Colors.black54,
                borderRadius: BorderRadius.circular(25),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    icon:
                        const Icon(Icons.fullscreen_exit, color: Colors.white),
                    onPressed: _toggleFullScreen,
                    tooltip: 'الخروج من ملء الشاشة',
                  ),
                  IconButton(
                    icon: const Icon(Icons.refresh, color: Colors.white),
                    onPressed: _downloadAndLoadPdf,
                    tooltip: 'إعادة تحميل',
                  ),
                ],
              ),
            ),
          ),

          // Page indicator
          if (_totalPages > 0)
            Positioned(
              bottom: MediaQuery.of(context).padding.bottom + 20,
              left: 0,
              right: 0,
              child: Center(
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  decoration: BoxDecoration(
                    color: Colors.black54,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    'صفحة ${_currentPage + 1} من $_totalPages',
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ),
            ),

          // Navigation arrows
          if (_totalPages > 0) ...[
            // Previous page arrow
            Positioned(
              left: 20,
              top: 0,
              bottom: 0,
              child: Center(
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.black54,
                    borderRadius: BorderRadius.circular(25),
                  ),
                  child: IconButton(
                    onPressed: _currentPage > 0 ? _goToPreviousPage : null,
                    icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
                    tooltip: 'الصفحة السابقة',
                  ),
                ),
              ),
            ),

            // Next page arrow
            Positioned(
              right: 20,
              top: 0,
              bottom: 0,
              child: Center(
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.black54,
                    borderRadius: BorderRadius.circular(25),
                  ),
                  child: IconButton(
                    onPressed:
                        _currentPage < _totalPages - 1 ? _goToNextPage : null,
                    icon: const Icon(Icons.arrow_forward_ios,
                        color: Colors.white),
                    tooltip: 'الصفحة التالية',
                  ),
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildPdfContent() {
    if (_isPdfLoading) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(
              color: _isFullScreen ? Colors.white : null,
            ),
            const SizedBox(height: 16),
            Text(
              'جاري تحميل الملف...',
              style: TextStyle(
                color: _isFullScreen ? Colors.white : null,
              ),
            ),
          ],
        ),
      );
    }

    if (_error != null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.error_outline,
              size: 64,
              color: _isFullScreen
                  ? Colors.white
                  : Theme.of(context).colorScheme.error,
            ),
            const SizedBox(height: 16),
            Text(
              _error!,
              style: TextStyle(
                color: _isFullScreen
                    ? Colors.white
                    : Theme.of(context).colorScheme.error,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _downloadAndLoadPdf,
              style: _isFullScreen
                  ? ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      foregroundColor: Colors.black,
                    )
                  : null,
              child: const Text('إعادة المحاولة'),
            ),
          ],
        ),
      );
    }

    if (_localPdfPath == null) {
      return Center(
        child: Text(
          'لا يوجد ملف للعرض',
          style: TextStyle(
            color: _isFullScreen ? Colors.white : null,
          ),
        ),
      );
    }

    return Container(
      margin: _isFullScreen ? EdgeInsets.zero : const EdgeInsets.all(8),
      decoration: _isFullScreen
          ? null
          : BoxDecoration(
              border: Border.all(color: Colors.grey.shade300),
              borderRadius: BorderRadius.circular(8),
            ),
      child: ClipRRect(
        borderRadius:
            _isFullScreen ? BorderRadius.zero : BorderRadius.circular(8),
        child: PDFView(
          filePath: _localPdfPath!,
          enableSwipe: true,
          swipeHorizontal: false,
          autoSpacing: false,
          pageFling: true,
          pageSnap: true,
          defaultPage: _currentPage,
          fitPolicy: FitPolicy.BOTH,
          preventLinkNavigation: false,
          backgroundColor: _isFullScreen ? Colors.black : Colors.white,
          onRender: (pages) {
            setState(() {
              _totalPages = pages ?? 0;
            });
          },
          onError: (error) {
            setState(() {
              _error = 'خطأ في عرض الملف: $error';
            });
          },
          onPageError: (page, error) {
            setState(() {
              _error = 'خطأ في الصفحة $page: $error';
            });
          },
          onViewCreated: (PDFViewController pdfViewController) {
            _pdfViewController = pdfViewController;
          },
          onPageChanged: (int? page, int? total) {
            setState(() {
              _currentPage = page ?? 0;
            });
          },
        ),
      ),
    );
  }

  Widget _buildNavigationControls() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        border: Border(
          top: BorderSide(
            color: Theme.of(context).colorScheme.outline.withOpacity(0.2),
          ),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Previous page button
          IconButton(
            onPressed: _currentPage > 0 ? _goToPreviousPage : null,
            icon: const Icon(Icons.arrow_back_ios),
            tooltip: 'الصفحة السابقة',
          ),

          // Page indicator
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.primaryContainer,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              'صفحة ${_currentPage + 1} من $_totalPages',
              style: TextStyle(
                color: Theme.of(context).colorScheme.onPrimaryContainer,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),

          // Next page button
          IconButton(
            onPressed: _currentPage < _totalPages - 1 ? _goToNextPage : null,
            icon: const Icon(Icons.arrow_forward_ios),
            tooltip: 'الصفحة التالية',
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
    if (_localPdfPath != null) {
      try {
        File(_localPdfPath!).deleteSync();
      } catch (e) {
        // تجاهل الأخطاء في التنظيف
      }
    }
    super.dispose();
  }
}
