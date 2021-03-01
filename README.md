# iBeer
```
SDKNetwork Unit Tests Coverage: **92.9%**
SDKCommon Unit Tests Coverage: **81.6%**
iBeer Unit Tests Coverage: **76.9%**
iBeer UI Tests Coverage: **63.2%**
```
<img width="384" alt="Captura de Tela 2021-03-01 às 02 29 40" src="https://user-images.githubusercontent.com/41647536/109455797-23a87f80-7a36-11eb-8e82-4c91459fa1fd.png"><img width="378" alt="Captura de Tela 2021-03-01 às 02 29 56" src="https://user-images.githubusercontent.com/41647536/109455810-286d3380-7a36-11eb-9824-12cf1271bb75.png">

Projeto modularizado, utilizando Swift Package Manager para frameworks externos e Cocoapods para módulos internos. 

### Instalação:

clone o projeto, e depois rode esse comando na raiz do projeto

```
> pod install
```

isso será suficiente para rodar o iBeer, porém para testarmos e alterarmos o SDKNetwork precisamos de mais uma etapa:

```
> cd SDKNetwork/SDKNetwork
> pod install
```

isso irá construir as dependencias do SDKNetwork e assim o código poderá ser alterado. O `SDKNetwork` tem dependência com o `SDKCommon` então no momento está em um workspace separado. O seu .podspec está configurado e ele utiliza o CocoaPods também para sua dependência. O Workspace está na pasta mostrada acima.


## Comentários sobre o projeto

Utilizado como versão minima do sistema operacional o iOS13

Continuei utlizando o SceneDelegate porém removi as referencias do root storyboard no `info.plist` para utilizar o Coordinator em vez disso. 

A arquitetura utilizada foi o MVVM, pois é uma arquitetura clean, e VIPER seria muito complexo para um app tão simples. MVC e MVP mesmo tendo suas vantagens, acabei por escolher o MVVM mesmo. 

Na primeira tela, temos um fluxo dinâmico, quando o usuário está próximo do fim da lista, o app irá carregar mais dados, deixando assim o fluxo imperceptível para um usuário com internet estável. 

Na primeira request utilizer o `UserDefaults` para salvar os dados da primeira request ( assumindo que ela sempre vem idêntica). Porém para a lista completa após carregar mais páginas, utilizei o `CoreData` pois o `UserDefaults` é limitado a quantidade de dados em que pode armazenar, enquanto o `CoreData` é mais versátil. Os dois em uma aplicação podem trabalhar bem juntos, mas nesse caso foi apenas para uma amostragem do código. 

Criei o arquivo Configs para gerenciar toggles. Criei também um repositório de toggle no firebase, porém não tive tempo de implementá-lo, então está apenas as variáveis estáticas. 

Para a primeira tela, utilizei o `UICollectionViewController` em vez de utilizar normalmente a `UIViewController` para pegar umas ferramentas automáticas que o iOS nos entrega. Nesse caso específico foi o Texto na navigationBar com a fonte maior, a sua transição para outras telas fica animada e dinâmica. Isso também possibilitou que a lista apareça sem a barra de pesquisa quando o app está abrindo pela primeira vez, e ao fazer o scroll para cima, a barra de pesquisa é revelada. Outra transição interessante é a animação to título da view enquanto ela chama a próxima.

Para gerenciar a memória e o download das imagens na lista, utilizei o `KingFisher`, uma ferramenta que faz o cache das imagens e gerencia muito bem o download nas células. 

Utilizei o `Lottie` para dar um complemento na segunda tela, pois as informações não foram suficientes para cobrir a tela toda. Porém no iPhone SE é perceptível que não sobra muito espaço, porém graças ao auto-layout podemos programar uma forma de lidar com isso sem problemas. No caso a animação reduz de tamanho se não houver espaço suficiente, mas ainda mantendo seu aspect ratio. 

O observable de erros está implementado, porém ainda não construí uma view para mostrar ao usuário. O Observable é uma derivação bem mais simples do que era o RXSwift, uma forma de ouvir mudanças em uma variável e trabalhar de acordo. 

O `SDKCommon` é um framework muito pequeno para ser necessário neste momento do app, mas para sua escalabilidade, é interessante fazer as classes que são utilizadas pelo projeto e pelos módulos sejam separadas em seu módulo próprio para que reduza repetição de código e ainda melhora o desenvolvimento em grupo. 

O `SDKNetwork` tem muito a melhor ainda, seu tratamento de erros é limitado. Mas também muito importante é um fluxo para que o código do app seja apenas o necessário para configurar essa request. Por isso, o fluxo consegue receber objetos genéricos para fazer seu parse e consegue trabalhar com mock para os testes. O tratamento de erros é o próximo passo. 

O `Coordinator` é uma ferramenta excelente, porém neste app não houve a necessidade de mostrar o gerenciamento de memória e fluxo que pode ser feito com ele, quem sabe outro projeto possa demonstrar melhor.

Os testes unitários estão testando as ViewModels, Coordinator e a classe de Requests. 

O teste de UI está mostrando todas as funcionalidades do app, que são: 
- Listar em uma collection as cervejas
- Carregar dinamicamente as próximas quando chegar próximo ao fim
- Buscar cervejas pelo nome
- Ver os detalhes da cerveja clicada em outra tela

A prática de utilizar Pods + Swift Package Manager é utilizada em alguns casos, porém neste projeto foi apenas para demonstração. E para isso, mostrei o ponto forte dos dois. O pod é excelente em gerenciar Frameworks privados, podendo até incluí-los no workspace sem afetar desempenho. Inclusive o pods é utilizado aqui para gerenciar o `SDKNetwork` com suas dependencias do `SDKCommon`. O Swift Package Manager é forte em capturar Frameworks disponíveis como *open source*, assim o fluxo de adicionar esse tipo de código fica muito rápido e nenhum comando é necessário. 


### TODO:

- Adicionar um activity indicator enquanto a pesquisa está carregando e quando o app abre pela primeira vez.

- Tratar o erro com algum *feedback* para o usuário.

- Criar mais telas para mostrar algumas outras funcionalidades não mostradas no app atual

- Deixar o search mais dinamico, utilizando tags para ver se a pesquisa é por Tipo, ID, Nome ou IBU por exemplo. 

