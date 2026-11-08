# Arquitetura — Lab 011: Introdução ao Amazon EC2

## Topologia lógica

```mermaid
flowchart LR
    browser["Cliente HTTP<br/>Navegador"]
    subgraph region["AWS — região configurada pelo laboratório"]
        subgraph vpc["Lab VPC — pré-existente"]
            subgraph az["Availability Zone"]
                sg["Security Group<br/>Web Server security group"]
                ec2["EC2: Web Server<br/>Amazon Linux 2023<br/>Apache httpd"]
                ebs[("EBS raiz<br/>8 GiB → 10 GiB")]
            end
        end
        cloudwatch["CloudWatch<br/>Métricas EC2"]
    end
    browser -->|"IPv4 público — TCP/80"| sg
    sg --> ec2
    ec2 --- ebs
    ec2 -.->|"métricas"| cloudwatch
```

O diagrama representa a associação lógica entre os componentes. O Security Group não é um equipamento intermediário; suas regras são aplicadas à interface de rede vinculada à instância EC2. A VPC já está disponibilizada no ambiente do treinamento e o roteiro não especifica os detalhes de suas sub-redes ou rotas.

## Fluxo de acesso HTTP

```mermaid
flowchart TD
    req["Requisição HTTP ao IPv4 público da EC2"]
    rule{"Regra de entrada TCP/80 no SG?"}
    block["Acesso negado pela política de entrada"]
    pass["Tráfego permitido, se a rede estiver roteável"]
    apache["Apache HTTP Server — porta 80"]
    html["Resposta HTML: Hello From Your Web Server!"]
    req --> rule
    rule -->|"Não — situação inicial"| block
    rule -->|"Sim — após a etapa 3"| pass
    pass --> apache
    apache --> html
```

A regra de entrada definida no exercício é:

| Parâmetro | Valor |
|---|---|
| Security Group | `Web Server security group` |
| Direção | Inbound |
| Protocolo | TCP |
| Porta | 80 |
| Origem | `0.0.0.0/0` (`Anywhere-IPv4`) |
| SSH | Sem regra de entrada SSH no roteiro |

> A presença da regra HTTP não resolve, sozinha, problemas de roteamento, endereçamento público ou inicialização do servidor. O roteiro pressupõe conectividade adequada da infraestrutura pré-configurada.

## Evolução da capacidade

```mermaid
flowchart LR
    initial["Configuração inicial<br/>t3.micro<br/>2 vCPU / 1 GiB RAM<br/>EBS 8 GiB"]
    stop["Parar EC2"]
    resize["Alterar tipo e volume<br/>t3.small / EBS 10 GiB"]
    start["Iniciar EC2<br/>Conferir novo IPv4 público"]
    initial --> stop --> resize --> start
```

O redimensionamento do volume EBS e a ampliação da partição e do sistema de arquivos do Linux são operações distintas. A ampliação interna não é solicitada no roteiro de treinamento fornecido.

## Proteção e descarte

```mermaid
flowchart TD
    running["Instância EC2 em execução<br/>Proteção contra encerramento habilitada"]
    attempt["Solicitação Terminate"]
    denied["Encerramento bloqueado"]
    disable["Desabilitar termination protection"]
    retry["Nova solicitação Terminate"]
    done["Instância encerrada"]
    running --> attempt --> denied --> disable --> retry --> done
```

## Limites e suposições

- O laboratório apresenta **uma única instância EC2** em **uma Availability Zone**; não configura balanceamento de carga nem alta disponibilidade.
- A `Lab VPC` é pressuposta como existente. A criação da VPC, sub-rede e gateway não faz parte deste roteiro.
- O acesso à página ocorre por HTTP com IPv4 público, após a liberação do Security Group.
- O disco raiz EBS inicia com 8 GiB e é configurado para 10 GiB.
- A instância é lançada sem key pair porque **não há atividade de acesso SSH**.
- O monitoramento apresentado utiliza as verificações nativas de status do EC2 e métricas do CloudWatch.

[Voltar ao README do laboratório](../README.md)
