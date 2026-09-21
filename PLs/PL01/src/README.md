# Starter da PL1

Complete os dois pontos marcados com `TODO`:

1. o pipeline de contagem em `wordcount.sh`;
2. a função `reduce_sorted` em `mr-wordcount.c`.

O contrato completo, os comandos e o pseudocódigo estão em
`../guide/PL1.md`.

Depois de implementar as tarefas:

```bash
chmod +x wordcount.sh
make
make test
```

O teste compara a saída do programa C com a saída do script Bash. Não altere
os ficheiros em `data/` nem o script de testes para fazer o teste passar.
