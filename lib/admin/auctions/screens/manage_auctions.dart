import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:responsive_builder/responsive_builder.dart';

import '../../../app/app_colors.dart';
import '../../../app/router/route_paths.dart';
import '../../../features/auctions/providers/auction_provider.dart';
import '../../../features/auctions/models/auction.dart';
import '../../../features/catalog/providers/catalog_provider.dart';
import '../../widgets/admin_sidebar.dart';

class ManageAuctionsScreen extends StatelessWidget {
  const ManageAuctionsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final auctions = context.read<AuctionProvider>();
    return ResponsiveBuilder(builder: (context, sizing) {
      final compact = sizing.isMobile || sizing.isTablet;
      return Scaffold(
        backgroundColor: AppColors.canvas,
        appBar: compact
            ? AppBar(
                backgroundColor: AppColors.forestDeep,
                foregroundColor: Colors.white,
                title: const Text('Auctions'),
              )
            : null,
        drawer: compact
            ? const AdminSidebar(currentRoute: RoutePaths.adminAuctions)
            : null,
        floatingActionButton: FloatingActionButton.extended(
          onPressed: () => _showForm(context),
          backgroundColor: AppColors.clay,
          foregroundColor: Colors.white,
          icon: const Icon(Icons.gavel),
          label: const Text('Create auction'),
        ),
        body: Row(children: [
          if (!compact)
            const SizedBox(
              width: 280,
              child: AdminSidebar(currentRoute: RoutePaths.adminAuctions),
            ),
          Expanded(
            child: Padding(
              padding: EdgeInsets.all(compact ? 16 : 32),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Auction management', style: Theme.of(context).textTheme.headlineMedium),
                  const SizedBox(height: 8),
                  const Text('Create, edit, publish, and close auction listings.', style: TextStyle(color: AppColors.mutedInk)),
                  const SizedBox(height: 24),
                  Expanded(
                    child: StreamBuilder<List<AuctionProduct>>(
                      stream: auctions.watchAllAuctions(),
                      builder: (context, snapshot) {
                        if (snapshot.hasError) {
                          return Center(
                            child: Text(_errorText(snapshot.error)),
                          );
                        }
                        if (!snapshot.hasData) {
                          return const Center(child: CircularProgressIndicator());
                        }
                        final items = snapshot.data!;
                        if (items.isEmpty) {
                          return const Center(child: Text('No auctions created yet.'));
                        }
                        return Card(
                          clipBehavior: Clip.antiAlias,
                          child: SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: DataTable(
                              columns: const [
                                DataColumn(label: Text('Item')),
                                DataColumn(label: Text('Category')),
                                DataColumn(label: Text('Current bid')),
                                DataColumn(label: Text('Ends')),
                                DataColumn(label: Text('Status')),
                                DataColumn(label: Text('Actions')),
                              ],
                              rows: items.map((auction) => DataRow(cells: [
                                DataCell(SizedBox(width: 230, child: Text(auction.name, maxLines: 2, overflow: TextOverflow.ellipsis))),
                                DataCell(Text(auction.category)),
                                DataCell(Text('৳${auction.currentBid.toStringAsFixed(2)}')),
                                DataCell(Text(_formatDate(auction.endTime))),
                                DataCell(Text(auction.published ? 'Published' : 'Draft')),
                                DataCell(Row(mainAxisSize: MainAxisSize.min, children: [
                                  IconButton(
                                    tooltip: 'Edit auction',
                                    onPressed: () => _showForm(context, auction: auction),
                                    icon: const Icon(Icons.edit_outlined),
                                  ),
                                  IconButton(
                                    tooltip: 'Delete auction',
                                    onPressed: () => _delete(context, auction),
                                    icon: const Icon(Icons.delete_outline, color: AppColors.clay),
                                  ),
                                ])),
                              ])).toList(),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        ]),
      );
    });
  }

  Future<void> _showForm(BuildContext context, {AuctionProduct? auction}) async {
    final saved = await showDialog<bool>(
      context: context,
      builder: (_) => _AuctionFormDialog(auction: auction),
    );
    if (saved == true && context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Auction saved.')));
    }
  }

  Future<void> _delete(BuildContext context, AuctionProduct auction) async {
    final approved = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Delete auction?'),
        content: Text('“${auction.name}” will be removed.'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(dialogContext, false), child: const Text('Cancel')),
          FilledButton(onPressed: () => Navigator.pop(dialogContext, true), child: const Text('Delete')),
        ],
      ),
    );
    if (approved != true || !context.mounted) return;
    try {
      await context.read<AuctionProvider>().deleteAuction(auction);
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Auction deleted.')));
      }
    } catch (_) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Could not delete auction.')));
      }
    }
  }

