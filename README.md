# EcoMissão 🌱

Aplicativo acadêmico em Flutter para incentivar hábitos sustentáveis por meio de missões, pontos, níveis, medalhas e sequência diária.

## Requisitos

- Flutter instalado
- Android Studio ou VS Code
- Emulador Android ou celular com depuração USB

## Como executar

1. Extraia a pasta do projeto.
2. Abra a pasta `ecomissao_flutter` no VS Code ou Android Studio.
3. No terminal, execute:

```bash
flutter pub get
flutter run
```

## Como gerar o APK

Com um dispositivo Android configurado, execute:

```bash
flutter build apk
```

O APK será gerado em:

```text
build/app/outputs/flutter-apk/app-release.apk
```

## As duas telas

1. **Missões:** lista de missões prontas e personalizadas, filtros, criação, conclusão e remoção.
2. **Meu progresso:** pontos, nível, sequência diária, estatísticas, medalhas e histórico.

## Persistência

O projeto usa `shared_preferences` para salvar localmente as missões em formato JSON e as datas em que houve missões concluídas.

- Ao abrir o aplicativo, `MissionStore.load()` lê os dados salvos.
- Ao adicionar, concluir ou remover uma missão, `_save()` grava a lista atualizada.
- O progresso é calculado a partir das missões concluídas e das datas registradas.

## Antes de entregar

- Testem todas as ações em um celular ou emulador.
- Fechem e abram o app para confirmar a persistência.
- Personalizem os comentários do código com as palavras da dupla.
- Criem a documentação exigida pelo professor com prints reais do aplicativo.
- Confiram o nome da dupla e o repositório GitHub antes do envio.

## Observação

O aplicativo não usa servidor ou login. Os dados ficam armazenados no próprio dispositivo. A sequência diária é baseada na data local do aparelho.
