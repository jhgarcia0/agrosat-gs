# AgroSat

Plataforma de análise agrícola via dados satelitais — Global Solution FIAP 2026.1

## Proposta

O AgroSat conecta a infraestrutura espacial global (satélites Sentinel-2, MODIS, Landsat)
aos desafios reais da agricultura brasileira. A plataforma permite analisar regiões agrícolas
do Brasil com dados climáticos e de solo em tempo real, calculando um índice de idealidade
para diferentes culturas com base na metodologia da EMBRAPA.

## Funcionalidades

- Listagem de regiões agrícolas brasileiras com dados reais
- Análise climática por região (temperatura, precipitação, umidade do solo)
- Índice de idealidade para 5 culturas: Soja, Milho, Arroz, Trigo, Cana-de-açúcar
- Favoritos com persistência local via SharedPreferences
- Tratamento de estados: carregamento, sucesso e erro

## Arquitetura — MVVM com Provider + GetIt

```
lib/
├── core/
│   ├── injection.dart       # GetIt — registro de dependências
│   └── theme.dart           # Tema Material 3
├── data/
│   ├── models/              # Region, AnalysisResult
│   ├── services/            # WeatherService — chamada à API
│   └── repositories/        # AnalysisRepository — lógica + SharedPreferences
└── presentation/
    ├── viewmodels/          # RegionListViewModel, AnalysisViewModel
    ├── screens/             # HomeScreen, RegionListScreen, AnalysisDetailScreen
    └── widgets/             # RegionCard, ScoreBar, DataTile
```

## API Utilizada

**Open-Meteo** (https://open-meteo.com) — API pública e gratuita, sem chave de acesso.

Dados consumidos: temperatura máxima/mínima diária, precipitação acumulada 7 dias e
umidade volumétrica do solo (0–1 cm).

## Como executar

```bash
flutter create agrosat
cd agrosat

# Substituir lib/ e pubspec.yaml pelos arquivos deste repositório

flutter pub get
flutter run
```

> Se aparecer erro de rede no Android, confirme que o arquivo
> `android/app/src/main/AndroidManifest.xml` contém:
> `<uses-permission android:name="android.permission.INTERNET" />`
> (Flutter já inclui por padrão em projetos novos)

## Integrantes

- Mateus Henrique Bessornia da Silva
- João Henrique Garcia de Santana Cruz
- Luan Rodrigues Pupo Serra

## GitHub

https://github.com/jhgarcia0/agrosat-gs

## Pitch

[Link do YouTube aqui]

---

*Global Solution 2026.1 · FIAP · 3º Ano Sistemas de Informação*