  String _errorText(Object? error) => error is FirebaseException && error.code == 'permission-denied'
      ? 'Your account is not authorized to manage auctions.'
      : 'Could not load auctions. Check your Firebase setup and connection.';

  String _formatDate(DateTime value) =>
      '${value.year}-${value.month.toString().padLeft(2, '0')}-${value.day.toString().padLeft(2, '0')}';
}

class _AuctionFormDialog extends StatefulWidget {
  const _AuctionFormDialog({this.auction});
  final AuctionProduct? auction;

  @override
  State<_AuctionFormDialog> createState() => _AuctionFormDialogState();
}

class _AuctionFormDialogState extends State<_AuctionFormDialog> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _name;
  late final TextEditingController _condition;
  late final TextEditingController _basePrice;
  late final TextEditingController _description;
  final List<XFile> _images = [];
  final _picker = ImagePicker();
  late DateTime _endTime;
  String? _category;
  bool _published = true;
  bool _saving = false;

  @override
  void initState() {
    super.initState();
    final auction = widget.auction;
    _name = TextEditingController(text: auction?.name ?? '');
    _condition = TextEditingController(text: auction?.condition ?? '');
    _basePrice = TextEditingController(text: auction?.basePrice.toString() ?? '');
    _description = TextEditingController(text: auction?.description ?? '');
    _category = auction?.category;
    _endTime = auction?.endTime ?? DateTime.now().add(const Duration(days: 7));
    _published = auction?.published ?? true;
  }

  @override
  void dispose() {
    _name.dispose();
    _condition.dispose();
    _basePrice.dispose();
    _description.dispose();
    super.dispose();
  }

  Future<void> _pickImages() async {
    try {
      final images = await _picker.pickMultiImage(imageQuality: 85);
      if (!mounted || images.isEmpty) return;
      if (_images.length + images.length > 10) {
        _message('Choose up to 10 images.');
        return;
      }
      setState(() => _images.addAll(images));
    } catch (_) {
      _message('Image picker is unavailable.');
    }
  }

  Future<void> _chooseEndTime() async {
    final date = await showDatePicker(
      context: context,
      initialDate: _endTime.isAfter(DateTime.now()) ? _endTime : DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );
    if (!mounted || date == null) return;
    final time = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.fromDateTime(_endTime),
    );
    if (time == null) return;
    setState(() => _endTime = DateTime(date.year, date.month, date.day, time.hour, time.minute));
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;
    final category = _category;
    if (category == null) {
      _message('Select a category.');
      return;
    }
    if (_endTime.isBefore(DateTime.now())) {
      _message('Choose a future end time.');
      return;
    }
    final current = widget.auction;
    if (_images.isEmpty && (current?.galleryImages.isEmpty ?? true)) {
      _message('Add at least one auction image.');
      return;
    }
    setState(() => _saving = true);
    try {
      await context.read<AuctionProvider>().saveAuction(
        auction: AuctionProduct(
          id: current?.id ?? '',
          name: _name.text,
          category: category,
          condition: _condition.text,
          imageUrl: current?.imageUrl ?? '',
          galleryImages: current?.galleryImages ?? const [],
          basePrice: double.parse(_basePrice.text),
          currentBid: current?.currentBid ?? 0,
          endTime: _endTime,
          totalBids: current?.totalBids ?? 0,
          description: _description.text,
          published: _published,
        ),
        newImages: _images,
      );
      if (mounted) Navigator.pop(context, true);
    } catch (error) {
      if (!mounted) return;
      setState(() => _saving = false);
      _message(error.toString().contains('permission-denied')
          ? 'This account is not authorized to manage auctions.'
          : 'Auction save failed. Check the image, connection, and Firebase Storage setup.');
    }
  }

  void _message(String message) => ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));

  @override
  Widget build(BuildContext context) => AlertDialog(
    title: Text(widget.auction == null ? 'Create auction' : 'Edit auction'),
    content: SizedBox(
      width: 560,
      child: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(mainAxisSize: MainAxisSize.min, children: [
            TextFormField(
              controller: _name,
              maxLength: 160,
              decoration: const InputDecoration(labelText: 'Item name'),
              validator: (value) => value == null || value.trim().isEmpty ? 'Enter an item name.' : null,
            ),
            const SizedBox(height: 12),
            StreamBuilder<List<String>>(
              stream: context.read<CatalogProvider>().watchActiveCategories(),
              builder: (context, snapshot) {
                final categories = [...(snapshot.data ?? const <String>[])];
                if (_category != null && !categories.contains(_category)) {
                  categories.add(_category!);
                }
                return DropdownButtonFormField<String>(
                  value: categories.contains(_category) ? _category : null,
                  decoration: const InputDecoration(labelText: 'Category'),
                  items: categories.map((name) => DropdownMenuItem(value: name, child: Text(name))).toList(),
                  onChanged: (value) => setState(() => _category = value),
                  validator: (value) => value == null ? 'Select a category.' : null,
                );
              },
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: _condition,
              maxLength: 40,
              decoration: const InputDecoration(labelText: 'Condition'),
              validator: (value) => value == null || value.trim().isEmpty ? 'Enter a condition.' : null,
            ),
            TextFormField(
              controller: _basePrice,
              keyboardType: const TextInputType.numberWithOptions(decimal: true),
              decoration: const InputDecoration(labelText: 'Starting bid (BDT)'),
              validator: (value) {
                final amount = double.tryParse(value?.trim() ?? '');
                return amount == null || amount < 0 ? 'Enter a valid amount.' : null;
              },
            ),
            const SizedBox(height: 12),
            ListTile(
              contentPadding: EdgeInsets.zero,
              title: const Text('Auction end time'),
              subtitle: Text(_endTime.toLocal().toString().substring(0, 16)),
              trailing: const Icon(Icons.calendar_month_outlined),
              onTap: _saving ? null : _chooseEndTime,
            ),
            TextFormField(
              controller: _description,
              maxLength: 4000,
              maxLines: 4,
              decoration: const InputDecoration(labelText: 'Description'),
            ),
            Align(
              alignment: Alignment.centerLeft,
              child: OutlinedButton.icon(
                onPressed: _saving ? null : _pickImages,
                icon: const Icon(Icons.add_photo_alternate_outlined),
                label: Text('Choose images (${_images.length}/10)'),
              ),
            ),
            if (_images.isNotEmpty)
              Wrap(
                spacing: 8,
                children: _images.map((image) => InputChip(
                  label: Text(image.name, overflow: TextOverflow.ellipsis),
                  onDeleted: _saving ? null : () => setState(() => _images.remove(image)),
                )).toList(),
              ),
            SwitchListTile(
              contentPadding: EdgeInsets.zero,
              title: const Text('Published'),
              value: _published,
              onChanged: _saving ? null : (value) => setState(() => _published = value),
            ),
          ]),
        ),
      ),
    ),
    actions: [
      TextButton(onPressed: _saving ? null : () => Navigator.pop(context), child: const Text('Cancel')),
      FilledButton(
        onPressed: _saving ? null : _save,
        style: FilledButton.styleFrom(backgroundColor: AppColors.clay),
        child: _saving
            ? const SizedBox(width: 18, height: 18, child: CircularProgressIndicator(strokeWidth: 2))
            : const Text('Save auction'),
      ),
    ],
  );
}
