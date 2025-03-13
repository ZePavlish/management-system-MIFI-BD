# Проект: Анализ и Управление Базами Данных

## Описание проекта
Данный проект представляет собой набор SQL-запросов и скриптов для создания, наполнения и анализа баз данных в PostgreSQL и MySQL. Он включает в себя решения нескольких задач, связанных с различными предметными областями, включая автоспорт, гостиничный бизнес и управление персоналом.

## Цели и задачи проекта
Основная цель проекта — разработка и анализ реляционных баз данных, обеспечивающих хранение, обработку и анализ данных в различных предметных областях. Основные задачи включают:
- Создание схемы базы данных для каждой предметной области.
- Заполнение базы данных тестовыми данными.
- Разработка SQL-запросов для аналитики, поиска и обработки данных.
- Использование рекурсивных запросов, агрегации и фильтрации данных.

## Структура репозитория
Репозиторий содержит четыре основных папки, каждая из которых соответствует определенной базе данных:

- **Vehicle** — база данных для управления транспортными средствами (автомобили, мотоциклы, велосипеды).
- **Сars** — база данных с результатами гонок для анализа эффективности автомобилей.
- **Hotel** — база данных для анализа бронирования номеров в отелях.
- **Company** — база данных управления сотрудниками, их подчинёнными, проектами и задачами.

Каждая папка содержит:
- **Скрипты создания таблиц** (DDL).
- **Скрипты наполнения базы данных тестовыми данными** (DML).
- **SQL-запросы для решения поставленных задач**.

## Структура базы данных
### Vehicle
- Таблица `Vehicle` содержит данные о транспортных средствах.
- Таблицы `Car`, `Motorcycle` и `Bicycle` хранят специфическую информацию по типам транспорта.

### Cars
- Таблица `Classes` содержит категории автомобилей.
- Таблица `Cars` хранит данные об автомобилях.
- Таблица `Races` содержит информацию о проведенных гонках.
- Таблица `Results` фиксирует результаты гонок.

### Hotel
- Таблица `Hotel` содержит информацию об отелях.
- Таблица `Room` хранит данные о номерах в отелях.
- Таблица `Customer` содержит информацию о клиентах.
- Таблица `Booking` фиксирует бронирования номеров.

### Company
- Таблица `Employees` содержит данные о сотрудниках и их иерархии.
- Таблица `Departments` хранит информацию об отделах.
- Таблица `Roles` содержит роли сотрудников.
- Таблица `Projects` хранит проекты, в которых участвуют сотрудники.
- Таблица `Tasks` содержит задачи, назначенные сотрудникам.
