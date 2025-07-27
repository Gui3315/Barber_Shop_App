# 🪒 Elias Barbearia - Sistema de Agendamento

<div align="center">
  <img src="https://img.shields.io/badge/Flutter-02569B?style=for-the-badge&logo=flutter&logoColor=white" alt="Flutter">
  <img src="https://img.shields.io/badge/Dart-0175C2?style=for-the-badge&logo=dart&logoColor=white" alt="Dart">
  <img src="https://img.shields.io/badge/SQLite-07405E?style=for-the-badge&logo=sqlite&logoColor=white" alt="SQLite">
  <img src="https://img.shields.io/badge/Android-3DDC84?style=for-the-badge&logo=android&logoColor=white" alt="Android">
  <img src="https://img.shields.io/badge/iOS-000000?style=for-the-badge&logo=ios&logoColor=white" alt="iOS">
</div>

## 📱 Sobre o Projeto

Sistema completo de agendamento para barbearia desenvolvido em Flutter, oferecendo uma solução moderna e eficiente para gestão de horários e serviços. O aplicativo permite que clientes agendem serviços específicos por gênero, enquanto o proprietário gerencia todos os agendamentos através de um painel administrativo.

## ✨ Funcionalidades Principais

### 🔐 Sistema de Autenticação
- Login diferenciado para clientes e proprietários
- Criptografia SHA-256 para segurança de senhas
- Recuperação de senha integrada
- Registro de novos usuários

### 📅 Agendamento Inteligente
- Seleção de profissional por especialização (masculino/feminino)
- Escolha de serviços com preços dinâmicos
- Calendário com restrição de dias úteis (segunda a sexta)
- Horários disponíveis de 10h às 21h
- Prevenção de conflitos de agendamento
- Cálculo automático de valores

### 👨‍💼 Painel Administrativo
- Visualização de todos os agendamentos
- Informações detalhadas: cliente, data, horário, serviços e valores
- Atualização em tempo real
- Interface responsiva e intuitiva

### 🎨 Interface Moderna
- Design dark theme elegante
- Logo personalizado da barbearia
- Navegação fluida entre telas
- Feedback visual com SnackBars
- QR Code simulado para confirmação

## 🛠️ Tecnologias Utilizadas

- **Flutter/Dart** - Framework cross-platform
- **SQLite** - Banco de dados local
- **Crypto** - Criptografia de senhas
- **Intl** - Formatação de datas
- **Path Provider** - Gerenciamento de diretórios

## 📋 Pré-requisitos

- Flutter SDK 3.8.1 ou superior
- Dart SDK
- Android Studio / VS Code
- Emulador Android ou dispositivo físico

## 🚀 Como Executar

1. **Clone o repositório**
```bash
git clone https://github.com/Gui3315/Barber_Shop_App.git
cd Barber_Shop_App
```

2. **Instale as dependências**
```bash
flutter pub get
```

3. **Execute o aplicativo**
```bash
flutter run
```

## 📱 Telas do Aplicativo

### Tela de Login
- Autenticação segura com validação de campos
- Opções de cadastro e recuperação de senha
- Redirecionamento específico por tipo de usuário

### Seleção de Profissional
- Interface elegante com fotos dos profissionais
- Elias: especialista em atendimento masculino
- Bruna: especialista em atendimento feminino

### Agendamento
- Checkboxes para seleção de serviços
- Preços exibidos dinamicamente
- Seletor de data com calendário integrado
- Horários disponíveis em chips interativos

### Painel do Proprietário
- Lista organizada de todos os agendamentos
- Informações completas de cada reserva
- Botões de atualização e logout

## 🏗️ Arquitetura do Projeto

```
lib/
├── main.dart                 # Ponto de entrada da aplicação
├── login_page.dart           # Tela de autenticação
├── register_page.dart        # Cadastro de usuários
├── welcome_page.dart         # Tela de boas-vindas
├── gender_selection_page.dart # Seleção de profissional
├── schedule_male_page.dart   # Agendamento masculino
├── schedule_female_page.dart # Agendamento feminino
├── owner_home_page.dart      # Painel administrativo
├── user_database.dart        # Gerenciamento de usuários
├── booking_storage.dart      # Armazenamento de agendamentos
├── admin_setup.dart          # Configuração inicial
└── background_container.dart # Componente de fundo
```

## 🔧 Configurações

### Serviços e Preços
- **Masculino**: Cabelo (R$ 30), Bigode (R$ 10), Barba (R$ 20)
- **Feminino**: Cabelo (R$ 60), Manicure (R$ 50), Pedicure (R$ 50)

### Horários de Funcionamento
- Segunda a sexta-feira
- 10h às 21h
- Duração baseada na quantidade de serviços

## 📸 Screenshots

### Tela de Login
![Tela de Login](screenshots/Login%20page.jpeg)

### Seleção de Profissional
![Seleção de Profissional](screenshots/Select%20professional%20page.jpeg)

### Agendamento de Serviços
![Agendamento de Serviços](screenshots/Services%20page.jpeg)

### Painel do Proprietário
![Painel do Proprietário](screenshots/Owner%20page.jpeg)

## 🤝 Contribuição

1. Faça um fork do projeto
2. Crie uma branch para sua feature (`git checkout -b feature/AmazingFeature`)
3. Commit suas mudanças (`git commit -m 'Add some AmazingFeature'`)
4. Push para a branch (`git push origin feature/AmazingFeature`)
5. Abra um Pull Request

## 📄 Licença

Este projeto está sob a licença MIT. Veja o arquivo [LICENSE](LICENSE) para mais detalhes.

## 👨‍💻 Desenvolvedor

**Guilherme** - Desenvolvedor Flutter

- GitHub: [@Gui3315](https://github.com/Gui3315)
- LinkedIn: [Seu LinkedIn]

## 📞 Contato

- Email: [seu-email@exemplo.com]
- LinkedIn: [Seu LinkedIn]

---

<div align="center">
  <p>⭐ Se este projeto te ajudou, considere dar uma estrela!</p>
</div>
