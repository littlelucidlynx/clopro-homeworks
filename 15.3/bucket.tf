# Бакет

# Симметричный ключ
resource "yandex_kms_symmetric_key" "bucket_key" {
  name              = "bucket-encryption-key"
  description       = "ключ для шифрования бакета"
  default_algorithm = "AES_256"
  rotation_period   = "48h"
  
  # Настройки прав доступа
  lifecycle {
    create_before_destroy = true
  }
}

# Статический ключ доступа
resource "yandex_iam_service_account_static_access_key" "sa-static-key" {
  service_account_id = var.service_account_id
  description        = "static access key for object storage"
}

# Создание бакета с использованием статического ключа
resource "yandex_storage_bucket" "clopro-bucket" {
  access_key = yandex_iam_service_account_static_access_key.sa-static-key.access_key
  secret_key = yandex_iam_service_account_static_access_key.sa-static-key.secret_key
  bucket     = local.bucket_name

  server_side_encryption_configuration {
  rule {
    apply_server_side_encryption_by_default {
      kms_master_key_id = yandex_kms_symmetric_key.bucket_key.id
      sse_algorithm     = "aws:kms"
    }
    }
  }

  anonymous_access_flags {
    read = true
  }
}