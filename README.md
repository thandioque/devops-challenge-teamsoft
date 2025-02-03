# DevOps Challenge - Server

Este projeto demonstra a configuração de uma infraestrutura de servidor utilizando Terraform, Docker Compose, Nginx, Grafana e Prometheus, com integração com GitHub Actions para CI/CD. O objetivo principal é provisionar e configurar um servidor para monitoramento e deploy de aplicações, seguindo princípios de Infraestrutura como Código (IaC).

This is a challenge by Coodesh.

# GitHub Actions Pipelines Documentation

### Pipelines

### 1. **Server Pipeline CI/CD to EC2** (`.github/workflows/server-pipe.yml`)

Esse pipeline é responsável por realizar o CI/CD para uma aplicação hospedada em uma instância EC2. Ele realiza os seguintes passos:

#### Eventos:
- **push**: Dispara para a branch `main` sempre que houver alteração nos diretórios `src/` ou `nginx/`.
- **pull_request**: Dispara para a branch `main` em pull requests, quando houver alterações nos diretórios `src/` ou `nginx/`.
- **workflow_dispatch**: Permite a execução manual do pipeline.

#### Jobs:
- **CI**:
  - **Checkout repository**: Faz checkout do repositório.
  - **Validate docker-compose.yml**: Valida a configuração do arquivo `docker-compose.yml`.

- **CD**:
  - **Checkout repository**: Faz checkout do repositório.
  - **Setup git credentials**: Configura as credenciais do Git.
  - **Deploy application using Docker Compose**: Realiza o deploy da aplicação utilizando o Docker Compose.
  - **Setup thr server public IP**: Configura o IP público do servidor para substituição no arquivo de configuração do Nginx.
  - **Setup Nginx**: Configura o Nginx para apontar para o arquivo de configuração correto.
  - **Validate Nginx settings and restart the service**: Valida as configurações do Nginx e reinicia o serviço.

### 2. **Terraform Apply** (`.github/workflows/terraform-apply-pipe.yml`)

Este pipeline executa o comando `terraform apply` para aplicar as mudanças de infraestrutura na AWS, criando ou alterando recursos de acordo com a configuração do Terraform.

#### Eventos:
- **push**: Dispara para a branch `main` sempre que houver alterações nos arquivos dentro do diretório `terraform/`.
- **workflow_dispatch**: Permite a execução manual do pipeline.

#### Jobs:
- **apply**:
  - **Checkout**: Faz checkout do repositório.
  - **Setup Terraform**: Instala a versão especificada do Terraform.
  - **Setup github auth**: Configura a autenticação do GitHub com o token fornecido.
  - **Setup secret values in the EC2's install file**: Substitui valores de variáveis no script de instalação do EC2.
  - **Terraform fmt**: Verifica se o código do Terraform está formatado corretamente.
  - **Terraform Init**: Inicializa o Terraform com o backend configurado.
  - **Terraform Validate**: Valida a configuração do Terraform.
  - **Terraform Apply**: Aplica as mudanças no Terraform, utilizando variáveis sensíveis passadas através de secrets.

### 3. **Terraform Destroy** (`.github/workflows/terraform-destroy-pipe.yml`)

Este pipeline executa o comando `terraform destroy` para destruir os recursos de infraestrutura provisionados pelo Terraform.

#### Eventos:
- **workflow_dispatch**: Permite a execução manual do pipeline.

#### Jobs:
- **destroy**:
  - **Checkout**: Faz checkout do repositório.
  - **Setup Terraform**: Instala a versão especificada do Terraform.
  - **Setup github auth**: Configura a autenticação do GitHub com o token fornecido.
  - **Setup secret values in the EC2's install file**: Substitui valores de variáveis no script de instalação do EC2.
  - **Terraform fmt**: Verifica se o código do Terraform está formatado corretamente.
  - **Terraform Init**: Inicializa o Terraform com o backend configurado.
  - **Terraform Validate**: Valida a configuração do Terraform.
  - **Terraform Destroy**: Destrói os recursos do Terraform, com opções para destruir apenas módulos específicos (ex: EC2 e VPC).

### 4. **Terraform Plan** (`.github/workflows/terraform-plan-pipe.yml`)

Este pipeline executa o comando `terraform plan` para gerar o plano de execução do Terraform, mostrando as mudanças propostas para a infraestrutura.

#### Eventos:
- **pull_request**: Dispara para a branch `main` sempre que houver alterações nos arquivos dentro do diretório `terraform/`.
- **workflow_dispatch**: Permite a execução manual do pipeline.

