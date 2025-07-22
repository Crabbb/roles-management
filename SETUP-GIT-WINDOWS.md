# Установка Git на Windows и настройка репозитория

**Ваш репозиторий:** https://github.com/Crabbb/roles-management.git

## 🚀 Шаг 1: Установка Git

### Способ 1: Скачать с официального сайта
1. Перейдите на https://git-scm.com/download/win
2. Скачайте Git for Windows
3. Запустите установщик
4. **Важные настройки при установке:**
   - **Git from the command line and also from 3rd-party software** ✅
   - **Use bundled OpenSSH** ✅
   - **Use the OpenSSL library** ✅
   - **Checkout as-is, commit Unix-style line endings** ✅
   - **Use MinTTY** ✅
   - **Default (fast-forward or merge)** ✅
   - **Git Credential Manager** ✅
   - **Enable file system caching** ✅

### Способ 2: Через Chocolatey (если установлен)
```powershell
choco install git
```

### Способ 3: Через Winget
```powershell
winget install --id Git.Git -e --source winget
```

## 🔧 Шаг 2: Настройка Git

После установки откройте **Git Bash** или **PowerShell** и выполните:

```bash
# Настройка имени пользователя
git config --global user.name "Crabbb"

# Настройка email (используйте email от GitHub)
git config --global user.email "your-email@example.com"

# Настройка редактора (опционально)
git config --global core.editor "notepad"

# Настройка кодировки для Windows
git config --global core.autocrlf true
```

## 📁 Шаг 3: Инициализация репозитория

Откройте **Git Bash** в папке проекта:

```bash
# Перейдите в папку проекта
cd /c/Users/banko/Desktop/Projects/roles-management

# Инициализируйте Git репозиторий
git init

# Добавьте все файлы
git add .

# Создайте первый коммит
git commit -m "Initial commit: Система управления ролями и навыками

- Создана структура проекта
- Добавлена декомпозиция навыков разработчиков L1-L3
- Создана система валидации и тестирования
- Подготовлены файлы для экспорта в Excel"

# Добавьте удаленный репозиторий
git remote add origin https://github.com/Crabbb/roles-management.git

# Переименуйте ветку в main
git branch -M main

# Отправьте код на GitHub
git push -u origin main
```

## 🔐 Шаг 4: Настройка аутентификации

### Способ 1: Personal Access Token (рекомендуется)
1. Перейдите на GitHub → Settings → Developer settings → Personal access tokens → Tokens (classic)
2. Нажмите "Generate new token (classic)"
3. Выберите scopes: `repo`, `workflow`
4. Скопируйте токен
5. При push введите username: `Crabbb`, password: `ваш_токен`

### Способ 2: GitHub CLI
```bash
# Установите GitHub CLI
winget install GitHub.cli

# Авторизуйтесь
gh auth login
```

## 🔄 Шаг 5: Автоматическая синхронизация

### Создайте скрипт для быстрой синхронизации

Создайте файл `sync.bat` в корне проекта:

```batch
@echo off
echo Синхронизация с GitHub...
git add .
git commit -m "Auto-sync: %date% %time%"
git push origin main
echo Синхронизация завершена!
pause
```

### Или PowerShell скрипт `sync.ps1`:

```powershell
Write-Host "Синхронизация с GitHub..." -ForegroundColor Green
git add .
git commit -m "Auto-sync: $(Get-Date -Format 'yyyy-MM-dd HH:mm:ss')"
git push origin main
Write-Host "Синхронизация завершена!" -ForegroundColor Green
Read-Host "Нажмите Enter для продолжения"
```

## 🎯 Шаг 6: Проверка настройки

```bash
# Проверьте статус
git status

# Проверьте удаленный репозиторий
git remote -v

# Проверьте историю коммитов
git log --oneline
```

## 📋 Чек-лист готовности

- [ ] Git установлен
- [ ] Настроены имя и email
- [ ] Репозиторий инициализирован
- [ ] Первый коммит создан
- [ ] Удаленный репозиторий добавлен
- [ ] Код отправлен на GitHub
- [ ] Аутентификация настроена
- [ ] Скрипт синхронизации создан

## 🚨 Решение проблем

### Проблема: "git не является внутренней или внешней командой"
**Решение:** Перезапустите PowerShell после установки Git

### Проблема: "Authentication failed"
**Решение:** Используйте Personal Access Token вместо пароля

### Проблема: "Permission denied"
**Решение:** Проверьте права доступа к папке проекта

## 🔗 Полезные команды

```bash
# Проверить статус
git status

# Посмотреть изменения
git diff

# Отменить изменения в файле
git checkout -- filename

# Создать новую ветку
git checkout -b feature/new-feature

# Переключиться на ветку
git checkout main

# Объединить ветки
git merge feature/new-feature

# Удалить ветку
git branch -d feature/new-feature
```

---

**После выполнения всех шагов ваш проект будет синхронизирован с GitHub!** 🎉 