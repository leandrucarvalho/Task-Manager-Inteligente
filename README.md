# Task Manager Inteligente

Projeto Flutter com Clean Architecture, MVVM e Riverpod.

## Arquitetura

Camadas principais:
- **presentation**: UI, providers, view-models (Riverpod).
- **domain**: entidades e casos de uso.
- **data**: models, serviços e repositórios.

Fluxo: UI ? Provider (ViewModel) ? UseCase ? Repository ? DataSource (API/Local/IA) ? retorno para UI.

## Estrutura de pastas

```
lib/
  core/
  features/
    tasks/
      data/
      domain/
      presentation/
```

## Como rodar

1. `flutter pub get`
2. `flutter run`

## Armazenamento local (SQLite)

O projeto já inclui integração com **sqflite**.

No arquivo `lib/features/tasks/presentation/providers/task_dependencies.dart`, ajuste:

- `useLocalStorage = true` para usar SQLite
- `useLocalStorage = false` para usar API (mock/real)

## Integração com OpenRouter (IA)

A sugestão automática de prioridade usa a API da OpenRouter.

Configure via `--dart-define`:

```
flutter run \
  --dart-define=OPENROUTER_API_KEY=SEU_TOKEN \
  --dart-define=OPENROUTER_MODEL=openai/gpt-4 \
  --dart-define=OPENROUTER_TITLE="Task Manager Inteligente" \
  --dart-define=OPENROUTER_REFERER="https://seuapp.com"
```

### Cache e fallback

- As sugestões são cacheadas localmente (SQLite) por título + descrição.
- Se a IA estiver indisponível, uma heurística local escolhe a prioridade.
- Um badge explica a origem e o motivo da sugestão.

Observação: não é recomendado expor a API key no app em produção. O ideal é usar um backend/proxy.

## Integração com backend real

No arquivo `lib/features/tasks/presentation/providers/task_dependencies.dart`, altere:

- `useMockApi = false`

E configure a base URL em `lib/core/network/dio_client.dart`.

Certifique-se de que o backend exponha os endpoints:

- `GET /tasks`
- `POST /tasks`
- `PUT /tasks/{id}`
- `DELETE /tasks/{id}`

## Testes

- `flutter test`

