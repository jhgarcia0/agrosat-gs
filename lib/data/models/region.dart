class Region {
  final String id;
  final String name;
  final String state;
  final double latitude;
  final double longitude;
  final String description;

  const Region({
    required this.id,
    required this.name,
    required this.state,
    required this.latitude,
    required this.longitude,
    required this.description,
  });

  static const List<Region> brazilianRegions = [
    Region(
      id: 'sorriso_mt',
      name: 'Sorriso',
      state: 'MT',
      latitude: -12.54,
      longitude: -55.72,
      description: 'Capital nacional da soja. Solo arenoso de alta produtividade.',
    ),
    Region(
      id: 'passo_fundo_rs',
      name: 'Passo Fundo',
      state: 'RS',
      latitude: -28.26,
      longitude: -52.40,
      description: 'Polo de trigo e soja do Sul do Brasil.',
    ),
    Region(
      id: 'ribeirao_preto_sp',
      name: 'Ribeirão Preto',
      state: 'SP',
      latitude: -21.17,
      longitude: -47.81,
      description: 'Maior produtor de cana-de-açúcar do estado.',
    ),
    Region(
      id: 'rio_verde_go',
      name: 'Rio Verde',
      state: 'GO',
      latitude: -17.80,
      longitude: -50.93,
      description: 'Grande polo de soja e milho do Cerrado.',
    ),
    Region(
      id: 'londrina_pr',
      name: 'Londrina',
      state: 'PR',
      latitude: -23.31,
      longitude: -51.17,
      description: 'Referência em pesquisa agrícola da Embrapa Soja.',
    ),
    Region(
      id: 'barreiras_ba',
      name: 'Barreiras',
      state: 'BA',
      latitude: -12.15,
      longitude: -44.99,
      description: 'MATOPIBA: nova fronteira agrícola do Cerrado nordestino.',
    ),
    Region(
      id: 'uberlandia_mg',
      name: 'Uberlândia',
      state: 'MG',
      latitude: -18.91,
      longitude: -48.27,
      description: 'Polo de soja e milho do Triângulo Mineiro.',
    ),
    Region(
      id: 'dourados_ms',
      name: 'Dourados',
      state: 'MS',
      latitude: -22.22,
      longitude: -54.81,
      description: 'Grande produtor de soja e milho do Mato Grosso do Sul.',
    ),
  ];
}
