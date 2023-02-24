import 'package:flutter/material.dart';
import 'package:pdf/pdf.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';
import 'package:pdf/widgets.dart' as pw;
import 'package:image_picker/image_picker.dart';
import 'package:signature/signature.dart';
import 'package:image_painter/image_painter.dart';

class User {
  final String name;
  final String age;

  const User({required this.name, required this.age});
}

class CreateContract extends StatefulWidget {
  const CreateContract({super.key});

  @override
  State<CreateContract> createState() => _CreateContractState();
}

class _CreateContractState extends State<CreateContract> {
  String _name = '';
  String _firstName = '';
  late Uint8List renterSignature;
  late Uint8List etatsDesLieux;

  final SignatureController _controller = SignatureController(
    penStrokeWidth: 5,
    penColor: Colors.red,
    exportBackgroundColor: Colors.blue,
  );
  Future<Directory?> getDirectoryImage() async {
    Directory? directory;
    if (Platform.isIOS) {
      directory = await getApplicationDocumentsDirectory();
    } else {
      directory = Directory('/storage/emulated/0/Download');

      if (!await directory.exists()) {
        directory = await getExternalStorageDirectory();
      }
    }
    return directory;
  }

  Future<void> generatorPdf(
      {required String nom, required String prenom}) async {
    final font = await rootBundle.load("fonts/roboto-medium.ttf");
    final ttf = pw.Font.ttf(font);

    final pdf = pw.Document();
    final headers = ['Le locataire', 'Le loueur'];
    final users = [
      "signature précédée de la mention manuscrite bon pour accord ",
      "signature précédée de la mention manuscrite bon pour accord "
    ];

    final datas = [
      [
        "signature précédée de la mention manuscrite bon pour accord ",
        "signature précédée de la mention manuscrite bon pour accord "
      ]
    ];

    //final datas = users.map((user) => [user.name, user.age]).toList();

    //debut de test

    final ImagePicker imagePicker = ImagePicker();

    //pick image from gallery, it will return XFile
    final XFile? imagePicked =
        await imagePicker.pickImage(source: ImageSource.gallery);

    //Convert image path to file
    File imagePickedPathConvertedToFile = File(imagePicked!.path);

    // Convert file to bytes
    Uint8List imagePickedPathConvertedTobytes =
        await imagePickedPathConvertedToFile.readAsBytes();

    pdf.addPage(
      pw.MultiPage(
          build: (pw.Context context) => [
                pw.Center(
                    child: pw.Text("Contrat de location de voiture",
                        style: pw.TextStyle(
                            color: const PdfColor(0.2, 0.4, 0.4, 1),
                            font: ttf,
                            fontSize: 20))),
                pw.SizedBox(height: 20),
                pw.Column(
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  children: [
                    pw.Text('Entre les soussignés :',
                        style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                    pw.Text(
                      'Monsieur ---, né le --- à --- de nationalité ---, demaurant ---.',
                    )
                  ],
                ),
                pw.SizedBox(
                  height: 10,
                ),
                pw.Container(
                    width: 500,
                    decoration: const pw.BoxDecoration(),
                    child: pw.Column(
                        crossAxisAlignment: pw.CrossAxisAlignment.end,
                        children: [
                          pw.Text(
                            "$_name $_firstName",
                          ),
                          pw.Text(
                            "D'une part,",
                          )
                        ])),
                pw.Column(
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  children: [
                    pw.Text('Et :',
                        style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                    pw.Text(
                      'Monsieur ---, né le --- à --- de nationalité ---, demaurant ---.',
                    )
                  ],
                ),
                pw.Container(
                    width: 500,
                    decoration: const pw.BoxDecoration(),
                    child: pw.Column(
                        crossAxisAlignment: pw.CrossAxisAlignment.end,
                        children: [
                          pw.Text(
                            "Ci après le \"Locataire\",",
                          ),
                          pw.Text(
                            "D'autre part,",
                          )
                        ])),
                pw.SizedBox(height: 10),
                pw.Container(
                    width: 500,
                    child: pw.Text(
                        'Le loueur et le locataire étant ensemble désignés les "parties" et individuellement une "partie"')),
                pw.SizedBox(height: 10),
                pw.Column(
                    crossAxisAlignment: pw.CrossAxisAlignment.start,
                    children: [
                      pw.Text('IL A ETE CONVENU CE QUI SUIT ;'),
                      pw.SizedBox(height: 10),
                      pw.Text("1.1 - Nature et date d'effet du contrat ",
                          style: const pw.TextStyle(
                              color: PdfColor(0.2, 0.4, 0.4, 1))),
                      pw.SizedBox(height: 10),
                      pw.Text(
                          "Le loueur met à disposition du locataire, un véhicule de marque ---, immatriculé ---, à titre onéreux et à compter du --- Kilométrage du véhicule :--- kms "),
                      pw.SizedBox(height: 10),
                      pw.Text("1.2 - Etat du véhicule ",
                          style: const pw.TextStyle(
                              color: PdfColor(0.2, 0.4, 0.4, 1))),
                      pw.SizedBox(height: 10),
                      pw.Text(
                          "Lors de la remise du véhicule et lors de sa restitution, un procès-verbal de l'état du véhicule sera établi entre le locataire et le loueur. Le véhicule devra être restitué le même état que lors de sa remise. Toutes les détériorations sur le véhicule constatées sur le PV de sortie seront à la charge du locataire. Le locataire certifie être en possession du permis l'autorisant à conduire le présent véhicule. "),
                      pw.SizedBox(height: 10),
                      pw.Text("1.3 - Prix de la location du de la voiture",
                          style: const pw.TextStyle(
                              color: PdfColor(0.2, 0.4, 0.4, 1))),
                      pw.SizedBox(height: 10),
                      pw.Text(
                          "Les parties s'entendent sur un prix de location --- euros par jour (calendaires). Ce prix comprend un forfait de --- kms pour la durée du contrat. "),
                      pw.SizedBox(height: 10),
                      pw.Text("1.4 - Kilométrage supplémentaires ",
                          style: const pw.TextStyle(
                              color: PdfColor(0.2, 0.4, 0.4, 1))),
                      pw.SizedBox(height: 10),
                      pw.Text(
                          "Tout kilomètre réalisé au-delà du forfait indiqué à l'article 1.3 du présent contrat sera facturé au prix de --- euros. "),
                      pw.SizedBox(height: 10),
                      pw.Text("1.5 - Durée et restitution de la voiture ",
                          style: const pw.TextStyle(
                              color: PdfColor(0.2, 0.4, 0.4, 1))),
                      pw.SizedBox(height: 10),
                      pw.Text(
                          "Le contrat est à durée indéterminée. Il pourra y être mis fin par chacune des parties à tout moment en adressant un courrier recommandé en respectant un préavis d'un mois."),
                      pw.SizedBox(height: 10),
                      pw.Text("1.7 - Clause en cas de litige",
                          style: const pw.TextStyle(
                              color: PdfColor(0.2, 0.4, 0.4, 1))),
                      pw.SizedBox(height: 5),
                      pw.Text(
                          "Les parties conviennent expressément que tout litige pouvant naître de l'exécution du présent contratrelèvera de la compétence du tribunal de commerce de --- ."),
                      pw.Text(
                          "Fait en deux exemplaires originaux remis à chacune des parties,"),
                      pw.SizedBox(height: 10),
                      pw.Text("1.8 - Pièces justificatifs du locataire",
                          style: const pw.TextStyle(
                              color: PdfColor(0.2, 0.4, 0.4, 1))),
                      pw.SizedBox(height: 10),
                      pw.Container(
                          height: 200,
                          width: 200,
                          child: pw.Image(
                              pw.MemoryImage(imagePickedPathConvertedTobytes))),
                      pw.SizedBox(height: 15),
                      pw.Text(
                          "Fait en deux exemplaires originaux remis à chacune des parties, "),
                      pw.Text("A ---, le --- "),
                      pw.SizedBox(height: 10),
                      pw.Table.fromTextArray(headers: headers, data: datas),
                      pw.Container(
                          height: 100,
                          width: 100,
                          child: pw.Image(pw.MemoryImage(renterSignature))),
                      pw.Container(
                          height: 400,
                          width: 400,
                          child: pw.Image(pw.MemoryImage(etatsDesLieux)))
                    ])
              ]),
    );

    PermissionStatus status = await Permission.storage.status;
    if (!status.isGranted) {
      await Permission.storage.request();
    }

    final output = await getDirectoryImage();

    if (output != null) {
      final file = File("${output.path}/testImage6545.pdf");
      await file.writeAsBytes(await pdf.save());
    }
  }

  Future<Uint8List> exportSignature() async {
    final exportController = SignatureController(
        penStrokeWidth: 2,
        penColor: Colors.black,
        exportBackgroundColor: Colors.white,
        points: _controller.points);

    final signature = await exportController.toPngBytes();

    exportController.dispose();

    return signature!;
  }

  final _imageKey = GlobalKey<ImagePainterState>();

  Future<Uint8List> saveImage() async {
    final image = await _imageKey.currentState!.exportImage();

    return image!;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Form(
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              children: [
                TextFormField(
                  onChanged: (value) {
                    _name = value;
                  },
                  decoration: const InputDecoration(hintText: 'Name'),
                ),
                TextFormField(
                  onChanged: (value) {
                    _firstName = value;
                  },
                  decoration: const InputDecoration(hintText: 'Firstname'),
                ),
                Signature(
                  controller: _controller,
                  width: 100,
                  height: 100,
                  backgroundColor: Colors.lightBlueAccent,
                ),
                Container(
                  child: Row(children: [
                    IconButton(
                        onPressed: () {
                          if (_controller.isNotEmpty) {
                            _controller.clear();
                          }
                        },
                        icon: Icon(Icons.clear)),
                    IconButton(
                        onPressed: () async {
                          if (_controller.isNotEmpty) {
                            final signature = await exportSignature();

                            renterSignature = signature;
                          }
                        },
                        icon: Icon(Icons.check))
                  ]),
                ),
                Container(
                    height: 300,
                    width: 300,
                    child: ImagePainter.asset(
                      "assets/voiture.jpg",
                      key: _imageKey,
                      scalable: true,
                      initialStrokeWidth: 2,
                      initialColor: Colors.green,
                      initialPaintMode: PaintMode.line,
                    )),
                ElevatedButton(
                    onPressed: () async {
                      Uint8List imageUpdated = await saveImage();
                      setState(() {
                        etatsDesLieux = imageUpdated;
                      });
                    },
                    child: Text('Devis')),
                ElevatedButton(
                    onPressed: () {
                      generatorPdf(nom: 'Niakate', prenom: 'Madi95');
                    },
                    child: const Text('Valider')),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
