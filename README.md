# G&A · Guilherme & Anna

Painel do casal: cofrinho do casamento, decisões, casamento, lua de mel, futuro, nossa história, inspirações e conversas importantes.

É um site estático (um único `index.html`). Os dados e as fotos ficam no Supabase, então tudo o que um de vocês muda aparece para o outro, em qualquer aparelho, e continua salvo no dia seguinte.

## Publicar

1. Crie um repositório no GitHub e suba os arquivos desta pasta (`index.html`, `vercel.json`, `README.md` e a pasta `supabase`).
2. Na Vercel: **Add New → Project**, escolha o repositório e clique em **Deploy**. Não precisa configurar nada: não tem build nem variáveis de ambiente.
3. Pronto. O link da Vercel é o link do painel. Cada `git push` publica a nova versão.

## Banco de dados

- Projeto Supabase: `gxywpcnafudktgmygxbz`
- Tabela `ga_docs` (dados do painel) e bucket `ga-fotos` (fotos), já criados.
- `supabase/schema.sql` tem tudo o que foi criado, caso um dia precisem montar o banco em outro projeto. Depois troque `SB_URL` e `SB_KEY` no começo do `index.html`.

## Acesso

O painel não tem senha: qualquer pessoa com o link consegue ver e editar. Compartilhem o link só entre vocês dois. A página pede aos buscadores para não indexá-la.
