# Site da Phone Cart (phonecart.com.br): cópia da build da Lovable servida por Nginx.
# Variável obrigatória: FORMULARIO_WEBHOOK = endereço do webhook do formulário na plataforma
#   (Painel → CRM → Formulários → "Troca de aparelho (site phonecart.com.br)" → Webhook).
FROM nginx:1.27-alpine
COPY nginx.conf /etc/nginx/conf.d/default.conf
COPY 40-webhook-formulario.sh /docker-entrypoint.d/40-webhook-formulario.sh
RUN chmod +x /docker-entrypoint.d/40-webhook-formulario.sh
COPY public/ /usr/share/nginx/html/
EXPOSE 80
HEALTHCHECK --interval=30s --timeout=3s CMD wget -qO- http://127.0.0.1/saude >/dev/null || exit 1
