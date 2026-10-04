import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:responsive_builder/responsive_builder.dart';
import '../../../app/app_colors.dart';
import '../../../app/router/route_paths.dart';
import '../../../pages/auction/models/auction_product.dart';
import '../../widgets/admin_sidebar.dart';

class ManageAuctionsScreen extends StatefulWidget {
  const ManageAuctionsScreen({super.key});

  @override
  State<ManageAuctionsScreen> createState() => _ManageAuctionsScreenState();
}

class _ManageAuctionsScreenState extends State<ManageAuctionsScreen> {
  final List<AuctionProduct> _auctions = List.from(demoAuctions);

  @override
  Widget build(BuildContext context) {
    return ResponsiveBuilder(
      builder: (context, sizingInformation) {
        bool isMobile = sizingInformation.isMobile || sizingInformation.isTablet;

        return Scaffold(
          backgroundColor: AppColors.canvas,
          appBar: isMobile
              ? AppBar(
                  backgroundColor: AppColors.forestDeep,
                  title: const Text('Manage Auctions', style: TextStyle(color: Colors.white)),
                  iconTheme: const IconThemeData(color: Colors.white),
                )
              : null,
          drawer: isMobile ? const AdminSidebar(currentRoute: RoutePaths.adminAuctions) : null,
          floatingActionButton: FloatingActionButton(
            onPressed: () => _showAuctionForm(context),
            backgroundColor: AppColors.clay,
            child: const Icon(Icons.add, color: Colors.white),
          ),
          body: Row(
            children: [
              if (!isMobile)
                const SizedBox(
                  width: 280,
                  child: AdminSidebar(currentRoute: RoutePaths.adminAuctions),
                ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(30),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'Auction Management',
                            style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: AppColors.forestDeep),
                          ),
                          if (!isMobile)
                            ElevatedButton.icon(
                              onPressed: () => _showAuctionForm(context),
                              icon: const Icon(Icons.gavel),
                              label: const Text('Start New Auction'),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppColors.clay,
                                foregroundColor: Colors.white,
                                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                              ),
                            ),
                        ],
                      ),
                      const SizedBox(height: 30),
                      Expanded(
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(15),
                            boxShadow: [
                              BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, 5)),
                            ],
                          ),
                          child: _buildAuctionTable(isMobile),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildAuctionTable(bool isMobile) {
    return SingleChildScrollView(
      scrollDirection: Axis.vertical,
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: DataTable(
          columnSpacing: isMobile ? 20 : 40,
          columns: const [
            DataColumn(label: Text('Item')),
            DataColumn(label: Text('Current Bid')),
            DataColumn(label: Text('End Time')),
            DataColumn(label: Text('Bids')),
            DataColumn(label: Text('Actions')),
          ],
          rows: _auctions.map((auction) {
            return DataRow(cells: [
              DataCell(SizedBox(width: 200, child: Text(auction.name, overflow: TextOverflow.ellipsis))),
              DataCell(Text('৳${auction.currentBid}')),
              DataCell(Text(auction.endTime.toString().split('.')[0])),
              DataCell(Text(auction.totalBids.toString())),
              DataCell(
                Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.edit_outlined, color: Colors.blue),
                      onPressed: () => _showAuctionForm(context, auction: auction),
                    ),
                    IconButton(
                      icon: const Icon(Icons.delete_outline, color: Colors.red),
                      onPressed: () {
                        setState(() {
                          _auctions.removeWhere((a) => a.id == auction.id);
                        });
                      },
                    ),
                  ],
                ),
              ),
            ]);
          }).toList(),
        ),
      ),
    );
  }

  void _showAuctionForm(BuildContext context, {AuctionProduct? auction}) {
    showDialog(
      context: context,
      builder: (context) => AuctionFormDialog(auction: auction),
    );
  }
}

class AuctionFormDialog extends StatefulWidget {
  final AuctionProduct? auction;
  const AuctionFormDialog({super.key, this.auction});

  @override
  State<AuctionFormDialog> createState() => _AuctionFormDialogState();
}

