# Olá!
Este é o repositório mínimo para instalação do ambiente de código do grupo HadrEx em seu computador local.

A lista de pacotes corresponde ao necessário para análise + simulações básicas em Pythia. Caso pretenda realizar simulações da cadeia hidrodinâmica, utilize o formato completo presente em [Hadrex_Ph](https://github.com/Hadrex-UNICAMP/HadrEx_ph)

# Como utilizar este repositório
Como este repositório é público, você pode baixá-lo simplesmente clicando no botão verde "Code" e baixar o arquivo ZIP que contém toda a estrutura deste repositório em seu computador.

Feito isso, extraia o arquivo.

Dentro da pasta gerada, há duas opções de instalação, de acordo com seu sistema operacional:

- [**install_Linux.sh**](install_Linux.sh): Feita para sistemas operacionais baseados em Linux (utilizamos Ubuntu, por padrão). Rode com `./install_Linux.sh`, onde ./ é a sua pasta atual.

Caso não tenha permissão para rodar o código, execute `chmod +x ./install_Linux.sh` antes de `./install_Linux.sh`.

- [**install_MacOS.sh**](install_MacOS.sh): Feita para MacOS. Instalação similar à do Ubuntu.

Se quiser aprender um pouco mais, a lista de bibliotecas instaladas pode ser vista em [**packages_Linux.yaml**](packages_Linux.yaml) ou [**packages_MacOS.yaml**](packages_MacOS.yaml).

## Consigo instalar no Windows?
Sim! Mas é um pouco mais complicado...

Vamos utilizar uma ferramenta conveniente do Windows 11, chamada WSL2, que roda Ubuntu em uma máquina virtual ultra-leve (quase imperceptível para as "análises de notebook"!). É possível que tenha instabilidades, mas esperamos que seja perfeitamente funcional!

**CUIDADO!** Seu computador irá reiniciar automaticamente (caso contrário, reinicie-o após a instalação da linha abaixo).
Para instalar em Windows 11, abra o PowerShell **como administrador** e digite:
```
wsl --install -d Ubuntu
```
Caso queira ler a documentação, acesse [Instalando o wsl](https://learn.microsoft.com/en-us/windows/wsl/install).

### Como abrir o Ubuntu no Windows (WSL)

Após a instalação do WSL e o reinício do computador:

1. Abra o menu Iniciar do Windows
2. Procure por **Ubuntu**
3. Clique no aplicativo **Ubuntu**

Na primeira vez que abrir, o sistema irá:
- Pedir que você crie um **nome de usuário**
- Pedir que você crie uma **senha**
  - **ATENÇÃO:** a senha não aparece na tela enquanto você digita (isso é normal em sistemas Linux)

Após isso, você verá um terminal com algo parecido com:
`username@DESKTOP-XXXX:~$`
Isso significa que você está dentro do ambiente Linux (Ubuntu).
(O terminal do Ubuntu é uma janela preta com texto branco (ou verde), semelhante a um terminal Linux padrão)

### Finalizando a instalação no Windows
A partir de agora, **todos os comandos abaixo devem ser executados dentro do terminal do Ubuntu (WSL)**, e não no PowerShell ou no Prompt de Comando do Windows.
```
sudo apt update
sudo apt install -y git
```
para atualizar suas bibliotecas de Ubuntu e instalar a ferramenta git.

Depois, baixe os arquivos deste repositório e navegue para a pasta de instalação:
```
git clone https://github.com/cmuncinelli/HadrEx_env.git
cd HadrEx_env
```

Por fim, rode o instalador de Linux: `./install_Linux.sh`, seguindo os mesmos passos da instalação de Linux. Todos os arquivos serão instalados dentro desta "máquina virtual".
(se não conhece este conceito, na prática ele é como uma nova pasta de arquivos dentro de seu computador, acessível pelo aplicativo "Ubuntu". Nela está contida toda uma versão do Ubuntu que roda como um segundo computador dentro de seu Windows!)

Pronto! Agora basta rodar todas as suas funções dentro deste ambiente Ubuntu!

Dúvidas? Contate-nos!