#### Jobs:
- **plan**:
  - **Checkout**: Faz checkout do repositório.
  - **Setup Terraform**: Instala a versão especificada do Terraform.
  - **Setup github auth**: Configura a autenticação do GitHub com o token fornecido.
  - **Setup secret values in the EC2's install file**: Substitui valores de variáveis no script de instalação do EC2.
  - **Terraform fmt**: Verifica se o código do Terraform está formatado corretamente.
  - **Terraform Init**: Inicializa o Terraform com o backend configurado.
  - **Terraform Validate**: Valida a configuração do Terraform.
  - **Terraform Plan**: Gera o plano de execução do Terraform.
  - **Show plan in the Pull Request**: Exibe o plano de execução como um comentário no Pull Request para revisão.

## Componentes de Monitoramento: Grafana, Prometheus e Node Exporter

Componentes responsáveis por coletar e visualizar as métricas do servidor e das aplicações.

### Componentes

*   **Grafana:**  É uma plataforma de visualização de dados e dashboards.  Neste projeto, o Grafana é utilizado para criar dashboards interativos que exibem as métricas coletadas pelo Prometheus.

*   **Prometheus:** É um sistema de monitoramento e alerta de código aberto.  Ele coleta métricas de vários serviços, armazena-as em um banco de dados time-series e oferece uma linguagem de consulta (PromQL) para analisar esses dados.  Neste projeto, o Prometheus coleta métricas do Node Exporter e dele mesmo.

*   **Node Exporter:** É um agente que é executado no servidor e expõe métricas do sistema operacional (CPU, memória, disco, rede, etc.) para o Prometheus.

### Configuração

#### `src/docker-compose.yml`

Este arquivo define os serviços Docker que compõem a solução de monitoramento.

*   **Rede:** Uma rede bridge chamada `network-monitoring` é criada para permitir a comunicação entre os containers.
*   **Volumes:** Volumes nomeados `grafana-data` e `prometheus-data` são criados para persistir os dados do Grafana e do Prometheus, respectivamente.
*   **Serviços:**
    *   **Grafana:** Utiliza a imagem `grafana/grafana:11.4.0-ubuntu`.  Mapeia as pastas `./grafana/datasources` e `./grafana/dashboard`para provisionar os datasources, dashboards e o volume `grafana-data` para persistir os dados.
    *   **Prometheus:** Utiliza a imagem `prom/prometheus:v3.1.0`.  Mapeia o arquivo `./prometheus/prometheus.yml` para configurar o Prometheus e o volume `prometheus-data` para persistir os dados.
    *   **Node Exporter:** Utiliza a imagem `quay.io/prometheus/node-exporter:v1.8.2`.  Expõe as métricas do sistema operacional para o Prometheus.

#### `grafana/dashboard/dashboard.yml`

Este arquivo configura o provisionamento de dashboards no Grafana.

*   **Providers:** Define um provider chamado "Prometheus" que busca dashboards em arquivos.
*   **Dashboards:** Especifica que os dashboards devem ser carregados da pasta `/var/lib/grafana/dashboards`.

