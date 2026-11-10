# Site da Phone Cart (phonecart.com.br)

Cópia fiel da build publicada pela Lovable (feita pela Beever), servida por Nginx na nossa VPS.
O primeiro commit desta pasta é a build **sem nenhuma mudança**; o `git diff` a partir dele mostra tudo o que trocamos.

## O que mudou em relação ao site antigo
- **Formulário "Cart Upgrade"**: o POST que ia para o n8n antigo (`.../webhook/formlp`) agora vai para o endereço da variável
  `FORMULARIO_WEBHOOK` (o webhook do formulário "Troca de aparelho (site phonecart.com.br)" na plataforma). O JSON é o mesmo
  de antes (`modelo, cor, capacidade, condicao, problema, nome, whatsapp, timestamp, formStartTime`) e agora leva também as UTMs
  da visita (`utm_*`, `gclid`, `gbraid`, `wbraid`, `fbclid`) e a `pagina`, para o CRM saber a origem do lead.
- **Removido**: rastreadores da Lovable (`/~flock.js`, `/__l5e/...`) e o envio de eventos para o Supabase da Beever (`site-event`).
- **Mantido**: Google Tag Manager `GTM-5Q38MQ4M` (que carrega Pixel da Meta, GA4 e Google Ads), textos, imagens, cores, mapa,
  links do WhatsApp e Instagram, rodapé.
- Ícone e imagem de compartilhamento servidos daqui (`/favicon.png`), sem depender da Lovable. `lang="pt-BR"`.

## Rodar
```bash
docker build -t phonecart-site .
docker run -d -p 127.0.0.1:8088:80 -e FORMULARIO_WEBHOOK=https://<plataforma>/f/<codigo>/w/<segredo> phonecart-site
```
Sem `FORMULARIO_WEBHOOK` (ou com valor que não começa com `http`) o container não sobe. Saúde em `/saude`.

## Pôr no ar (Easypanel)
1. Novo serviço **App** no projeto, origem Git deste repositório (willianbrognoli/phonecart-site, branch main), **Build path** `/`, Dockerfile.
2. Variável `FORMULARIO_WEBHOOK` = webhook mostrado no Painel → CRM → Formulários → "Troca de aparelho (site phonecart.com.br)".
   O webhook do formulário precisa estar **ligado**.
3. Domínios `phonecart.com.br` e `www.phonecart.com.br` (HTTPS) apontando para a porta 80 do serviço.
4. Trocar o DNS do domínio (registro A/CNAME) para a VPS. Até o DNS mudar, o site antigo continua no ar mandando para o n8n.
5. Depois de conferir um envio real chegando no CRM: desligar o fluxo `enviarFormulario` no n8n antigo.

Trocar o endereço do webhook: mudar a variável e reiniciar (o script sempre parte da cópia original do JS).
