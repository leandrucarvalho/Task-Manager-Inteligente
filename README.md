# Task Manager Inteligente

Projeto Flutter com Clean Architecture, MVVM e Riverpod.

## Arquitetura

Camadas principais:
- **presentation**: UI, providers, view-models (Riverpod).
- **domain**: entidades e casos de uso.
- **data**: models, serviços e repositórios.

Fluxo: UI ? Provider (ViewModel) ? UseCase ? Repository ? DataSource (API) ? retorno para UI.

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

