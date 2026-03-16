# Lightweight SaaS Starter (Laravel + Nuxt 4)

A lightweight SaaS starter template built with a modern **API + SPA architecture** designed for SaaS products.

---

# Stack

## Backend

* Laravel 12 (REST API only)
* MySQL
* Laravel Sanctum (API authentication)
* Spatie Laravel Permission
* Laravel Filament (admin panel)

## Frontend

* Nuxt 4 (SPA mode)
* TypeScript
* Pinia
* TailwindCSS
* Nuxt i18n (English / French)
* GSAP animations
* FontAwesome 6
* Dark / Light mode

---

# Architecture

```
saas-app/

backend/        Laravel API
frontend/       Nuxt 4 SPA
```

Backend responsibilities

* authentication
* authorization
* business logic
* database
* admin panel (Filament)

Frontend responsibilities

* UI
* routing
* state management
* permissions UI
* animations
* translations
* theme switching

---

# API Versioning

All routes use **versioning**.

```
/api/v1/*
```

Examples

```
POST /api/v1/login
GET  /api/v1/me
GET  /api/v1/users
GET  /api/v1/reports
```

Future versions can be introduced without breaking the API.

```
/api/v2/
```

---

# Authentication

Authentication uses **Laravel Sanctum**.

Flow

1. user logs in
2. backend returns token
3. token stored in **secure cookie**
4. Pinia fetches `/api/v1/me`
5. roles and permissions stored in frontend state

---

# Roles & Permissions

Using **Spatie Laravel Permission**

Roles

| Role    | Permissions                      |
| ------- | -------------------------------- |
| admin   | full access                      |
| manager | dashboard, reports, manage users |
| user    | dashboard only                   |

---

# Filament Admin Panel

Filament is used to manage:

* users
* roles
* permissions

Admin URL

```
/admin
```

Features

* create roles
* assign permissions
* manage users
* update permissions visually

Only **admin** can access this panel.

---

# Frontend Pages

```
/login
/register
/dashboard
/users
/reports
/settings
/unauthorized
```

Access rules

| Page      | Access          |
| --------- | --------------- |
| dashboard | authenticated   |
| users     | admin           |
| reports   | admin + manager |
| settings  | authenticated   |

---

# TailwindCSS Styling

TailwindCSS is used for all styling.

Example

```html
<div class="p-6 rounded-xl shadow bg-white dark:bg-gray-800">
Dashboard
</div>
```

---

# Dark / Light Mode

Dark mode uses **Tailwind dark class strategy**.

Theme preference is stored in **localStorage**.

Features

* toggle button
* auto detect system theme
* persistent across reloads

Example toggle

```
🌙 Dark
☀️ Light
```

Example usage

```html
<div class="bg-white dark:bg-gray-900 text-gray-900 dark:text-white">
Content
</div>
```

---

# Internationalization (i18n)

Using **Nuxt i18n**

Supported languages

| Language | Code |
| -------- | ---- |
| English  | en   |
| French   | fr   |

Example structure

```
locales/
en.json
fr.json
```

Example

en.json

```
{
  "login": "Login",
  "dashboard": "Dashboard",
  "logout": "Logout"
}
```

fr.json

```
{
  "login": "Connexion",
  "dashboard": "Tableau de bord",
  "logout": "Déconnexion"
}
```

Usage

```vue
{{ $t('dashboard') }}
```

Language switcher example

```
EN | FR
```

---

# Animations (GSAP)

Used for

* page transitions
* card reveal
* dashboard animations

Example

```ts
gsap.from(".card", {
  y: 30,
  opacity: 0,
  duration: 0.6,
  stagger: 0.1
})
```

---

# FontAwesome

Global component

```
<fa icon="user" />
```

Example

```
<fa icon="chart-line" />
```

---

# Vue Permission Directives

Custom directives

```
v-role="'admin'"
v-can="'edit users'"
```

Example

```vue
<button v-can="'delete users'">
Delete
</button>

<div v-role="'admin'">
Admin controls
</div>
```

---

# Nuxt 4 Folder Structure

```
frontend/

app.vue

assets/
css/

layouts/
default.vue
dashboard.vue

middleware/
auth.ts
guest.ts
role.ts

pages/
login.vue
register.vue
dashboard.vue
users.vue
reports.vue
settings.vue
unauthorized.vue

plugins/
gsap.client.ts
fontawesome.ts
directives.ts
i18n.ts
theme.client.ts

stores/
auth.ts
theme.ts

composables/
useApi.ts
useAuth.ts
useTheme.ts

locales/
en.json
fr.json
```

---

# Laravel Backend Structure

```
backend/

app/
Http/
Controllers/
AuthController.php
UserController.php
ReportController.php

Models/
User.php

routes/
api.php

database/
migrations/
seeders/

config/
permission.php
```

---

# Installation

# 1 Clone Repository

```
git clone https://github.com/yourname/saas-starter.git
cd saas-starter
```

---

# Backend Setup

```
cd backend
```

Install dependencies

```
composer install
```

Create environment file

```
cp .env.example .env
```

Configure database

```
DB_DATABASE=saas
DB_USERNAME=root
DB_PASSWORD=
```

Generate key

```
php artisan key:generate
```

Run migrations

```
php artisan migrate
```

Install Filament

```
php artisan filament:install
```

Seed roles and permissions

```
php artisan db:seed
```

Start API server

```
php artisan serve
```

Backend URL

```
http://127.0.0.1:8000
```

---

# Frontend Setup

```
cd frontend
```

Install dependencies

```
npm install
```

Create environment file

```
cp .env.example .env
```

Add API URL

```
NUXT_PUBLIC_API_URL=http://127.0.0.1:8000/api/v1
```

Start development server

```
npm run dev
```

Frontend URL

```
http://localhost:3000
```

---

# Pinia State Management

Auth store handles

```
user
roles
permissions
login()
logout()
fetchUser()
```

Theme store handles

```
theme
toggleTheme()
```

---

# Route Protection

## Backend

Using middleware

```
auth:sanctum
role:admin
permission:view reports
```

## Frontend

Nuxt middleware

```
auth.ts
guest.ts
role.ts
```

Example

```
definePageMeta({
  middleware: ['auth']
})
```

---

# Production Build

## Backend

```
php artisan config:cache
php artisan route:cache
php artisan optimize
```

## Frontend

```
npm run build
npm run preview
```

---

# Security Notes

* Sanctum authentication
* cookie-based tokens
* no sensitive data in localStorage
* role-based UI
* backend permission enforcement

---

# Future SaaS Upgrades

* Stripe billing
* multi-tenancy
* SaaS subscriptions
* notification system
* usage analytics
* audit logs

---

# License

MIT
