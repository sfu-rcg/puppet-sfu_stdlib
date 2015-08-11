class sfu_stdlib {
  notify { "service_provider: ${::service_provider}": }
  $default_service_provider = default_service_provider_merge()
  notify { "default_service_provider: ${default_service_provider}": }
}