#### `grafana/dashboard/dashboards/node-exporter-dashboard.json`
Esse arquivo contém o JSON com as configurações do dashboard [Node Exporter Full](https://grafana.com/grafana/dashboards/1860-node-exporter-full/)

#### `grafana/datasources/datasources.yml`

Este arquivo configura os datasources do Grafana.

*   **Datasources:** Define um datasource chamado "Prometheus" que se conecta ao Prometheus na URL `http://prometheus:9090`.

#### `prometheus/prometheus.yml`

Este arquivo configura o Prometheus.

*   **Global:** Define configurações globais, como o intervalo de coleta de métricas (`scrape_interval`).
*   **Scrape Configs:** Define os jobs de coleta de métricas.
    *   `job_name: 'prometheus'`: Coleta métricas do próprio Prometheus.
    *   `job_name: 'node'`: Coleta métricas do Node Exporter.

## NGINX
Configurações do servidor NGINX.
```
server ...: Este bloco define um servidor virtual Nginx.

listen 80; :  Esta diretiva instrui o Nginx a ouvir na porta 80, a porta padrão para HTTP.  Isso significa que as requisições HTTP para este servidor serão direcionadas para ele.

server_name $SERVER-IP;: Esta diretiva define o nome do servidor.  A variável $SERVER-IP será substituída pelo endereço IP público do servidor onde o Nginx está em execução.

location / ...: Este bloco define como o Nginx deve lidar com as requisições para o caminho /.  Neste caso, todas as requisições para a raiz do servidor serão tratadas pelas diretivas dentro deste bloco.

proxy_pass http://localhost:3000;: Esta diretiva é a chave para o proxy reverso.  Ela instrui o Nginx a encaminhar as requisições para o Grafana, que está ouvindo na porta 3000 do mesmo servidor.

proxy_http_version 1.1;: Define a versão do protocolo HTTP para 1.1, que é necessária para o correto funcionamento do WebSocket, utilizado pelo Grafana.

proxy_set_header Upgrade $http_upgrade;:  Esta diretiva repassa o cabeçalho Upgrade da requisição original para o Grafana.  Isso é importante para o estabelecimento de conexões WebSocket.

proxy_set_header Connection 'upgrade';: Esta diretiva repassa o cabeçalho Connection da requisição original para o Grafana, também necessário para o WebSocket.

proxy_set_header Host $host;:  Esta diretiva repassa o cabeçalho Host da requisição original para o Grafana.  Isso garante que o Grafana saiba qual o host original da requisição.

proxy_cache_bypass $http_upgrade;: Esta diretiva impede que o Nginx armazene em cache as requisições WebSocket.
```

# Terraform

## Módulo de EC2

## Instalação e Configuração do EC2

O módulo `terraform/modules/ec2/install.sh` é um script que automatiza a instalação de pacotes e configurações necessárias em uma instância EC2. Abaixo estão os passos que o script realiza:

### Passos do Script `install.sh`:
- **Atualização de pacotes existentes**: Atualiza os pacotes da máquina Ubuntu.
- **Instalação de pacotes essenciais**: Instala pacotes como `ca-certificates`, `curl`, `gnupg`, `tar`, `jq` e outros.
- **Configuração do Docker**:
  - Adiciona a chave GPG do Docker.
  - Configura o repositório do Docker.
  - Instala o Docker e o Docker Compose.
  - Adiciona o usuário atual ao grupo Docker e reinicia o grupo.
- **Instalação do Nginx**:
  - Instala o Nginx.
  - Remove a configuração padrão do Nginx.
  - Habilita e inicia o serviço Nginx.
- **Instalação e Configuração do GitHub Runner**:
  - Cria o diretório necessário para o runner no usuário `ubuntu`.
  - Baixa e descompacta o pacote mais recente do GitHub Actions Runner.
  - Configura o runner com variáveis personalizadas.
  - Registra o runner com o token do repositório.
  - Instala e inicia o serviço do runner.

## Configuração do EC2 com Terraform

O arquivo `main.tf` define os recursos necessários para criar uma instância EC2 com Terraform. Abaixo está uma explicação sobre os recursos criados:

### Recursos Terraform

#### Chave SSH

- **`tls_private_key`**: Gera uma chave privada do tipo especificado em `var.key_algorithm`, com o número de bits definido em `var.key_rds_bits`.
- **`aws_key_pair`**: Cria um par de chaves AWS a partir da chave privada gerada, permitindo o acesso SSH à instância EC2.

#### Armazenamento da Chave Privada no S3

- **`aws_s3_object`**: Armazena a chave privada gerada no bucket S3 especificado em `var.s3_object_bucket_name`. O arquivo é criptografado no lado do servidor.

#### Instância EC2

- **`aws_instance`**: Cria uma instância EC2 com as seguintes configurações:
  - AMI definida por `data.aws_ami.server.id`.
  - IP público associado ou não, conforme `var.is_associate_public_ip_address`.
  - Par de chaves SSH especificado.
  - Configurações de segurança, como grupos de segurança e sub-rede.
  - Dados do usuário a partir de um arquivo de `user_data_path`.
  - Volume EBS adicional com configuração de encriptação e tamanho definidos.

#### Configuração de AMI

- **`data.aws_ami`**: Define o filtro para buscar a imagem AMI mais recente, com base no filtro `name` e outros parâmetros como `architecture` e `virtualization-type`.

### Variáveis da Instância EC2

- **is_associate_public_ip_address** (Tipo: `bool`): Define se a instância EC2 deve ser associada a um IP público.
- **instance_type** (Tipo: `string`): Tipo da instância EC2 (ex: `t2.micro`, `t3.medium`).
- **security_group_id** (Tipo: `list(string)`): IDs dos grupos de segurança para a instância EC2.
- **public_subnet_id** (Tipo: `string`): ID da sub-rede pública onde a instância será criada.
- **user_data_path** (Tipo: `string`): Caminho para o script de dados do usuário, que será executado na inicialização da instância (ex: `install.sh`).
- **ec2_instance_name** (Tipo: `string`): Nome da instância EC2.
- **ebs_device_name** (Tipo: `string`): Nome do dispositivo EBS a ser anexado à instância EC2.
- **ebs_is_encrypted** (Tipo: `bool`): Define se o volume EBS deve ser criptografado.
- **ebs_volume_size** (Tipo: `number`): Tamanho do volume EBS em GiB.
- **is_most_recent** (Tipo: `bool`): Define se a AMI mais recente deve ser usada.
- **ami_name_filter** (Tipo: `string`): Filtro para o nome da AMI.
- **ami_virtualization_type_filter** (Tipo: `string`): Filtro para o tipo de virtualização da AMI (ex: `hvm`).
- **ami_architecture_filter** (Tipo: `string`): Filtro para a arquitetura da AMI (ex: `x86_64`).
- **ami_owner** (Tipo: `string`): ID do proprietário da AMI.

### Variáveis de Chave SSH

- **key_algorithm** (Tipo: `string`): Algoritmo da chave SSH (ex: `rsa`, `ecdsa`).
- **key_rds_bits** (Tipo: `number`): Tamanho da chave SSH em bits (ex: `2048`).
- **key_name** (Tipo: `string`): Nome da chave SSH.

### Variáveis de S3 para Chave Privada

- **s3_object_bucket_name** (Tipo: `string`): Nome do bucket S3 onde a chave privada SSH será armazenada.
- **s3_bucket_acl** (Tipo: `string`): ACL do bucket S3.
- **s3_bucket_server_side_encryption** (Tipo: `string`): Configuração de criptografia do lado do servidor para o bucket S3.

### Variáveis de Tags

- **tags** (Tipo: `map(string)`): Mapa de tags para a instância EC2 e outros recursos.

## Outputs

As saídas fornecem informações sobre a instância EC2 criada, como o ID da instância e seu endereço IP público.

- **instance_id**: ID da instância EC2 criada.
- **public_instance_ip**: IP público da instância EC2.

## Módulo de GitHub

### Recursos do Github

### Repositório GitHub

- **data "github_repository" "devops_challenge"**: Obtém informações sobre um repositório GitHub existente com base no nome completo do repositório fornecido.
- **resource "github_repository" "devops_challenge"**: Configura o repositórido do GitHub com as definiçōes fornecidas.
  - **name**: Nome do repositório.
  - **description**: Descrição do repositório.
  - **visibility**: Visibilidade do repositório (ex: público ou privado).
  - **delete_branch_on_merge**: Define se o branch será excluído automaticamente após o merge.

### Proteção de Branch

- **resource "github_branch_protection" "devops_challenge"**: Configura a proteção de branch para um repositório GitHub.
  - **repository_id**: ID do repositório a ser protegido.
  - **pattern**: Nome do branch a ser protegido.
  - **required_pull_request_reviews**: Requer revisão de pull requests antes do merge.
    - **required_approving_review_count**: Número de aprovações necessárias antes de permitir o merge.

### GitHub Actions Secrets

- **data "github_actions_public_key" "devops_challenge"**: Obtém a chave pública do repositório para permitir a configuração dos segredos no GitHub Actions.
- **resource "github_actions_secret" "devops_challenge_aws_access_key_id"**: Armazena o segredo da chave de acesso AWS no GitHub Actions.
- **resource "github_actions_secret" "devops_challenge_aws_secret_access_key"**: Armazena o segredo da chave secreta de acesso AWS no GitHub Actions.
- **resource "github_actions_secret" "devops_challenge_runner_github_token"**: Armazena o token do GitHub Actions runner.
- **resource "github_actions_secret" "devops_challenge_git_auth_token"**: Armazena o token de autenticação Git no GitHub Actions.
- **resource "github_actions_secret" "devops_challenge_thandi_cidr_ipv4"**: Armazena o CIDR IPv4 para o serviço Thandi no GitHub Actions.

### Variáveis do Repositório GitHub

- **git_full_repository_name** (Tipo: `string`): Nome completo do repositório GitHub (ex: `user/repo`).
- **git_repository_name** (Tipo: `string`): Nome do repositório GitHub.
- **git_repository_description** (Tipo: `string`): Descrição do repositório.
- **git_repository_visibility** (Tipo: `string`): Visibilidade do repositório (público ou privado).
- **is_delete_branch_on_merge** (Tipo: `bool`): Define se o branch será excluído após o merge.
- **git_branch_protection_name** (Tipo: `string`): Nome do branch a ser protegido.
- **git_branch_protection_require_approval** (Tipo: `string`): Número de aprovações necessárias para permitir o merge.

### Variáveis de Segredos do GitHub Actions

- **aws_access_key_id** (Tipo: `string`): Chave de acesso AWS para ser armazenada no GitHub Actions.
- **aws_secret_access_key** (Tipo: `string`): Chave secreta de acesso AWS para ser armazenada no GitHub Actions.
- **runner_github_token** (Tipo: `string`): Token do GitHub Actions runner.
- **git_auth_token** (Tipo: `string`): Token de autenticação Git para ser armazenado no GitHub Actions.
- **thandi_cidr_ipv4** (Tipo: `string`): CIDR IPv4 utilizado pelo serviço Thandi no GitHub Actions.

## Módulo de S3

### Recursos S3

*   **Bucket para state do Terraform:**
    *   Cria um bucket S3 usando `aws_s3_bucket` com o nome especificado pela variável `s3_server_terraform_bucket_name`.
    *   Habilita o versionamento do bucket usando `aws_s3_bucket_versioning`, conforme definido pela variável `s3_server_terraform_bucket_versioning`.

*   **Bucket para chaves SSH:**
    *   Cria um bucket S3 usando `aws_s3_bucket` com o nome especificado pela variável `s3_server_ssh_keys_bucket_name`.

*   **Tags:** Ambos os buckets recebem tags definidas pela variável `tags`.

#### Variaveis

Este arquivo define as variáveis de entrada do módulo S3. Inclui variáveis para:

*   Nomes dos buckets (`s3_server_terraform_bucket_name` e `s3_server_ssh_keys_bucket_name`).
*   Status do versionamento do bucket para state do Terraform (`s3_server_terraform_bucket_versioning`).
*   Tags (`tags`).

#### Outputs

Este arquivo define as saídas do módulo S3.

*   **`s3_bucket_server_ssh_keys`:** Exporta o ID do bucket para chaves SSH.

## Módulo de VPC

### Recursos da VPC

*   **VPC:**
    *   Cria uma VPC usando `aws_vpc` com o CIDR block especificado pela variável `vpc_cidr_block`.
    *   Adiciona tags definidas pela variável `tags` e combinadas com o nome da VPC (`vpc_name`).

*   **Internet Gateway:**
    *   Cria um Internet Gateway usando `aws_internet_gateway`.
    *   Associa o Internet Gateway à VPC.
    *   Adiciona tags definidas pela variável `tags` e combinadas com o nome do Internet Gateway (`igw_name`).

*   **Security Group:**
    *   Cria um security group usando `aws_security_group` com o nome (`sg_name`) e descrição (`sg_description`) especificados nas variáveis.
    *   Associa o security group à VPC.
    *   Adiciona tags definidas pela variável `tags` e combinadas com o nome do security group (`sg_name`).

*   **Regras de Entrada (Ingress):**
    *   Define regras de entrada para permitir tráfego SSH, Prometheus, Node Exporter e HTTP, todos provenientes do CIDR block `main_thandi_cidr_ipv4`. As portas e protocolos são definidos por variáveis.

*   **Regra de Saída (Egress):**
    *   Define uma regra de saída que permite todo o tráfego para qualquer destino (`0.0.0.0/0`).  **Atenção:** Esta regra é muito permissiva e deve ser restringida para um ambiente de produção.

*   **Subnet Pública:**
    *   Cria uma subnet pública usando `aws_subnet`.
    *   Associa a subnet à VPC.
    *   Define `map_public_ip_on_launch` para `true` para que as instâncias lançadas nesta subnet recebam um IP público.
    *   Adiciona tags definidas pela variável `tags` e combinadas com o nome da subnet (`public_subnet_name`).

*   **Tabela de Rotas:**
    *   Cria uma tabela de rotas pública usando `aws_route_table`.
    *   Associa a tabela de rotas à VPC.
    *   Adiciona tags definidas pela variável `tags` e combinadas com o nome da tabela de rotas (`public_rt_name`).

*   **Rota:**
    *   Cria uma rota na tabela de rotas pública para o Internet Gateway, permitindo acesso à internet.

*   **Associação da Tabela de Rotas:**
    *   Associa a tabela de rotas pública à subnet pública.

#### Variáveis

Este arquivo define as variáveis de entrada do módulo VPC.  Inclui variáveis para:

*   CIDR block da VPC (`vpc_cidr_block`).
*   Nomes da VPC, Internet Gateway, security group, subnet e tabela de rotas.
*   Descrição do security group.
*   CIDR block para regras de entrada (`main_thandi_cidr_ipv4`).
*   Portas e protocolos para as regras de entrada (SSH, Prometheus, Node Exporter, HTTP).
*   CIDR block e protocolo para a regra de saída (`main_allow_all_traffic_cidr_ipv4` e `main_allow_all_traffic_ip_protocol`).
*   Zona de disponibilidade da subnet pública (`public_availability_zone`).
*   CIDR block da subnet pública (`public_subnet_cidr_block`).
*   Variável para habilitar a atribuição de IP público na subnet pública (`is_map_public_ip_on_launch`).
*   Tags (`tags`).

#### Outputs

Este arquivo define as saídas do módulo VPC.

*   **`public_subnet_id`:** Exporta o ID da subnet pública.
*   **`security_group_id`:** Exporta o ID do security group.

## Arquivos Root do Terraform

### `main.tf`

Este arquivo define os módulos que compõem a infraestrutura. Ele chama os módulos S3, Git, VPC e EC2, passando as variáveis necessárias para cada um deles.

*   **Módulo S3:**
    *   Chama o módulo S3, responsável pela criação dos buckets para state do Terraform e chaves SSH.
    *   Passa as variáveis `s3_server_terraform_bucket_name`, `s3_server_terraform_bucket_versioning`, `s3_server_ssh_keys_bucket_name` e `tags`.

*   **Módulo Git:**
    *   Chama o módulo Git, responsável pela configuração do repositório no GitHub.
    *   Passa as variáveis `git_full_repository_name`, `git_repository_name`, `git_repository_description`, `git_repository_visibility`, `is_delete_branch_on_merge`, `git_branch_protection_name`, `git_branch_protection_require_approval`, `aws_access_key_id`, `aws_secret_access_key`, `runner_github_token`, `git_auth_token` e `thandi_cidr_ipv4`.

*   **Módulo VPC:**
    *   Chama o módulo VPC, responsável pela criação da infraestrutura de rede.
    *   Passa as variáveis `vpc_cidr_block`, `vpc_name`, `igw_name`, `sg_name`, `sg_description`, `thandi_cidr_ipv4`, `main_ssh_source_port`, `main_ssh_ip_protocol`, `main_ssh_destintion_port`, `main_thandi_ssh_rule_name`, `main_thandi_prometheus_rule_name`, `main_thandi_node_exporter_rule_name`, `main_http_cidr_ipv4`, `main_http_source_port`, `main_http_ip_protocol`, `main_http_destintion_port`, `main_http_rule_name`, `main_prometheus_cidr_ipv4`, `main_prometheus_source_port`, `main_prometheus_ip_protocol`, `main_prometheus_destintion_port`, `main_prometheus_rule_name`, `main_node_exporter_cidr_ipv4`, `main_node_exporter_source_port`, `main_node_exporter_ip_protocol`, `main_node_exporter_destintion_port`, `main_node_exporter_rule_name`, `main_allow_all_traffic_cidr_ipv4`, `main_allow_all_traffic_ip_protocol`, `main_allow_all_traffic_rule_name`, `public_availability_zone`, `public_subnet_cidr_block`, `is_map_public_ip_on_launch`, `public_subnet_name`, `public_rt_name`, `public_igw_destination_cidr_block` e `tags`.
    *   **Obs**: Note que algumas variáveis são definidas diretamente, enquanto outras, como os CIDR blocks para Prometheus e Node Exporter, são obtidas a partir do módulo EC2.

*   **Módulo EC2:**
    *   Chama o módulo EC2, responsável pela criação da instância EC2.
    *   Passa as variáveis `is_associate_public_ip_address`, `instance_type`, `security_group_id`, `public_subnet_id`, `user_data_path`, `ec2_instance_name`, `ebs_device_name`, `ebs_is_encrypted`, `ebs_volume_size`, `is_most_recent`, `ami_name_filter`, `ami_virtualization_type_filter`, `ami_architecture_filter`, `ami_owner`, `tags`, `key_algorithm`, `key_rds_bits`, `key_name`, `s3_object_bucket_name`, `s3_bucket_acl` e `s3_bucket_server_side_encryption`.  **Obs**: Os IDs do security group e da subnet são obtidos a partir do módulo VPC.

### Variáveis

Este arquivo define as variáveis que são utilizadas nos módulos e na configuração principal do Terraform. As variáveis permitem parametrizar a infraestrutura, tornando-a mais flexível e reutilizável.

As variáveis abrangem diversas áreas, incluindo:

*   **Providers:** Região da AWS.
*   **Módulo Git:** Configurações do repositório Git, credenciais de acesso e configurações de proteção de branch.
*   **Módulo S3:** Nomes dos buckets S3 e configurações de versionamento.
*   **Módulo VPC:** Configurações da VPC, Internet Gateway, security group, regras de entrada e saída, subnet pública e tabela de rotas.
*   **Módulo EC2:** Configurações da instância EC2, volume EBS, AMI, par de chaves SSH e acesso ao S3.
*   **Tags:** Tags comuns para todos os recursos.

### Locals (`locals.tf`)

Este arquivo define variáveis locais, que são valores que podem ser calculados ou definidos internamente no seu código Terraform.

#### `locals`

O bloco `locals` define um mapa chamado `common_tags`. Este mapa contém tags que serão aplicadas a todos os recursos da infraestrutura. As tags são pares chave-valor que ajudam a organizar e identificar os recursos. Neste caso, as tags definidas são:

*   `Project: "Server"`
*   `Managedby: "Terraform"`
*   `Owner: "Thandi"`

**Observação:** A utilização de um bloco `locals` para definir tags comuns foi uma prática utilizada para evitar repetição de código, promover a consistência e facilitar a manutenção do código.

### Outputs

Este arquivo define as saídas (outputs) do Terraform. Neste caso, o arquivo `output.tf` define uma saída chamada `public_instance_ip`, que contém o endereço IP público da instância EC2 criada.

## Arquivos de Configuração Terraform

### Backend (`backend.hcl`)

Este arquivo configura o backend do Terraform, que é responsável por armazenar o state do Terraform. O state contém informações sobre a infraestrutura gerenciada pelo Terraform e é crucial para o planejamento e aplicação de mudanças.

Neste caso, o backend utilizado é o S3. O arquivo `backend.hcl` especifica:

*   `bucket`: O nome do bucket S3 onde o state será armazenado.
*   `key`: A chave (nome do arquivo) dentro do bucket S3 onde o state será salvo.
*   `region`: A região da AWS onde o bucket S3 está localizado.

### Provider (`provider.tf`)

Este arquivo define os providers do Terraform, que são plugins que permitem ao Terraform interagir com as APIs de diferentes serviços, como AWS e GitHub.

#### `terraform`

O bloco `terraform` define configurações para o próprio Terraform.

*   `required_providers`: Este bloco especifica os providers necessários para o projeto e suas versões.
    *   `aws`: O provider da AWS permite ao Terraform gerenciar recursos na AWS. A versão especificada é 5.84.0.
    *   `github`: O provider do GitHub permite ao Terraform interagir com a API do GitHub. A versão especificada é 6.5.0.

*   `backend "s3" {}`: Este bloco configura o backend do Terraform para usar o S3. O backend é responsável por armazenar o state do Terraform, que contém informações sobre a infraestrutura gerenciada. A configuração específica do bucket S3, chave e região estão definidas no arquivo `backend.hcl`.

*   `required_version = "~> 1.1.9"`: Esta linha especifica a versão mínima do Terraform necessária para executar o projeto.

#### `provider "aws" {}`

Este bloco configura o provider da AWS.

*   `region = var.aws_region`: Define a região da AWS onde os recursos serão criados.

#### `provider "github" {}`

Este bloco configura o provider do GitHub. Nenhuma configuração específica é definida aqui, pois a autenticação está sendo realizada nas pipelines.

## Linguagens, Frameworks e Tecnologias Utilizadas

* **Terraform**: Ferramenta para IaC, utilizada para provisionar e gerenciar a infraestrutura na AWS.
* **Docker**: Plataforma de contêinerização, utilizada para empacotar e executar as aplicações de forma consistente.
* **Docker Compose**: Ferramenta para definir e gerenciar aplicações multi-container Docker
* **Nginx**: Servidor web e proxy reverso, utilizado para servir o Grafana e outras aplicações.
* **Grafana**: Ferramenta de visualização e monitoramento, utilizada para criar dashboards e alertas.
* **Prometheus**: Sistema de monitoramento e alerta, utilizado para coletar métricas do servidor e das aplicações.
* **Node Exporter**: Agente que coleta métricas do sistema operacional e expõe para o Prometheus.
* **GitHub Actions**: Plataforma de CI/CD do GitHub, utilizada para automatizar o deploy e outras tarefas.
* **AWS**: Provedor de nuvem onde a infraestrutura é provisionada.
* **Ubuntu LTS**: Sistema operacional utilizado no servidor.
* **Bash**: Linguagem de script utilizada nos arquivos de configuração e instalação.

## Observação
A variável (`main_thandi_cidr_ipv4`) foi configurada por motivos de segurança permitindo que somente a máquina com esse IP consiga acessar as páginas das ferramentas e realizar o SSH. Somente a porta do HTTP(`80`) foi liberada para acesso totalmente público.

## Como Instalar
### Pré-requisitos
* Conta na AWS com permissões para criar os recursos utilizados no projeto.
* Conta no GitHub com permissões para configurar o projeto.
* Terraform instalado na máquina (se for executar localmente).
* Docker e Docker Compose instalados (se for executar localmente).
* AWS CLI configurado com suas credenciais (se for executar localmente).

### Instalação
A instalação das ferramentas é realizada no arquivo

### Instalação local
1. Clone o repositório: git clone https://github.com/thandioque/devops-challenge-teamsoft.git
2. Acesse o diretório do projeto: cd devops-challenge-teamsoft

### Configuração
1.  **Variáveis de ambiente**: As variaveis estão configuradas na secret do projeto, mas caso o objetivo seja executar localmente, defina as variáveis de ambiente necessárias. Você pode criar um arquivo .tfvars na raiz do projeto e preencher com os valores. Exemplo:
```
aws_access_key_id = "SUA_CHAVE_DE_ACESSO_AWS"
aws_secret_access_key = "SEU_SECRET_DE_ACESSO_AWS"
# ... outras variáveis
```

### Backend: O arquivo terraform/backend.hcl já está configurado para armazenar o state no S3.

## Uso
1. A pipeline de CI/CD é acionada quando ocorrem modificações nos diretórios ./src e ./nginx, sendo que o job de CI é executado quando o PR é criado para a branch main e ambos os jobs quando o merge é realizado para a branch main (evento de push ).
2. A pipeline de plan do Terraform é acionada sempre que o PR é criado para a branch main com alteraçōes nos arquivos do Terraform.
3. A pipeline de apply do Terraform é acionada sempre que o merge é realizado para a branch main (evento de push) com alteraçōes nos arquivos do Terraform.
4. A pipeline de destroy do Terraform deve ser acionada manualmente para ser iniciada. Ela está configurada para remover somente os modulos de EC2 e VPC para evitar a remoção do bucket que armazena o state do Terraform no S3 e configurações dessee projeto no Git.

## Informações adicionais
1. Runner do GitHub Actions: O script de instalação configura um runner auto-hospedado na instância EC2. Você pode verificar o status do runner no seu repositório no GitHub.
2. Acesso ao Grafana: O Grafana estará disponível na porta 80 do servidor EC2. O Nginx fará o proxy reverso para a porta 3000.
3. Monitoramento: O Prometheus e o Node Exporter já estarão configurados para coletar métricas do servidor, assim como o dashboard responsável por mostrá-las no Grafana. Os acessos ao Prometheus na porta 9090 e Node Exporter na 9100 do servidor EC2 estão liberados somente para o Ip do Thandi por motivos de segurança.

## Observações Finais

Durante o desenvolvimento deste projeto, algumas melhorias e implementações adicionais não foram possíveis devido a limitações de tempo e restrições do plano free-tier da AWS. Abaixo estão algumas das melhorias que poderiam ser consideradas em futuras versões:

1. **Ferramentas de VPN**:
   A implementação de uma VPN para acesso seguro aos recursos da infraestrutura.

2. **Serviços de Backup**:
   A configuração de serviços de backup como AWS Backup ou AWS Snapshots para garantir a recuperação de dados em caso de falhas.

3. **Ambiente Kubernetes (k8s)**:
   A utilização de Kubernetes para orquestração de contêineres, juntamente com Helm para gerenciamento de pacotes, proporcionaria maior escalabilidade e flexibilidade.

4. **Zabbix para Monitoramento**:
   A implementação do Zabbix como ferramenta de monitoramento foi considerada, mas devido ao alto consumo de CPU em instâncias t3.micro, não foi viável no momento.

6. **Segurança Avançada**:
   A implementação de políticas de segurança mais rigorosas.

7. **Monitoramento de Logs**:
   A configuração de outras ferramentas de monitoramento, assim como outros datasources como por exemplo Cloudwatch Logs.

8. **Escalabilidade Automática**:
   A implementação de Auto Scaling Groups e Load Balancers para garantir que a infraestrutura possa lidar com picos de tráfego de forma eficiente.

9. **Configuração de HTTPS e Certificados SSL**:
   Devido às limitações mencionadas, também não foi possível configurar HTTPS, utilizar certificado SSL ou configurar um domínio customizado para garantir uma comunicação segura entre cliente e servidor.
