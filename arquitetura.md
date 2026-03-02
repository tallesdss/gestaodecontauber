# 🏗️ Arquitetura e Engenharia do Projeto UberControl

Este documento detalha as definições arquiteturais, linguagens, métodos e tecnologias empregadas na construção do aplicativo **UberControl**. 

---

## 💻 1. Linguagens Utilizadas
As linguagens principais adotadas no projeto servem aos propósitos de frontend e de estruturação lógica e banco de dados do backend.
* **Dart:** Linguagem base exclusiva para o desenvolvimento de todo o ecossistema frontend (mobile). Toda a lógica do aplicativo (estado, fluxo de navegação, visualizações da UI) bem como a integração dos Modelos e requisições HTTP com nosso backend são programadas em Dart.
* **SQL (PL/pgSQL):** Utilizado diretamente no nível do banco de dados relacional. Por meio de SQL, configuramos as tabelas, índices e, de forma avançada, as funções personalizadas no próprio banco. O PL/pgSQL possibilita criar lógica de negócio profunda (RPCs e disparadores/triggers) próxima ao local de leitura dos dados.

---

## 🛠️ 2. Tecnologias Empregadas
O sistema foca em estabilidade, produtividade e confiabilidade, se apoiando em frameworks robustos e soluções de nuvem escaláveis.

### Frontend
* **Flutter:** Framework principal escolhido para construir nativamente os aplicativos Android e iOS utilizando um único código base. 
* **GoRouter:** Solução robusta e declarativa para roteamento e navegação de telas usando rotas baseadas em URL-like.
* **Provider:** Ferramenta oficial e simplificada de Gerenciamento de Estado para fornecer e gerir informações reativas no app.
* **Bibliotecas Secundárias Importantes:** 
  * `fl_chart:` Utilizado para renderizar painéis analíticos e relatórios em forma de gráficos estatísticos.
  * `pdf` e `excel:` Bibliotecas para exportar o balanço financeiro do motorista em relatórios documentais consolidados para facilitar a impressão.

### Backend & Infraestrutura
* **Supabase:** Plataforma Backend-as-a-Service (BaaS) operadora principal de toda a infraestrutura na nuvem do UberControl.
  * **PostgreSQL:** Sistema gerenciador de bancos de dados relacional que atuam por debaixo do capô do Supabase. Utilizado para armazenar ganhos, despesas, cadastros e metadados com extrema integridade referencial.
  * **Supabase Storage:** Serviço de armazenamento em buckets configurado primariamente para abrigar grandes arquivos, como fotos de perfil e recibos.
  * **Supabase Auth:** Central de gerenciamento nativo de autenticação/tokens.

---

## ⚙️ 3. Lógica por Trás da Infraestrutura
A lógica da infraestrutura segue a filosofia de manter inteligentemente o volume de processamento no banco de dados e deixar a lógica de visualização no aplicativo cliente, evitando latência e consumo de bateria no celular do motorista.

1. **Baixo Processamento no Dispositivo Móvel:** O backend realiza grande parte do trabalho pesado. Em vez do aplicativo buscar milhares de registros simultâneos de históricos anuais para somá-los/agrupá-los internamente no aparelho celular, a lógica aciona **RPCs (Remote Procedure Calls)**. Tais métodos de processamento calculam a contabilidade instantaneamente de forma otimizada para banco de dados e retornam unicamente a sumarização (sub-totais, totais exatos).
2. **Segurança Descentralizada e RLS (Row Level Security):** O tráfego de API é protegido sobre HTTPS com banco acessível apenas pelos clientes autenticados do App via URL e chaves criptografadas (Anon keys) nativas. Utilizamos RLS que impõem restrições de que comandos SQL simples (como `SELECT * FROM expenses`) retornarão para o frontend unicamente as linhas cujo proprietário for o próprio dono (`WHERE auth.uid() = id_motorista`).

---

## 🏛️ 4. Detalhes de Arquitetura e Disposição de Pastas
A camada do aplicativo mobile consolida-se através da **Feature-First Architecture** em conjunto com as diretrizes da **Clean Architecture**. O isolamento sistêmico é promovido priorizando funcionalidade ("Feature") sob tipo estrutural, evitando complexibilidade escalada.

A estrutura do projeto base é ditada por:
```text
lib/
├── core/            # Camada dos aspectos mais fixos que englobam a vida do App (Configurações base de Widgets, Temas, Variáveis de Ambientes, Utilitários).
├── features/        # O núcleo das regras de negócios segmentados em "Micro-Apps" únicos (Ex: /home, /earnings, /expenses, /history). Dentro de cada uma delas, o Gerenciamento de Estado focado, a Camada de Visualizações e Lógicas correspondentes.
├── shared/          # Central com o intuito de evitar duplicação em features; Provê Classes de Modelagem globais (models), Serviços intermédios de acesso ao Backend ou persistência de dados (services) e Peças reutilizáveis de interface UI (widgets).
└── routes/          # Definidor da estrutura GoRouter sobre a árvore de caminhos de interface principal e navegação lateral.
```

---

## 🧩 5. Métodos e Padrões Orientados Empregados
Adotamos "Design Patterns" focados para a otimização da manutenção ao longo dos anos, contendo:

* **Padrão Repository & Service Locator:** Para abstrair a comunicação direta do backend das interfaces, agrupamos os acessos à base de dados relacional e infraestrutura em abstrações de Classe (`SupabaseService`), assim se torna muito viável realizar manutenção da base.
* **Componentização UI (Atomic Design simplificado):** Peças comuns em várias interfaces, englobando botões da marcação, caixas de campo de dados e barras de navegação são desenvolvidas sob formato atomico customizável na rota partilhada.
* **State Management Model:** O uso do Provider possibilita que provedores locais e até mesmo globais evitem que os métodos de busca das views ocorram múltiplas vezes de modo estático.
* **Observer/Realtime Data (Streaming):** É amplamente feito uso de Eventos Websocket providos pelo pacote _Supabase_, atualizando faturamentos ou despesas visualizadas em UI instantaneamente baseadas ao monitoramento transacional do app sem requisições manuais periódicas (Pulling).
