# Бакет

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
  acl        = "public-read"
}

# Загрузка изображения в бакет
resource "yandex_storage_object" "image" {
  access_key = yandex_iam_service_account_static_access_key.sa-static-key.access_key
  secret_key = yandex_iam_service_account_static_access_key.sa-static-key.secret_key
  bucket     = local.bucket_name
  key        = "image.jpg"
  source     = "image.jpg"
  acl        = "public-read"
  depends_on = [yandex_storage_bucket.clopro-bucket]
}