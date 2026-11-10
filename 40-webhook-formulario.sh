#!/bin/sh
# Põe o endereço do webhook do formulário no JS do site ao ligar o container.
# Sempre parte da cópia original (com o marcador), então trocar a variável e reiniciar funciona.
# Sem a variável o container não sobe (melhor que um site com formulário quebrado).
set -eu
if [ -z "${FORMULARIO_WEBHOOK:-}" ]; then
  echo "ERRO: defina FORMULARIO_WEBHOOK (webhook do formulário na plataforma)" >&2
  exit 1
fi
case "$FORMULARIO_WEBHOOK" in
  https://*|http://*) ;;
  *) echo "ERRO: FORMULARIO_WEBHOOK precisa começar com https://" >&2; exit 1 ;;
esac
case "$FORMULARIO_WEBHOOK" in
  *'"'*|*'\'*|*'|'*|*'&'*|*' '*) echo "ERRO: FORMULARIO_WEBHOOK com caractere inválido" >&2; exit 1 ;;
esac
MODELO=/opt/phonecart-modelo
mkdir -p "$MODELO"
for f in /usr/share/nginx/html/assets/index-*.js; do
  m="$MODELO/$(basename "$f")"
  [ -f "$m" ] || cp "$f" "$m"
  grep -q '__FORMULARIO_WEBHOOK__' "$m" || { echo "ERRO: marcador do webhook não está em $(basename "$f")" >&2; exit 1; }
  sed "s|__FORMULARIO_WEBHOOK__|${FORMULARIO_WEBHOOK}|" "$m" > "$f"
  echo "webhook do formulário configurado em $(basename "$f")"
done