class _AuctionFormDialogState extends State<AuctionFormDialog> {
  final _formKey = GlobalKey<FormState>();
  late DateTime _selectedDateTime;
  List<XFile> _selectedImages = [];
  final ImagePicker _picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    _selectedDateTime = widget.auction?.endTime ?? DateTime.now().add(const Duration(days: 7));
  }

  Future<void> _pickImages() async {
    final List<XFile> images = await _picker.pickMultiImage();
    if (images.isNotEmpty) {
      setState(() {
        _selectedImages.addAll(images);
      });
    }
  }

  Future<void> _pickDateTime() async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: _selectedDateTime,
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );

    if (pickedDate != null) {
      final TimeOfDay? pickedTime = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.fromDateTime(_selectedDateTime),
      );

      if (pickedTime != null) {
        setState(() {
          _selectedDateTime = DateTime(
            pickedDate.year,
            pickedDate.month,
            pickedDate.day,
            pickedTime.hour,
            pickedTime.minute,
          );
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(widget.auction == null ? 'Start New Auction' : 'Edit Auction'),
      content: SizedBox(
        width: 600,
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextFormField(
                  initialValue: widget.auction?.name,
                  decoration: const InputDecoration(labelText: 'Item Name', border: OutlineInputBorder()),
                ),
                const SizedBox(height: 15),
                Row(
                  children: [
                    Expanded(
                      child: TextFormField(
                        initialValue: widget.auction?.basePrice.toString(),
                        decoration: const InputDecoration(labelText: 'Starting Bid (৳)', border: OutlineInputBorder()),
                        keyboardType: TextInputType.number,
                      ),
                    ),
                    const SizedBox(width: 15),
                    Expanded(
                      child: ListTile(
                        contentPadding: EdgeInsets.zero,
                        title: const Text('Expiration Time', style: TextStyle(fontSize: 12)),
                        subtitle: Text(
                          '${_selectedDateTime.day}/${_selectedDateTime.month}/${_selectedDateTime.year} ${_selectedDateTime.hour}:${_selectedDateTime.minute.toString().padLeft(2, '0')}',
                        ),
                        trailing: const Icon(Icons.calendar_today_outlined),
                        onTap: _pickDateTime,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                const Text('Auction Images', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                const SizedBox(height: 10),
                Wrap(
                  spacing: 10,
                  runSpacing: 10,
                  children: [
                    if (widget.auction != null && _selectedImages.isEmpty)
                      Container(
                        width: 80,
                        height: 80,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(color: AppColors.line),
                          image: DecorationImage(image: NetworkImage(widget.auction!.imageUrl), fit: BoxFit.cover),
                        ),
                      ),
                    ..._selectedImages.map((image) => Stack(
                          children: [
                            Container(
                              width: 80,
                              height: 80,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                border: Border.all(color: AppColors.line),
                              ),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(10),
                                child: kIsWeb
                                    ? Image.network(image.path, fit: BoxFit.cover)
                                    : Image.file(File(image.path), fit: BoxFit.cover),
                              ),
                            ),
                            Positioned(
                              right: 0,
                              top: 0,
                              child: GestureDetector(
                                onTap: () => setState(() => _selectedImages.remove(image)),
                                child: Container(
                                  padding: const EdgeInsets.all(2),
                                  decoration: const BoxDecoration(color: Colors.red, shape: BoxShape.circle),
                                  child: const Icon(Icons.close, color: Colors.white, size: 14),
                                ),
                              ),
                            ),
                          ],
                        )),
                    GestureDetector(
                      onTap: _pickImages,
                      child: Container(
                        width: 80,
                        height: 80,
                        decoration: BoxDecoration(
                          color: AppColors.canvas,
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(color: AppColors.line),
                        ),
                        child: const Icon(Icons.add_a_photo_outlined, color: AppColors.mutedInk),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 15),
                TextFormField(
                  initialValue: 'UNC condition historical note.',
                  maxLines: 3,
                  decoration: const InputDecoration(labelText: 'Auction Terms/Description', border: OutlineInputBorder()),
                ),
              ],
            ),
          ),
        ),
      ),
      actions: [
        TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
        ElevatedButton(
          onPressed: () => Navigator.pop(context),
          style: ElevatedButton.styleFrom(backgroundColor: AppColors.clay, foregroundColor: Colors.white),
          child: Text(widget.auction == null ? 'Start Auction' : 'Save Changes'),
        ),
      ],
    );
  }
}
