resource "oci_load_balancer_load_balancer" "load_balancer" {
    compartment_id = var.compartment_ocid
    display_name = join("-", ["lb", var.name]) 
    shape = "flexible"
    subnet_ids = [var.subnet_id]
    shape_details {
        maximum_bandwidth_in_mbps = 10
        minimum_bandwidth_in_mbps = 10
    }
}

resource "oci_load_balancer_certificate" "certificate" {
    certificate_name = "cert-api-agateway"
    load_balancer_id = oci_load_balancer_load_balancer.load_balancer.id
    ca_certificate = <<-EOT
      -----BEGIN CERTIFICATE-----
      MIIE9DCCA9ygAwIBAgIQCF+UwC2Fe+jMFP9T7aI+KjANBgkqhkiG9w0BAQsFADBh
      MQswCQYDVQQGEwJVUzEVMBMGA1UEChMMRGlnaUNlcnQgSW5jMRkwFwYDVQQLExB3
      d3cuZGlnaWNlcnQuY29tMSAwHgYDVQQDExdEaWdpQ2VydCBHbG9iYWwgUm9vdCBH
      MjAeFw0yMDA5MjQwMDAwMDBaFw0zMDA5MjMyMzU5NTlaMFkxCzAJBgNVBAYTAlVT
      MRUwEwYDVQQKEwxEaWdpQ2VydCBJbmMxMzAxBgNVBAMTKkRpZ2lDZXJ0IEdsb2Jh
      bCBHMiBUTFMgUlNBIFNIQTI1NiAyMDIwIENBMTCCASIwDQYJKoZIhvcNAQEBBQAD
      ggEPADCCAQoCggEBAMz3EGJPprtjb+2QUlbFbSd7ehJWivH0+dbn4Y+9lavyYEEV
      cNsSAPonCrVXOFt9slGTcZUOakGUWzUb+nv6u8W+JDD+Vu/E832X4xT1FE3LpxDy
      FuqrIvAxIhFhaZAmunjZlx/jfWardUSVc8is/+9dCopZQ+GssjoP80j812s3wWPc
      3kbW20X+fSP9kOhRBx5Ro1/tSUZUfyyIxfQTnJcVPAPooTncaQwywa8WV0yUR0J8
      osicfebUTVSvQpmowQTCd5zWSOTOEeAqgJnwQ3DPP3Zr0UxJqyRewg2C/Uaoq2yT
      zGJSQnWS+Jr6Xl6ysGHlHx+5fwmY6D36g39HaaECAwEAAaOCAa4wggGqMB0GA1Ud
      DgQWBBR0hYDAZsffN97PvSk3qgMdvu3NFzAfBgNVHSMEGDAWgBROIlQgGJXm427m
      D/r6uRLtBhePOTAOBgNVHQ8BAf8EBAMCAYYwHQYDVR0lBBYwFAYIKwYBBQUHAwEG
      CCsGAQUFBwMCMBIGA1UdEwEB/wQIMAYBAf8CAQAwdgYIKwYBBQUHAQEEajBoMCQG
      CCsGAQUFBzABhhhodHRwOi8vb2NzcC5kaWdpY2VydC5jb20wQAYIKwYBBQUHMAKG
      NGh0dHA6Ly9jYWNlcnRzLmRpZ2ljZXJ0LmNvbS9EaWdpQ2VydEdsb2JhbFJvb3RH
      Mi5jcnQwewYDVR0fBHQwcjA3oDWgM4YxaHR0cDovL2NybDMuZGlnaWNlcnQuY29t
      L0RpZ2lDZXJ0R2xvYmFsUm9vdEcyLmNybDA3oDWgM4YxaHR0cDovL2NybDQuZGln
      aWNlcnQuY29tL0RpZ2lDZXJ0R2xvYmFsUm9vdEcyLmNybDAwBgNVHSAEKTAnMAcG
      BWeBDAEBMAgGBmeBDAECATAIBgZngQwBAgIwCAYGZ4EMAQIDMA0GCSqGSIb3DQEB
      CwUAA4IBAQB1i8A8W+//cFxrivUh76wx5kM9gK/XVakew44YbHnT96xC34+IxZ20
      dfPJCP2K/lHz8p0gGgQ1zvi2QXmv/8yWXpTTmh1wLqIxi/ulzH9W3xc3l7/BjUOG
      q4xmfrnti/EPjLXUVa9ciZ7gpyptsqNjMhg7y961n4OzEQGsIA2QlxK3KZw1tdeR
      Du9Ab21cO72h2fviyy52QNI6uyy/FgvqvQNbTpg6Ku0FUAcVkzxzOZGUWkgOxtNK
      Aa9mObm9QjQc2wgD80D8EuiuPKuK1ftyeWSm4w5VsTuVP61gM2eKrLanXPDtWlIb
      1GHhJRLmB7WqlLLwKPZhJl5VHPgB63dx
      -----END CERTIFICATE-----
      EOT
    public_certificate = <<-EOT
      -----BEGIN CERTIFICATE-----
      MIIHGzCCBgOgAwIBAgIQCLSYQrmKJNBTiPfu46zRNzANBgkqhkiG9w0BAQsFADBZ
      MQswCQYDVQQGEwJVUzEVMBMGA1UEChMMRGlnaUNlcnQgSW5jMTMwMQYDVQQDEypE
      aWdpQ2VydCBHbG9iYWwgRzIgVExTIFJTQSBTSEEyNTYgMjAyMCBDQTEwHhcNMjEw
      NTA2MDAwMDAwWhcNMjIwNTExMjM1OTU5WjCBkTELMAkGA1UEBhMCVVMxEzARBgNV
      BAgTCkNhbGlmb3JuaWExFTATBgNVBAcTDFJlZHdvb2QgQ2l0eTEbMBkGA1UEChMS
      T3JhY2xlIENvcnBvcmF0aW9uMTkwNwYDVQQDDDAqLmFwaWdhdGV3YXkuZXUtZnJh
      bmtmdXJ0LTEub2NpLmN1c3RvbWVyLW9jaS5jb20wggEiMA0GCSqGSIb3DQEBAQUA
      A4IBDwAwggEKAoIBAQCzdiugH5LcGIzZ3vZF0AJLjh81Qi83i4GHt7tZcRWVJ1kY
      ui05APoUP94P8PB7WIzbySbnaxIl+Ol0OW+Ru7bJ604jVgZOsSdZ/353Agt6xvA1
      NKrV9DUK4wSQgjOB9Is3Si5Gzmi1wPVTMLPc+ob9nnd6uw+lhKsyI0L/6jUMBb3G
      RcY3b+w5y1bhcIk4ztkyU+WxkZEe8KCxP7Lapo7/zYSu2s3T0QP4ZLUx371t4B9g
      wfgDpuFZdt0BnK/wmZs6By7fv3tAhrPHcEA1eFNCh28KRlhAK9G9rQRlj9pStlf7
      bC2xVDqLnOmflatbsCuOnTUhJrKvmbvoQO9YXOcJAgMBAAGjggOkMIIDoDAfBgNV
      HSMEGDAWgBR0hYDAZsffN97PvSk3qgMdvu3NFzAdBgNVHQ4EFgQUH465fvHYFoCk
      HGoeicadchhExMYwOwYDVR0RBDQwMoIwKi5hcGlnYXRld2F5LmV1LWZyYW5rZnVy
      dC0xLm9jaS5jdXN0b21lci1vY2kuY29tMA4GA1UdDwEB/wQEAwIFoDAdBgNVHSUE
      FjAUBggrBgEFBQcDAQYIKwYBBQUHAwIwgZsGA1UdHwSBkzCBkDBGoESgQoZAaHR0
      cDovL2NybDMuZGlnaWNlcnQuY29tL0RpZ2lDZXJ0R2xvYmFsRzJUTFNSU0FTSEEy
      NTYyMDIwQ0ExLmNybDBGoESgQoZAaHR0cDovL2NybDQuZGlnaWNlcnQuY29tL0Rp
      Z2lDZXJ0R2xvYmFsRzJUTFNSU0FTSEEyNTYyMDIwQ0ExLmNybDA+BgNVHSAENzA1
      MDMGBmeBDAECAjApMCcGCCsGAQUFBwIBFhtodHRwOi8vd3d3LmRpZ2ljZXJ0LmNv
      bS9DUFMwgYUGCCsGAQUFBwEBBHkwdzAkBggrBgEFBQcwAYYYaHR0cDovL29jc3Au
      ZGlnaWNlcnQuY29tME8GCCsGAQUFBzAChkNodHRwOi8vY2FjZXJ0cy5kaWdpY2Vy
      dC5jb20vRGlnaUNlcnRHbG9iYWxHMlRMU1JTQVNIQTI1NjIwMjBDQTEuY3J0MAwG
      A1UdEwEB/wQCMAAwggF8BgorBgEEAdZ5AgQCBIIBbASCAWgBZgB2AEalVet1+pEg
      MLWiiWn0830RLEF0vv1JuIWr8vxw/m1HAAABeUMjcqQAAAQDAEcwRQIgNaB/SFRK
      iQfeVtIhxKXudsgChcIvbEk5zeJ41736qJUCIQC3Xvd2c0/rO7PHAv7yw1UxzPnJ
      RYUejc8JTxbHq5jj0AB1ACJFRQdZVSRWlj+hL/H3bYbgIyZjrcBLf13Gg1xu4g8C
      AAABeUMjcsQAAAQDAEYwRAIgEJSdzbVSnWuqy5rznGtvAYhG2AJaPYd71lC85zaI
      4LQCIBs9Fl1V5SqH306oU15elc45mE0r3UxL7JzjTo+KqOBIAHUAUaOw9f0BeZxW
      bbg3eI8MpHrMGyfL956IQpoN/tSLBeUAAAF5QyNxKgAABAMARjBEAiB+ureijJY7
      nOT9u4SqKUAEhWAhgPQxJm1je1UW+QuVqQIgBtcZPGHRA7HW+Btx7PKM3Rpe/DO4
      aaj+wab5PY6fFcEwDQYJKoZIhvcNAQELBQADggEBABJ+9WOz1k/ty9BUzqhcSpNR
      1Dk0a60EvQE3Lg99C/LiNtkn/puz0rm/191B8lNQaQLPGZyhNlrRO0kvnrtnVst2
      8/qD4dpuU4XXtvhAEcXLisBog2p6h2xbkaJsaJ57ewdzg284zi98ENGosJUREdvx
      oMNmwvGjPCtQv5s5tBlTpFiYng7UXm6Ne5GEMi4eKxjYkLGJQC/+vpFvw1nKpxW+
      tsMj85Dn/lDTNc/BNHw4lxIEaiOSjbpPSXgjTs3uU5e8+7/I+H0YELLXgfPEnnCq
      fWrRrjzZF8eJixGApIL8IPxc/k7XINc1i6EwoCeSLZnShW7aRfF964WFU82CaCg=
      -----END CERTIFICATE-----
      
      EOT
    lifecycle {
        create_before_destroy = true
    }
}

resource "oci_load_balancer_backend_set" "backend_set" {
    health_checker {
        protocol = "HTTP"
        interval_ms = 1000
        port = 443
        retries = 5
        return_code = 200
        timeout_in_millis = 10000
        url_path = "/geo/portal"
    }
    load_balancer_id = oci_load_balancer_load_balancer.load_balancer.id
    name = join("-", ["bs", var.name, "1"]) 
    policy = "ROUND_ROBIN"
    ssl_configuration {
        certificate_name = oci_load_balancer_certificate.certificate.certificate_name
        cipher_suite_name = "oci-wider-compatible-ssl-cipher-suite-v1"
        protocols = ["TLSv1.2", "TLSv1", "TLSv1.1"]
        verify_depth = 1
        verify_peer_certificate = false
    }
}

resource "oci_load_balancer_listener" "listener" {
    default_backend_set_name = oci_load_balancer_backend_set.backend_set.name
    load_balancer_id = oci_load_balancer_load_balancer.load_balancer.id
    name = join("-", ["lstn", var.name]) 
    port = 80
    protocol = "HTTP"
}