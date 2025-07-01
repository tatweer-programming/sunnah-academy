import 'package:flutter/material.dart';

class MainTestScreen extends StatefulWidget {
  @override
  _MainTestScreenState createState() => _MainTestScreenState();
}

class _MainTestScreenState extends State<MainTestScreen> {
  int _currentIndex = 0;

  final List<Widget> _screens = [
    ButtonsAndInputsScreen(),
    CardsAndListsScreen(),
    ControlsAndIndicatorsScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('اختبار الثيم'),
        actions: [
          IconButton(
            icon: Icon(Icons.settings),
            onPressed: () {},
          ),
          IconButton(
            icon: Icon(Icons.search),
            onPressed: () {},
          ),
        ],
      ),
      body: _screens[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) => setState(() => _currentIndex = index),
        type: BottomNavigationBarType.fixed,
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.touch_app),
            label: 'أزرار ومدخلات',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.view_list),
            label: 'بطاقات وقوائم',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.tune),
            label: 'عناصر تحكم',
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('تم الضغط على الزر العائم!'),
              action: SnackBarAction(
                label: 'تراجع',
                onPressed: () {},
              ),
            ),
          );
        },
        child: Icon(Icons.add),
      ),
    );
  }
}

// الشاشة الأولى: الأزرار والمدخلات
class ButtonsAndInputsScreen extends StatefulWidget {
  @override
  _ButtonsAndInputsScreenState createState() => _ButtonsAndInputsScreenState();
}

class _ButtonsAndInputsScreenState extends State<ButtonsAndInputsScreen> {
  final TextEditingController _textController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _obscurePassword = true;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // عنوان القسم
          Text(
            'الأزرار والمدخلات',
            style: Theme.of(context).textTheme.headlineMedium,
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 24),

          // الأزرار المختلفة
          Card(
            child: Padding(
              padding: EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    'أنواع الأزرار',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {},
                    child: Text('زر مرفوع'),
                  ),
                  SizedBox(height: 8),
                  OutlinedButton(
                    onPressed: () {},
                    child: Text('زر محدد'),
                  ),
                  SizedBox(height: 8),
                  TextButton(
                    onPressed: () {},
                    child: Text('زر نصي'),
                  ),
                  SizedBox(height: 8),
                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton.icon(
                          onPressed: () {},
                          icon: Icon(Icons.favorite),
                          label: Text('زر بأيقونة'),
                        ),
                      ),
                      SizedBox(width: 8),
                      IconButton(
                        onPressed: () {},
                        icon: Icon(Icons.share),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),

          SizedBox(height: 16),

          // حقول النص
          Card(
            child: Padding(
              padding: EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    'حقول الإدخال',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  SizedBox(height: 16),
                  TextField(
                    controller: _textController,
                    decoration: InputDecoration(
                      labelText: 'الاسم',
                      hintText: 'أدخل اسمك هنا',
                      prefixIcon: Icon(Icons.person),
                    ),
                  ),
                  SizedBox(height: 16),
                  TextField(
                    controller: _passwordController,
                    obscureText: _obscurePassword,
                    decoration: InputDecoration(
                      labelText: 'كلمة المرور',
                      hintText: 'أدخل كلمة المرور',
                      prefixIcon: Icon(Icons.lock),
                      suffixIcon: IconButton(
                        icon: Icon(_obscurePassword
                            ? Icons.visibility
                            : Icons.visibility_off),
                        onPressed: () {
                          setState(() {
                            _obscurePassword = !_obscurePassword;
                          });
                        },
                      ),
                    ),
                  ),
                  SizedBox(height: 16),
                  TextField(
                    maxLines: 3,
                    decoration: InputDecoration(
                      labelText: 'الوصف',
                      hintText: 'أدخل وصف مفصل...',
                      prefixIcon: Icon(Icons.description),
                    ),
                  ),
                ],
              ),
            ),
          ),

          SizedBox(height: 16),

          // أزرار الحوار
          Card(
            child: Padding(
              padding: EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    'النوافذ المنبثقة',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () => _showAlertDialog(context),
                    child: Text('عرض نافذة تنبيه'),
                  ),
                  SizedBox(height: 8),
                  OutlinedButton(
                    onPressed: () => _showBottomSheet(context),
                    child: Text('عرض نافذة سفلية'),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showAlertDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('تأكيد العملية'),
        content: Text('هل أنت متأكد من أنك تريد المتابعة؟'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('إلغاء'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context),
            child: Text('موافق'),
          ),
        ],
      ),
    );
  }

  void _showBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (context) => Container(
        padding: EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'خيارات إضافية',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            SizedBox(height: 16),
            ListTile(
              leading: Icon(Icons.edit),
              title: Text('تعديل'),
              onTap: () => Navigator.pop(context),
            ),
            ListTile(
              leading: Icon(Icons.delete),
              title: Text('حذف'),
              onTap: () => Navigator.pop(context),
            ),
            ListTile(
              leading: Icon(Icons.share),
              title: Text('مشاركة'),
              onTap: () => Navigator.pop(context),
            ),
          ],
        ),
      ),
    );
  }
}

