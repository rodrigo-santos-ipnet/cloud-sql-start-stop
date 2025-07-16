### 📄 `modules/cloudsql-scheduler/README.md`

````markdown
# ☁️ Cloud SQL Scheduler Module (Terraform)

Este módulo cria rotinas automatizadas para **iniciar (`start`) e parar (`stop`) instâncias do Cloud SQL** utilizando o **Cloud Scheduler** no GCP.

Ele cuida de:

✅ Criação de uma Service Account específica  
✅ Atribuição da role `roles/cloudsql.editor`  
✅ Criação de jobs do Cloud Scheduler para iniciar e parar instâncias SQL  
✅ Frequências configuráveis por instância  
✅ Compatível com múltiplas instâncias SQL

---

## 📦 Utilização

### 1. Estrutura recomendada do projeto

```bash
infra/
├── main.tf
├── variables.tf
├── terraform.tfvars
└── modules/
    └── cloudsql-scheduler/
        ├── main.tf
        ├── variables.tf
        └── README.md
````

---

### 2. Exemplo de uso

#### 📄 `main.tf`

```hcl
module "cloudsql_scheduler" {
  source               = "./modules/cloudsql-scheduler"
  project_id           = var.project_id
  region               = var.region
  scheduler_sa_name    = var.scheduler_sa_name
  instances            = var.instances
}
```

#### 📄 `variables.tf`

```hcl
variable "project_id" {
  type = string
}

variable "region" {
  type    = string
  default = "us-central1"
}

variable "scheduler_sa_name" {
  type    = string
  default = "cloud-scheduler-sql"
}

variable "instances" {
  type = map(object({
    start_frequency = optional(string, "0 8 * * MON-FRI")
    stop_frequency  = optional(string, "0 20 * * MON-FRI")
  }))
}
```

#### 📄 `terraform.tfvars`

```hcl
project_id = "meu-projeto-id"
region     = "us-central1"

instances = {
  "prod-db-instance" = {
    start_frequency = "0 8 * * MON-FRI"
    stop_frequency  = "0 20 * * MON-FRI"
  }

  "dev-db-instance" = {
    start_frequency = "0 9 * * MON-FRI"
    stop_frequency  = "0 18 * * MON-FRI"
  }

  "sandbox-db-instance" = {} # Frequência padrão
}

scheduler_sa_name = "cloud-scheduler-sql"
```

---

## ⚙️ Variáveis do módulo

| Variável            | Tipo          | Obrigatória | Default                 | Descrição                                               |
| ------------------- | ------------- | ----------- | ----------------------- | ------------------------------------------------------- |
| `project_id`        | `string`      | ✅ Sim       | —                       | ID do projeto GCP                                       |
| `region`            | `string`      | ✅ Sim       | —                       | Região onde os jobs serão criados                       |
| `scheduler_sa_name` | `string`      | ❌ Não       | `"cloud-scheduler-sql"` | Nome da service account a ser criada                    |
| `instances`         | `map(object)` | ✅ Sim       | —                       | Mapa com os nomes das instâncias SQL e suas frequências |

---

## 📤 Outputs

| Nome                    | Descrição                        |
| ----------------------- | -------------------------------- |
| `service_account_email` | Email da Service Account criada  |
| `scheduler_jobs`        | Lista dos nomes dos jobs criados |

---

## 🧠 Notas

* A Service Account criada recebe automaticamente a role `roles/cloudsql.editor` no projeto.
* Os jobs usam `PATCH` com `activationPolicy = "ALWAYS"` para iniciar e `"NEVER"` para parar.
* O escopo de autenticação usado é `https://www.googleapis.com/auth/cloud-platform`.

---

## 🚀 Requisitos

* Terraform >= 1.3
* Provider Google >= 4.0
* Permissão para criar Cloud Scheduler Jobs e Service Accounts no projeto GCP

---

## 📎 Exemplo de Job Criado

```json
{
  "settings": {
    "activationPolicy": "NEVER"
  }
}
```

## ✅ Adicionar novas instâncias

Para adicionar novas instâncias basta adicionar no arquivo terraform.tfvars

```tf
project_id = "lab-msp-cs-labk8s"
region     = "us-central1"

instances = {
  "test-instance-1" = {
    start_frequency = "0 8 * * MON-FRI"
    stop_frequency  = "0 20 * * MON-FRI"
  }

  "test-instance-2" = {
    start_frequency = "0 7 * * MON-FRI"
    stop_frequency  = "0 19 * * MON-FRI"
  }

  "test-instance-3" = {} # usa os valores padrão


}
```

---

## 📬 Suporte

Contribuições e melhorias são bem-vindas!

