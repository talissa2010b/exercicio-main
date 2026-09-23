import 'package:flutter/material.dart';

import 'dart: math'

void main() {
  runApp( const TabBar());
}

class wikipediaApp extends StatelessWidget{
  const wikipediaApp({super.key});
 
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Wiki Image Reviewer',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        useMaterial3: true,
      ),
      home: const MainScreen(),
    );
  }
}
  //Modelo para estruturar os dados das imagens 
  class wikiImage {
    final String id,
    final String url,
    final String title, 
    bool is aproved;  // null = não votado, true = aprovado, false = reprovado
    wikiImage(required this. id, required)
 // Tela Principal: Mostra as 4 imagens e o botão para ver as aprovadas
class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  // Lista inicial de 4 imagens mockadas da Wikipedia (URLs públicas estáveis)
  final List<WikiImage> _images = [
    WikiImage(
      id: '1',
      title: 'Gatinho',
      url: 'https://upload.wikimedia.org/wikipedia/commons/b/bc/Juvenile_Ragdoll.jpg?utm_source=en.wikipedia.org&utm_campaign=index&utm_content=original',
    ),
    WikiImage(
      id: '2',
      title: 'Torre Eiffel',
      url: 'https://upload.wikimedia.org/wikipedia/commons/8/8b/Eiffel_Tower_from_Champ-de-Mars%2C_7_August_2017.jpg?utm_source=pt.wikipedia.org&utm_campaign=index&utm_content=original',
    ),
    WikiImage(
      id: '3',
      title: 'Planeta Terra',
      url: 'https://thumb.wikimedia.org/wikipedia/commons/thumb/7/7a/NASA-JPL-Caltech_-_Double_the_Rubble_%28PIA11375%29_%28pd%29.jpg/1920px-NASA-JPL-Caltech_-_Double_the_Rubble_%28PIA11375%29_%28pd%29.jpg?utm_source=pt.wikipedia.org&utm_campaign=imageinfo&utm_content=thumbnail',
    ),
    WikiImage(
      id: '4',
      title: 'Arara-azul',
      url: 'https://upload.wikimedia.org/wikipedia/commons/d/da/Arara_Azul_no_Pantanal.jpg?utm_source=pt.wikipedia.org&utm_campaign=index&utm_content=original',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Wikipedia Explorer'),
        backgroundColor: Colors.amber,
        actions: [
          IconButton(
            icon: const Icon(Icons.star, color: Colors.white),
            tooltip: 'Imagens Aprovadas',
            onPressed: () {
              // Filtrar apenas as imagens aprovadas para enviar à próxima tela
              final approvedList = _images.where((img) => img.isApproved == true).toList();
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ApprovedScreen(approvedImages: approvedList),
                ),
              );
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: GridView.builder(
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2, // 2 colunas para exibir em formato pequeno
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
          ),
          itemCount: _images.length,
          itemBuilder: (context, index) {
            final image = _images[index];
            return GestureDetector(
              onTap: () async {
                // Navega para a tela de detalhes/votação e aguarda o resultado
                final result = await Navigator.push<bool>(
                  context,
                  MaterialPageRoute(
                    builder: (context) => VotingScreen(image: image),
                  ),
                );

                // Se o usuário tomou uma decisão, atualiza o estado
                if (result != null) {
                  setState(() {
                    image.isApproved = result;
                  });
                }
              },
              child: Card(
                clipBehavior: Clip.antiAlias,
                elevation: 4,
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    Image.network(
                      image.url,
                      fit: BoxFit.cover,
                    ),
                    // Indicador visual discreto caso já tenha sido votada
                    if (image.isApproved != null)
                      Positioned(
                        top: 8,
                        right: 8,
                        child: CircleAvatar(
                          radius: 14,
                          backgroundColor: image.isApproved! ? Colors.green : Colors.red,
                          child: Icon(
                            image.isApproved! ? Icons.check : Icons.close,
                            size: 16,
                            color: Colors.white,
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

// Tela de Votação: Permite aprovar ou reprovar a foto
class VotingScreen extends StatelessWidget {
  final WikiImage image;

  const VotingScreen({super.key, required this.image});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Avaliar: ${image.title}'),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: Image.network(
                  image.url,
                  fit: BoxFit.contain,
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 48.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.redAccent,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                  ),
                  onPressed: () => Navigator.pop(context, false), // Retorna 'false' (Reprovado)
                  icon: const Icon(Icons.thumb_down),
                  label: const Text('Reprovar'),
                ),
                ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                  ),
                  onPressed: () => Navigator.pop(context, true), // Retorna 'true' (Aprovado)
                  icon: const Icon(Icons.thumb_up),
                  label: const Text('Aprovar'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// Tela de Aprovadas: Mostra apenas as imagens favoritadas
class ApprovedScreen extends StatelessWidget {
  final List<WikiImage> approvedImages;

  const ApprovedScreen({super.key, required this.approvedImages});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Imagens Aprovadas'),
        backgroundColor: Colors.green,
      ),
      body: approvedImages.isEmpty
          ? const Center(
              child: Text(
                'Nenhuma imagem aprovada ainda.',
                style: TextStyle(fontSize: 16, color: Colors.grey),
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: approvedImages.length,
              itemBuilder: (context, index) {
                final image = approvedImages[index];
                return Card(
                  margin: const EdgeInsets.only(bottom: 16),
                  clipBehavior: Clip.antiAlias,
                  child: Column(
                    children: [
                      Image.network(
                        image.url,
                        height: 200,
                        width: double.infinity,
                        fit: BoxFit.cover,
                      ),
                      ListTile(
                        title: Text(image.title),
                        trailing: const Icon(Icons.verified, color: Colors.green),
                      ),
                    ],
                  ),
                );
              },
            ),
    );
  }
}

c