// الشاشة الثانية: البطاقات والقوائم
class CardsAndListsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: EdgeInsets.all(16),
      child: Column(
        children: [
          Text(
            'البطاقات والقوائم',
            style: Theme.of(context).textTheme.headlineMedium,
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 24),

          // بطاقات مختلفة
          Card(
            child: Padding(
              padding: EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      CircleAvatar(
                        backgroundColor: Theme.of(context).colorScheme.primary,
                        child: Icon(Icons.person, color: Colors.white),
                      ),
                      SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'أحمد محمد',
                              style: Theme.of(context).textTheme.titleMedium,
                            ),
                            Text(
                              'مطور تطبيقات',
                              style: Theme.of(context).textTheme.bodySmall,
                            ),
                          ],
                        ),
                      ),
                      IconButton(
                        icon: Icon(Icons.more_vert),
                        onPressed: () {},
                      ),
                    ],
                  ),
                  SizedBox(height: 12),
                  Text(
                    'هذا مثال على بطاقة تحتوي على معلومات المستخدم مع إمكانية التفاعل معها.',
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                  SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      TextButton(
                        onPressed: () {},
                        child: Text('إلغاء'),
                      ),
                      SizedBox(width: 8),
                      ElevatedButton(
                        onPressed: () {},
                        child: Text('موافق'),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),

          SizedBox(height: 16),

          // قائمة العناصر
          Card(
            child: Column(
              children: [
                Padding(
                  padding: EdgeInsets.all(16),
                  child: Text(
                    'قائمة المهام',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                ),
                Divider(),
                ...List.generate(
                    5,
                    (index) => ListTile(
                          leading: CircleAvatar(
                            child: Text('${index + 1}'),
                          ),
                          title: Text('مهمة رقم ${index + 1}'),
                          subtitle: Text('وصف المهمة ${index + 1}'),
                          trailing: Icon(Icons.arrow_forward_ios),
                          onTap: () {},
                        )),
              ],
            ),
          ),

          SizedBox(height: 16),

          // بطاقة مع صورة
          Card(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Container(
                  height: 150,
                  decoration: BoxDecoration(
                    color:
                        Theme.of(context).colorScheme.primary.withOpacity(0.1),
                    borderRadius:
                        BorderRadius.vertical(top: Radius.circular(8)),
                  ),
                  child: Icon(
                    Icons.image,
                    size: 64,
                    color:
                        Theme.of(context).colorScheme.primary.withOpacity(0.5),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'عنوان البطاقة',
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                      SizedBox(height: 8),
                      Text(
                        'هذا نص تجريبي لعرض شكل البطاقة مع الصورة والنص والأزرار.',
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                      SizedBox(height: 16),
                      Row(
                        children: [
                          Chip(
                            label: Text('تسمية 1'),
                          ),
                          SizedBox(width: 8),
                          Chip(
                            label: Text('تسمية 2'),
                          ),
                        ],
                      ),
                    ],
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

// الشاشة الثالثة: عناصر التحكم والمؤشرات
class ControlsAndIndicatorsScreen extends StatefulWidget {
  @override
  _ControlsAndIndicatorsScreenState createState() =>
      _ControlsAndIndicatorsScreenState();
}

class _ControlsAndIndicatorsScreenState
    extends State<ControlsAndIndicatorsScreen> with TickerProviderStateMixin {
  bool _switchValue = true;
  bool _checkboxValue = true;
  int _radioValue = 1;
  double _sliderValue = 50;
  bool _loading = false;
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: EdgeInsets.all(16),
      child: Column(
        children: [
          Text(
            'عناصر التحكم والمؤشرات',
            style: Theme.of(context).textTheme.headlineMedium,
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 24),

          // عناصر التحكم
          Card(
            child: Padding(
              padding: EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'عناصر التحكم',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  SizedBox(height: 16),

                  // Switch
                  SwitchListTile(
                    title: Text('تفعيل الإشعارات'),
                    subtitle: Text('استقبال إشعارات التطبيق'),
                    value: _switchValue,
                    onChanged: (value) => setState(() => _switchValue = value),
                  ),

                  // Checkbox
                  CheckboxListTile(
                    title: Text('موافق على الشروط والأحكام'),
                    subtitle: Text('يجب الموافقة للمتابعة'),
                    value: _checkboxValue,
                    onChanged: (value) =>
                        setState(() => _checkboxValue = value!),
                  ),

                  SizedBox(height: 16),
                  Text('اختر خيار:',
                      style: Theme.of(context).textTheme.titleMedium),

                  // Radio Buttons
                  RadioListTile<int>(
                    title: Text('الخيار الأول'),
                    value: 1,
                    groupValue: _radioValue,
                    onChanged: (value) => setState(() => _radioValue = value!),
                  ),
                  RadioListTile<int>(
                    title: Text('الخيار الثاني'),
                    value: 2,
                    groupValue: _radioValue,
                    onChanged: (value) => setState(() => _radioValue = value!),
                  ),
                  RadioListTile<int>(
                    title: Text('الخيار الثالث'),
                    value: 3,
                    groupValue: _radioValue,
                    onChanged: (value) => setState(() => _radioValue = value!),
                  ),
                ],
              ),
            ),
          ),

          // Slider
          Card(
            child: Padding(
              padding: EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'شريط التمرير',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  SizedBox(height: 8),
                  Text('القيمة: ${_sliderValue.round()}'),
                  Slider(
                    value: _sliderValue,
                    min: 0,
                    max: 100,
                    divisions: 10,
                    label: _sliderValue.round().toString(),
                    onChanged: (value) => setState(() => _sliderValue = value),
                  ),
                ],
              ),
            ),
          ),

          // مؤشرات التقدم
          Card(
            child: Padding(
              padding: EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    'مؤشرات التقدم',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  SizedBox(height: 16),
                  Text('مؤشر خطي:'),
                  SizedBox(height: 8),
                  LinearProgressIndicator(value: 0.7),
                  SizedBox(height: 16),
                  Text('مؤشر دائري:'),
                  SizedBox(height: 8),
                  Row(
                    children: [
                      CircularProgressIndicator(value: 0.7),
                      SizedBox(width: 20),
                      CircularProgressIndicator(),
                    ],
                  ),
                  SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: _loading ? null : _simulateLoading,
                    child: _loading
                        ? Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              SizedBox(
                                width: 16,
                                height: 16,
                                child:
                                    CircularProgressIndicator(strokeWidth: 2),
                              ),
                              SizedBox(width: 8),
                              Text('جاري التحميل...'),
                            ],
                          )
                        : Text('بدء التحميل'),
                  ),
                ],
              ),
            ),
          ),

          // Tabs
          Card(
            child: Column(
              children: [
                TabBar(
                  controller: _tabController,
                  tabs: [
                    Tab(text: 'التبويب 1'),
                    Tab(text: 'التبويب 2'),
                    Tab(text: 'التبويب 3'),
                  ],
                ),
                Container(
                  height: 200,
                  child: TabBarView(
                    controller: _tabController,
                    children: [
                      Center(child: Text('محتوى التبويب الأول')),
                      Center(child: Text('محتوى التبويب الثاني')),
                      Center(child: Text('محتوى التبويب الثالث')),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _simulateLoading() {
    setState(() => _loading = true);
    Future.delayed(Duration(seconds: 3), () {
      if (mounted) setState(() => _loading = false);
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }
}
