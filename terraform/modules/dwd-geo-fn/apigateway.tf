resource "oci_apigateway_gateway" "apigateway_gateway" {
    compartment_id = var.compartment_ocid
    endpoint_type = "PUBLIC"
    subnet_id = var.subnet_id
    display_name = join("-", [var.gateway_display_name, var.color])
}

resource "oci_apigateway_deployment" "deployment_apri_retriever" {
    compartment_id = var.compartment_ocid
    gateway_id = oci_apigateway_gateway.apigateway_gateway.id
    path_prefix = var.deployment_path_prefix
    display_name = var.deployment_display_name
    specification {
        routes {
            backend {
                type = "ORACLE_FUNCTIONS_BACKEND"
                function_id = oci_functions_function.function.id
            }
            path = var.deployment_route_path_api_retriever
            methods = var.deployment_http_methods_api_retriever
        }
        routes {
            backend {
                type = "STOCK_RESPONSE_BACKEND"
                body = <<EOT
                    <!DOCTYPE html>
                    <html lang="en">
                        <head>
                            <title>Geoportal DevOps Demo</title>
                            <link href="https://fonts.googleapis.com/css?family=Roboto+Slab" rel="stylesheet">
                            <script src='https://cdnjs.cloudflare.com/ajax/libs/vue/2.5.13/vue.js'></script>
                            <script src='https://cdnjs.cloudflare.com/ajax/libs/axios/0.18.0/axios.js'></script>
                            <style>
                                body {
                                    display: flex;
                                    justify-content: center;
                                    background-image: url(https://dwd-geoportal.de/_nuxt/img/mhpcm02_201801080950_hu-cropped.d0e1bd4.jpg);
                                    font-family: "Roboto Slab", serif;
                                    line-height: 1.4;
                                }
                                #app {
                                    margin-top: 20px;
                                    width: 500px;
                                    padding: 0 40px 40px;
                                    background: ${var.color == "blue" ? "#2d4b9b" : "green"} ;
                                    border-radius: 5px;
                                    color: #B3BFB8;
                                }
                                h1 {
                                    color: #F0F7F4;
                                }
                                .lighten {
                                    color: white;
                                }
                            </style>
                        </head>
                        <body translate="no">
                            <div id="app">
                                <h1>BSI index from python fn backend:</h1>
                                <span class="lighten">
                                    <span>USD: </span>{{ prices.usd | currencydecimal }}<br />
                                    <span>EUR: </span>{{ prices.eur | currencydecimal }}
                                </span>
                            </div>
                            <script id="rendered-js">
                                new Vue({
                                    el: '#app',
                                    data() {
                                        return {
                                            prices: {}
                                        };
                                    },
                                    filters: {
                                        currencydecimal (value = 0) {
                                            return value.toFixed(2)
                                        }
                                    },
                                    mounted() {
                                        axios.
                                            post('${var.deployment_path_prefix}${var.deployment_route_path_api_retriever}', {}).
                                            then(response => this.prices = response.data);
                                    }
                                });
                            </script>
                        </body>
                    </html>
                    EOT
                status = 200
                headers {
                  name = "Content-Type"
                  value = "text/html"
                }
            }
            path = var.deployment_route_path_frontend
            methods = var.deployment_http_methods_frontend
        }
    }
}