# Onde Tudo Começou — Jogo Narrativo em Pixel Art 2D

Jogo narrativo em pixel art 2D (desenvolvido em **Godot 4, GDScript**), inspirado em acontecimentos reais da história de Miguel e Maria Fernanda.

**Ambientação:** Interior e regiões serranas do Rio de Janeiro. Cenários que retratam fielmente bairros residenciais brasileiros e a Região Serrana (Petrópolis e Itaipava): casas coloridas com portões de ferro, muros baixos, calçadas, fiação aérea, postes de luz, comércio local, pets deitados na sala, ônibus urbanos e o amplo Parque de Exposições de Itaipava com sua ciclovia asfaltada entre árvores e montanhas.

---

## Como abrir e jogar
1. Abra o **Godot 4 (versão 4.2 ou mais recente)**.
2. Clique em **Importar** e selecione o arquivo `project.godot` desta pasta.
3. **Para jogar a narrativa completa desde o início:** aperte **F5** (inicia no Prólogo e avança automaticamente pelos capítulos).
4. **Para jogar diretamente o Capítulo 1:** abra `chapters/chapter_1/scene_01_depois_do_olhar/scene_01.tscn` e aperte **F6**.
5. **Para jogar diretamente o Capítulo 2:** abra `chapters/chapter_2/scene_01_encontro/scene_01.tscn` e aperte **F6**.
6. **Para jogar diretamente o Capítulo 3:** abra `chapters/chapter_3/scene_01_marcando_encontro/scene_01.tscn` e aperte **F6**.
7. **Para jogar diretamente o Capítulo 4:** abra `chapters/chapter_4/scene_01_um_novo_passeio/scene_01.tscn` e aperte **F6**.
8. **Para jogar diretamente o Capítulo Final:** abra `chapters/chapter_final/scene_01_o_pedido_de_namoro/scene_01.tscn` e aperte **F6**.
9. **Para testar cenas específicas:**
   - **Prólogo:**
     - `chapters/prologue/scene_01_um_dia_comum/scene_01.tscn` (Cena 01)
     - `chapters/prologue/scene_02_manha_miguel/scene_02.tscn` (Cena 02)
     - `chapters/prologue/scene_03_tarde_maria/scene_03.tscn` (Cena 03)
     - `chapters/prologue/scene_04_abacate/scene_04.tscn` (Cena 04)
     - `chapters/prologue/scene_05_primeiro_olhar/scene_05.tscn` (Cena 05)
   - **Capítulo 1 — A Primeira Mensagem:**
     - `chapters/chapter_1/scene_01_depois_do_olhar/scene_01.tscn` (Cena 01)
     - `chapters/chapter_1/scene_02_instagram_solicitacao/scene_02.tscn` (Cena 02)
     - `chapters/chapter_1/scene_03_festa_amigo/scene_03.tscn` (Cena 03)
     - `chapters/chapter_1/scene_04_passagem_tempo/scene_04.tscn` (Cena 04)
     - `chapters/chapter_1/scene_05_primeira_mensagem/scene_05.tscn` (Cena 05)
     - `chapters/chapter_1/scene_06_uno/scene_06.tscn` (Cena 06)
     - `chapters/chapter_1/scene_07_conversas_continuam/scene_07.tscn` (Cena 07)
     - `chapters/chapter_1/scene_08_convite_acai/scene_08.tscn` (Cena 08)
   - **Capítulo 2 — O Primeiro Encontro:**
     - `chapters/chapter_2/scene_01_encontro/scene_01.tscn` (Cena 01)
     - `chapters/chapter_2/scene_02_caminhada_acai/scene_02.tscn` (Cena 02)
     - `chapters/chapter_2/scene_03_acaiteria/scene_03.tscn` (Cena 03)
     - `chapters/chapter_2/scene_04_conversa_acai/scene_04.tscn` (Cena 04)
     - `chapters/chapter_2/scene_05_decisao_quadra/scene_05.tscn` (Cena 05)
     - `chapters/chapter_2/scene_06_caminhada_quadra/scene_06.tscn` (Cena 06)
     - `chapters/chapter_2/scene_07_aula_basquete/scene_07.tscn` (Cena 07)
     - `chapters/chapter_2/scene_08_caminhada_avo/scene_08.tscn` (Cena 08)
     - `chapters/chapter_2/scene_09_despedida/scene_09.tscn` (Cena 09)
     - `chapters/chapter_2/scene_10_felizes_em_casa/scene_10.tscn` (Cena 10)
     - `chapters/chapter_2/scene_11_mensagem_agradecimento/scene_11.tscn` (Cena 11)
   - **Capítulo 3 — Mais Perto de Você:**
     - `chapters/chapter_3/scene_01_marcando_encontro/scene_01.tscn` (Cena 01)
     - `chapters/chapter_3/scene_02_o_novo_encontro/scene_02.tscn` (Cena 02)
     - `chapters/chapter_3/scene_03_banco_de_pedra/scene_03.tscn` (Cena 03)
     - `chapters/chapter_3/scene_04_tirando_fotos/scene_04.tscn` (Cena 04)
     - `chapters/chapter_3/scene_05_o_beijo/scene_05.tscn` (Cena 05)
     - `chapters/chapter_3/scene_06_caminhada_avo/scene_06.tscn` (Cena 06)
     - `chapters/chapter_3/scene_07_despedida_avo/scene_07.tscn` (Cena 07)
     - `chapters/chapter_3/scene_08_encerramento/scene_08.tscn` (Cena 08)
   - **Capítulo 4 — Pedalando Juntos:**
     - `chapters/chapter_4/scene_01_um_novo_passeio/scene_01.tscn` (Cena 01)
     - `chapters/chapter_4/scene_02_o_reencontro_e_beijo/scene_02.tscn` (Cena 02)
     - `chapters/chapter_4/scene_03_viagem_onibus/scene_03.tscn` (Cena 03)
     - `chapters/chapter_4/scene_04_chegada_parque/scene_04.tscn` (Cena 04)
     - `chapters/chapter_4/scene_05_passeio_bicicleta/scene_05.tscn` (Cena 05)
     - `chapters/chapter_4/scene_06_corrida_bicicleta/scene_06.tscn` (Cena 06)
     - `chapters/chapter_4/scene_07_voltando_para_casa/scene_07.tscn` (Cena 07)
     - `chapters/chapter_4/scene_08_passagem_tempo/scene_08.tscn` (Cena 08)
     - `chapters/chapter_4/scene_09_familia_miguel/scene_09.tscn` (Cena 09)
     - `chapters/chapter_4/scene_10_familia_maria/scene_10.tscn` (Cena 10)
      - `chapters/chapter_4/scene_11_encerramento/scene_11.tscn` (Cena 11)
    - **Capítulo Final — A Melhor Escolha da Minha Vida:**
      - `chapters/chapter_final/scene_01_o_pedido_de_namoro/scene_01.tscn` (Cena 01 — O Pedido de Namoro)
      - `chapters/chapter_final/scene_02_explosao_de_felicidade/scene_02.tscn` (Cena 02 — Explosão de Felicidade)
      - `chapters/chapter_final/scene_03_o_primeiro_dia/scene_03.tscn` (Cena 03 — O Primeiro Dia 03/11/2024)
      - `chapters/chapter_final/scene_04_nossa_historia_e_dois_anos/scene_04.tscn` (Cenas 04 a 07 — Retrospectiva & 2 Anos)
      - `chapters/chapter_final/scene_08_encerramento_definitivo/scene_08.tscn` (Cena 08 — Encerramento Definitivo)

---

## Controles
| Ação | Teclas | Onde se aplica |
|---|---|---|
| Andar | WASD ou Setas | Exploração e minigames |
| Correr | Shift | Ruas e minigame de doces |
| Interagir / Avançar texto | E ou Enter | Caixas de diálogo, celular |
| Confirmar / Ação | Espaço ou Enter | Menus, botões do celular, UNO |
| Navegar cartas no UNO | Setas Esquerda/Direita ou Mouse | Minigame de UNO |
| Jogar carta / Comprar | Espaço / Enter / Clique | Minigame de UNO |
| Ajustar mira no basquete | A / D ou Setas | Minigame da quadra (Prólogo) |
| Alinhar enquadramento na foto | A / D ou Setas | Minigame de foto (Capítulo 3) |
| Disparar foto / Tirar selfie | Espaço / Enter / Clique | Minigame de foto (Capítulo 3) |
| Pedalar bicicleta / Acelerar / Frear | W / S ou Setas Cima / Baixo | Passeio e Corrida de Bicicleta (Capítulo 4) |
| Virar / Curva na bicicleta | A / D ou Setas Esquerda / Direita | Passeio e Corrida de Bicicleta (Capítulo 4) |
| Impulso de pedalada rápida | Espaço | Passeio e Corrida de Bicicleta (Capítulo 4) |

---

## Prólogo — Onde Tudo Começou (27/09/2024)
- **Cena 01 — Um Dia Comum:** Tela dividida vertical mostrando o despertar de Miguel e Maria Fernanda em suas respectivas rotinas matinais.
- **Cena 02 — A Manhã de Miguel:** Miguel se arruma, desce a rua e vai até a quadra para o minigame de basquete.
- **Cena 03 — A Tarde de Maria Fernanda:** Saída da escola com as amigas Ana Clara e Gabriele e o minigame de São Cosme e Damião pelo bairro.
- **Cena 04 — O Abacate:** Miguel descendo a rua, chutando um abacate no asfalto até ser chamado pela prima.
- **Cena 05 — O Primeiro Olhar:** Encontro visual entre Miguel e Maria Fernanda na calçada. Som ambiente diminui, música acústica nostálgica e troca silenciosa de olhares.

---

## Capítulo 1 — A Primeira Mensagem

### 💬 Cena 01 — Depois do Primeiro Olhar
- **Tipo:** Cutscene cinematográfica.
- **Sequência:** Continuando exatamente após o prólogo, Maria Fernanda caminha com as amigas e a prima descendo a calçada. Maria comenta que achou Miguel bonito: *"Ele é bonito, né?"*. A prima o identifica e a incentiva: *"Segue ele no Instagram!"*. Maria para e pega o celular.

### 📱 Cena 02 — A Solicitação do Instagram
- **Tipo:** Gameplay interativo com o celular.
- **Sequência:** O celular abre na tela com a interface do Instagram em pixel art. Maria visualiza o perfil de Miguel (`@miguel`). O jogador clica no botão "Seguir", que muda com feedback visual e sonoro para "Solicitado ✓".

### 🍖 Cena 03 — A Festa do Amigo
- **Tipo:** Cutscene + Interação.
- **Sequência:** Miguel está na confraternização residencial de um amigo (churrasco brasileiro com som ambiente, churrasqueira e mesa de amigos). Miguel confere o celular e encontra a notificação de solicitação de Maria Fernanda. O jogador aceita e a tela confirma com "Seguindo ✓".

### ⏳ Cena 04 — Alguns Dias Depois...
- **Tipo:** Cutscene de passagem do tempo + Ambientação.
- **Sequência:** Transição com indicação temporal suave: *"Alguns dias depois..."*. Apresentação da Casa de Miguel (sala acolhedora brasileira com sofá, rack de TV e caminha de pets). Introdução dos dois animais de Miguel: o **Bulldog preto** descansando e o **Gato cinza** relaxando pela sala com animação suave de respiração.

### 💬 Cena 05 — A Primeira Mensagem
- **Tipo:** Cutscene + Gameplay Interativo.
- **Sequência:** Miguel está na sala com seus pets quando toca a notificação do WhatsApp. Maria Fernanda envia a primeira mensagem: *"Oi, Miguel! Tudo bem? Minha prima me passou seu número."*. O jogador escolhe as respostas interativas de Miguel enquanto a conversa flui com naturalidade, relembrando o abacate e o dia de São Cosme e Damião.

### 🃏 Cena 06 — A Partida de UNO
- **Tipo:** Minigame Interativo Completo.
- **Sequência:** Maria Fernanda convida Miguel para uma partida de UNO pelo celular. O jogador joga uma partida completa oficial (baralho com 108 cartas, cartas de ação +2, +4, inverter, pular, escolha de cor e grito de UNO) contra a IA inteligente e desafiadora de Maria Fernanda.

### 🌅 Cena 07 — As Conversas Continuam
- **Tipo:** Montagem narrativa cinematográfica.
- **Sequência:** Montagem poética demonstrando a passagem dos dias e o fortalecimento da amizade através de variações sutis de iluminação (manhã, tarde, noite) na casa de Miguel, notificações constantes e movimentação serena dos animais.

### 🍧 Cena 08 — O Convite do Açaí
- **Tipo:** Cutscene climática de encerramento do capítulo.
- **Sequência:** Miguel toma coragem e envia a mensagem pelo WhatsApp: *"Quer ir tomar um açaí comigo?"*. Após momentos de expectativa com o status "digitando...", Maria responde com alegria: *"Quero sim!"*. Toca a trilha sonora alegre e nostálgica (`music_joyful.wav`). Miguel comemora e a tela escurece com o anúncio:
  **"CONTINUA... FIM DO CAPÍTULO 1 — A PRIMEIRA MENSAGEM"**.

---

## Capítulo 2 — O Primeiro Encontro

### 👫 Cena 01 — O Encontro
- **Tipo:** Cutscene cinematográfica.
- **Sequência:** Chega o dia combinado. Miguel espera na calçada com sua blusa azul casual (`miguel_encontro.png`). Maria Fernanda se aproxima radiante com óculos dourados, blusa verde e calça branca (`maria_encontro.png`). Trocam cumprimentos carinhosos e tímidos, e começam a caminhar lado a lado pelo bairro.

### 🚶 Cena 02 — Caminhando Juntos até o Açaí
- **Tipo:** Gameplay interativo + Diálogos naturais.
- **Sequência:** O jogador assume o controle de Miguel pela calçada residencial enquanto Maria caminha suavemente ao lado dele. Trocas de falas leves e acolhedoras sobre como o dia está bonito e a expectativa da semana. Ao chegarem na açaiteria, a cena transiciona para o interior.

### 🍧 Cena 03 — A Açaiteria & Minigame de Montagem
- **Tipo:** Cutscene + Minigame Interativo (`AcaiMinigame`).
- **Sequência:** Chegada à açaiteria acolhedora com atendente no balcão e mesas aconchegantes. O jogador abre o cardápio em lousa: escolhe tamanho (300ml, 500ml, 700ml), base (Tradicional, com Banana, com Morango) e complementos variados (leite em pó, granola, morango, leite condensado, paçoca). O pedido é entregue e o casal vai para a mesa.

### 💬 Cena 04 — Conversa no Açaí
- **Tipo:** Cutscene interativa com escolhas de diálogo.
- **Sequência:** Sentados à mesa saboreando o açaí, com as duas tigelas roxas e a música romântica acústica (`music_first_date.wav`). O jogador escolhe respostas para Miguel sobre os temas reais:
  - Onde estudam: **Miguel no SESI**, **Maria Fernanda no Liceu**.
  - Bichinhos de estimação: Miguel conta sobre seu **buldogue preto** e seu **gato cinza**.
  - Sentimento sincero de que conversar pessoalmente é ainda melhor do que pelo celular.

### 🏀 Cena 05 — Decisão de ir até a Quadra
- **Tipo:** Cutscene curta.
- **Sequência:** Terminando o açaí, o clima está gostoso demais para se despedirem. Miguel sugere esticar o passeio até a quadra coberta do bairro. Maria aceita com entusiasmo: *"Bora! Mas só se você me ensinar a arremessar direitinho!"*.

### 🌅 Cena 06 — Caminhando até a Quadra
- **Tipo:** Cutscene cinematográfica.
- **Sequência:** O casal caminha pelo bairro sob a luz dourada do fim de tarde. A timidez inicial já deu lugar a uma cumplicidade natural e confortável.

### ⛹️ Cena 07 — Aula de Basquete & Pular o Portão da Quadra
- **Tipo:** Cutscene interativa + Minigame de arremesso + Momento aventureiro.
- **Sequência:** Ao chegarem na quadra coberta, descobrem que ela está trancada com corrente no portão de ferro. Em um momento fofo e descontraído da história real, Miguel dá pezinho para Maria Fernanda e os dois pulam o portão para dentro da quadra vazia! Na quadra iluminada, Miguel ensina a postura correta das mãos e eles acertam a cesta juntos num arremesso interativo. Na hora de ir embora, pulam o portão de volta com Maria saltando nos braços de Miguel.

### 🌆 Cena 08 — Caminhando até a Casa da Avó
- **Tipo:** Cutscene cinematográfica.
- **Sequência:** A noite começa a cair e os postes da rua se acendem. Maria comenta que a avó a espera e Miguel faz questão de acompanhá-la até a esquina da casa da avó.

### 🫂 Cena 09 — A Despedida, o Primeiro Selinho & Efeito de Corações
- **Tipo:** Cutscene cinematográfica intimista com efeitos visuais e sonoros.
- **Sequência:** Em frente ao portão da casa da avó (`gate_iron.png`). Momento de silêncio tímido e doce. O casal se aproxima e compartilha um abraço apertado e acolhedor, seguido por um delicado primeiro selinho. Durante o selinho, a câmera aproxima em close, toca um chime romântico delicado (`kiss_chime.wav`) e surgem múltiplos corações em pixel art (`pixel_heart.png`) flutuando suavemente para o céu noturno. Maria entra pelo portão olhando para trás e Miguel sorri feliz.

### 🏠 Cena 10 — Felizes em Casa
- **Tipo:** Cutscene paralela em dois ambientes.
- **Sequência:**
  - Maria em seu quarto, sorrindo e refletindo sobre como o dia foi especial.
  - Miguel chega em casa, é calorosamente recebido por seu buldogue preto e seu gato cinza na sala, e deita no sofá com a sensação de uma tarde perfeita.

### 💬 Cena 11 — A Mensagem de Agradecimento
- **Tipo:** Cutscene final no celular + Conclusão do capítulo.
- **Sequência:** Miguel está na sala com os pets quando o celular vibra com a notificação do WhatsApp. Ele abre e lê a mensagem real de Maria Fernanda:
  **"Obrigada pelo dia, eu gostei muito."**
  Miguel sorri e responde com carinho. A tela escurece lentamente e exibe:
  **"CONTINUA... FIM DO CAPÍTULO 2 — O PRIMEIRO ENCONTRO"** (Apertar Enter/Espaço avança diretamente para o Capítulo 3).

---

## Capítulo 3 — Mais Perto de Você

### 📱 Cena 01 — Marcando o Novo Encontro
- **Tipo:** Cutscene + Interface do Celular.
- **Sequência:** Transição suave com *"Algum tempo depois..."*. Miguel abre o WhatsApp e envia mensagem para Maria Fernanda combinando de se encontrarem à tarde na praça sombreada perto do banco de pedra. Maria aceita alegremente.

### 👫 Cena 02 — O Novo Encontro
- **Tipo:** Cutscene cinematográfica acolhedora.
- **Sequência:** Encontro na calçada do bairro. Diferente do primeiro encontro, a timidez agora dá espaço a uma conexão leve, relaxada e muito confortável. Eles caminham lado a lado em direção ao banco de pedra sob a copa das árvores.

### 🪨 Cena 03 — O Banco de Pedra
- **Tipo:** Cutscene narrativa com escolhas interativas de diálogo.
- **Sequência:** Sentados lado a lado no banco de pedra artesanal (`banco_pedra.png`), sentindo a brisa suave. O jogador escolhe como Miguel responde às perguntas de Maria com diferentes tons naturais (Tímido, Engraçado, Carinhoso). Conversam sobre o SESI, o Liceu, os pets (o buldogue e o gato cinza) e o sentimento mútuo de proximidade crescente.

### 📸 Cena 04 — Tirando Fotos Juntos & Minigame Polaroid
- **Tipo:** Cutscene interativa + Minigame de foto (`PhotoMinigame`).
- **Sequência:** Maria Fernanda propõe registrar aquele dia especial. O celular se abre com retículo de foco e visor de câmera fotográfica. O jogador centraliza a foto e dispara com `Espaço`/`Enter`/`Clique`. Após o flash e som de obturador (`camera_shutter.wav`), a fotografia revela uma linda moldura Polaroid (`selfie_casal.png`) mostrando os dois sorrindo juntos e corações decorativos flutuando.

### 💋 Cena 05 — O Beijo
- **Tipo:** Cutscene cinematográfica com grande carga emocional e romântica.
- **Sequência:** Guardando o celular, surge um momento de silêncio íntimo e cumplicidade. A câmera aproxima com zoom cinematográfico. Miguel e Maria se olham com doçura e compartilham um beijo verdadeiro, demorado e inesquecível. Durante o beijo, a trilha suave (`music_closer_to_you.wav`) cresce, ecoa o chime romântico (`kiss_chime.wav`) e diversos corações em pixel art sobem em efeito suave pela tela.

### 🌆 Cena 06 — Caminhada até a Casa da Avó
- **Tipo:** Cutscene cinematográfica de fim de tarde.
- **Sequência:** O sol começa a se pôr em tons alaranjados e violetas. O casal caminha junto, mais unidos e íntimos do que nunca, aproveitando cada segundo restante do encontro enquanto seguem para a casa da avó dela.

### 🫂 Cena 07 — A Despedida no Portão
- **Tipo:** Cutscene de despedida calorosa.
- **Sequência:** Em frente ao portão de ferro (`gate_iron.png`), trocam palavras carinhosas de agradecimento. Eles se abraçam longamente e selam o encontro com mais um beijo doce de despedida acompanhado de corações pixel art. Maria entra pelo portão e se despede com um aceno sorridente.

### 🌟 Cena 08 — Encerramento do Capítulo
- **Tipo:** Cutscene final + Tela poética de encerramento.
- **Sequência:** Miguel caminha de volta para casa sob a luz dos postes, com passos tranquilos e a certeza do amor que cresce a cada dia. O jogo salva o progresso concluído do Capítulo 3 (`chapter_3_completed`) e exibe a tela de encerramento poética:
  *"E a cada novo encontro, um sentimento que não para de crescer..."*
  **FIM DO CAPÍTULO 3 — MAIS PERTO DE VOCÊ (CONTINUA...)**
  (Pressione Enter/Espaço para avançar diretamente para o Capítulo 4).

---

## Capítulo 4 — Pedalando Juntos

### 📱 Cena 01 — Um Novo Passeio
- **Tipo:** Cutscene com celular.
- **Sequência:** Miguel em casa na sua sala de estar. Recebe notificação no WhatsApp de Maria Fernanda. Os dois combinam de fazer um passeio diferente: pegar o ônibus urbano e ir até o Parque de Exposições em Itaipava para andar de bicicleta. A cena transiciona com *"Mais tarde, no ponto de ônibus..."*.

### 👫 Cena 02 — O Reencontro e o Beijo
- **Tipo:** Cutscene cinematográfica.
- **Sequência:** Miguel chega ao ponto de ônibus no bairro de Petrópolis. Maria Fernanda aparece descendo a calçada. Miguel se aproxima e os dois se cumprimentam com um beijo breve, natural e carinhoso em pixel art (sem efeitos exagerados ou corações artificiais, mantendo o tom realista). O ônibus urbano brasileiro (`BusActor`) chega ao ponto com chiado de freio a ar, as portas se abrem e os dois embarcam juntos.

### 🚌 Cena 03 — Viagem de Ônibus
- **Tipo:** Cutscene + Diálogo interativo.
- **Sequência:** Vista interna do ônibus urbano com bancos duplos de tecido azul, barras amarelas de apoio e janelas panorâmicas com a vista da serra e das montanhas de Petrópolis em movimento. Miguel e Maria sentam lado a lado. O jogador pode escolher falas interativas para Miguel durante o trajeto. Uma montagem curta mostra o trajeto até Itaipava, onde o ônibus desacelera e os dois desembarcam perto do parque.

### 🌳 Cena 04 — Chegada ao Parque de Exposições
- **Tipo:** Cutscene + Ambientação.
- **Sequência:** Inspirada diretamente na fotografia real do Parque de Exposições de Itaipava: pista ampla de asfalto com linha tracejada branca para ciclistas, gramados extensos, árvores frondosas que projetam sombras agradáveis, quiosque de madeira e as montanhas serranas ao fundo. Miguel e Maria caminham admirando o espaço, pegam suas bicicletas e se preparam para pedalar.

### 🚴 Cena 05 — Passeio de Bicicleta
- **Tipo:** Gameplay.
- **Sequência:** O jogador assume o controle de Miguel pedalando pela ciclovia do parque enquanto Maria Fernanda pedala suavemente ao seu lado através de IA. Controles intuitivos de aceleração, curvas, frenagem e impulso de pedalada rápida com a barra de espaço. Diálogos naturais surgem durante o trajeto até chegarem na reta principal.

### 🏁 Cena 06 — Minigame: Corrida de Bicicleta
- **Tipo:** Gameplay competitivo (Miguel vs. Maria Fernanda).
- **Sequência:** Maria desafia Miguel para uma corrida até a linha de chegada. Os dois se alinham na largada com bandeiras quadriculadas. Contagem regressiva sonora: *"3... 2... 1... JÁ!"*. HUD completo com cronômetro em tempo real, indicador de posição (1º / 2º), barra de progresso do circuito e teclas de atalho. A IA de Maria Fernanda compete de forma equilibrada e emocionante. Ao cruzarem a linha de chegada, o banner anuncia o vencedor (*"Miguel Venceu!"* ou *"Maria Fernanda Venceu!"*) e a história segue suavemente para uma desaceleração tranquila e risadas entre os dois.

### 🌆 Cena 07 — Voltando para Casa
- **Tipo:** Cutscene de fim de tarde.
- **Sequência:** O sol começa a se pôr em tons quentes de crepúsculo. Os dois guardam as bicicletas, caminham até o ponto e pegam o ônibus de volta. No bairro, desembarcam sob a luz serena do entardecer, trocam um abraço carinhoso de agradecimento pelo dia inesquecível e cada um segue para a sua casa.

### ⏳ Cena 08 — Passagem do Tempo
- **Tipo:** Montagem cinematográfica poética.
- **Sequência:** Transição com tela escura: *"Com o passar do tempo..."*. Inicia uma trilha instrumental acolhedora (`music_family.wav`) com violão e piano, mostrando que o relacionamento se aprofundou e que chegou a hora de dar um passo muito importante: conhecer a família um do outro.

### 🏠 Cena 09 — Maria Fernanda Conhece a Família de Miguel
- **Tipo:** Cutscene curta e acolhedora.
- **Sequência:** Sala de estar da casa de Miguel. Maria Fernanda é recebida por Miguel e apresentada aos seus familiares em um ambiente caloroso e natural. O buldogue preto e o gato cinza estão presentes relaxando pela sala com animações sutis de respiração. Conversa descontraída, risadas e carinho.

### ☕ Cena 10 — Miguel Conhece a Família de Maria Fernanda
- **Tipo:** Cutscene curta.
- **Sequência:** Sala de estar da família de Maria Fernanda. Miguel é recebido com simpatia e afeto pelos familiares dela. Entre um café e conversas leves, os laços familiares se estreitam com naturalidade e respeito mútuo.

### 🌟 Cena 11 — Encerramento do Capítulo
- **Tipo:** Cutscene final + Tela poética.
- **Sequência:** Miguel e Maria Fernanda juntos ao final de mais uma etapa marcante. A câmera se afasta suavemente, a música continua e a tela escurece lentamente exibindo:
  *"E assim, pedalada a pedalada, cada momento fortalecia o que estava destinado a ser eterno..."*
  **FIM DO CAPÍTULO 4 — PEDALANDO JUNTOS (CONTINUA...)**
  (Pressione Enter/Espaço para reiniciar ou navegar livremente).

---

## Novos Recursos e Sistemas do Capítulo 4
- `assets/tiles/asphalt_bike_lane.png` — Pista de asfalto com linha branca tracejada para ciclistas, inspirada diretamente na fotografia real de Itaipava.
- `assets/tiles/bus_urban.png` — Ônibus urbano brasileiro em pixel art (pintura azul e branca, letreiro "ITAIPAVA", portas e janelas).
- `assets/tiles/bus_stop.png` — Ponto de ônibus com placa de trânsito, abrigo metálico, vidro e banco de madeira.
- `assets/tiles/bus_interior.png` — Interior detalhado do ônibus com bancos duplos azuis, barras de apoio amarelas e janelas panorâmicas das montanhas.
- `assets/tiles/tree_parque.png` — Árvores frondosas do Parque de Exposições com copas verdes exuberantes e sombras suaves.
- `assets/tiles/kiosk_wood.png` — Quiosque/gazebo de madeira do parque presente na foto de referência.
- `assets/tiles/mountain_bg.png` — Cenário de fundo das montanhas e serras de Petrópolis.
- `assets/sprites/characters/miguel_bike.png` — Folha de sprites de Miguel pedalando de bicicleta (4 direções, ciclo de pedalada).
- `assets/sprites/characters/maria_bike.png` — Folha de sprites de Maria Fernanda pedalando (blusa verde, calça branca, óculos dourados `#EAB308`).
- `assets/sprites/characters/family_member_a.png`, `b.png`, `c.png` — Personagens familiares provisórios e configuráveis (64x96 px).
- `assets/sprites/ui/race_flag.png` — Bandeira quadriculada de largada e chegada da corrida.
- `assets/audio/bus_engine.wav` — Som contínuo de motor de ônibus urbano com chiado de freio a ar.
- `assets/audio/bike_bell.wav` — Som nítido de campainha de bicicleta ("trim-trim!").
- `assets/audio/race_beep.wav` & `race_go.wav` — Sinais sonoros de contagem regressiva 3-2-1 e largada da corrida.
- `assets/audio/music_park_ride.wav` — Trilha sonora acústica alegre, ensolarada e descontraída em Sol Maior para o parque.
- `assets/audio/music_bike_race.wav` — Trilha rítmica, enérgica e divertida para a disputa da corrida.
- `assets/audio/music_family.wav` — Trilha acolhedora e terna em Fá Maior com piano e violão para os encontros com as famílias.
- `core/characters/bike_sprites.gd` — Gerador de animações para ciclistas em pixel art.
- `core/transport/bus_actor.gd` — Ator de ônibus com desaceleração no ponto, abertura/fechamento de portas e partida.
- `minigames/bike/bike_controller.gd` — Controlador de bicicleta com aceleração, curvas, frenagem, impulso de pedalada e IA para navegação em percursos.
- `minigames/bike/bike_race_minigame.gd` — Sistema completo de corrida com HUD, cronômetro, barra de progresso, checkpoints e detecção de chegada.
- `core/characters/family_npc.gd` — Classe configurável para representação dos familiares.
- `data/dialogues/chapter_4.json` — 33 diálogos organizados por cena e marcados com `"revisar": true` para revisão fiel dos fatos reais.
- `chapters/chapter_4/chapter.json` — Manifesto oficial do capítulo encadeando todas as 11 cenas.

---

## Capítulo Final — A Melhor Escolha da Minha Vida (03/11/2024 — 03/11/2026)

O capítulo mais marcante e emocionante de toda a narrativa, celebrando o pedido de namoro oficial em **03/11/2024** e comemorando os dois anos de relacionamento em **03/11/2026**.

### 💍 Cena 01 — O Pedido de Namoro
- **Tipo:** Cutscene cinematográfica.
- **Local:** No meio de uma tranquila rua residencial brasileira em Petrópolis.
- **Sequência:** Miguel e Maria Fernanda caminham juntos pela rua em um clima acolhedor de fim de tarde. Miguel para, a música ambiente diminui e a câmera aproxima o enquadramento. Miguel se ajoelha diante dela com sprite dedicado (miguel_kneel.png). Ele faz o pedido oficial de namoro: *"Você quer namorar comigo?"*. Maria Fernanda sorri e responde com emoção: *"Sim!"*. Miguel se levanta, os dois se aproximam e trocam um beijo carinhoso enquanto a trilha sonora cresce.

### 💖 Cena 02 — Explosão de Felicidade
- **Tipo:** Cutscene cinematográfica com efeitos especiais.
- **Sequência:** No exato momento do beijo, a tela se enche de partículas comemorativas: corações em pixel art (pixel_heart.png), estrelas brilhantes (pixel_star.png) e confetes coloridos festivos (confetti.png), acompanhados de efeito sonoro cintilante (sparkle.wav). A câmera realiza um zoom-out cinematográfico panorâmico e o cenário escurece suavemente.

### 📅 Cena 03 — O Primeiro Dia
- **Tipo:** Cutscene cinematográfica em fundo preto.
- **Sequência:** A tela fica completamente preta e exibe a data inaugural do relacionamento:
  # 03/11/2024
  *"O primeiro dia da nossa história juntos."*
  Transição suave com fade-in e fade-out poéticos.

### 📸 Cenas 04 a 07 — Retrospectiva com 10 Fotografias Reais em Altíssima Definição (HD)
- **Tipo:** Retrospectiva com fotos originais e momentos marcantes da história do casal.
- **Diretriz de Fidelidade e Qualidade Máxima:**
  - As 10 fotografias reais são exibidas **100% intocadas**, sem compressão, sem distorção e sem cortes.
  - Renderizadas através do modo de alta definição nativa (`CONTENT_SCALE_MODE_CANVAS_ITEMS`) com filtragem linear e mipmapping contínuo (`TEXTURE_FILTER_LINEAR_WITH_MIPMAPS`), garantindo que fotos em 1024x768 / 1024x1024 sejam reproduzidas com nitidez impecável e cores vivas em qualquer monitor (Full HD / 4K).
- **Sequência Oficial com as 10 Fotografias:**
  1. *"Meu amor, muito obrigado pelo tempo que passamos juntos."* ➔ `foto_01.jpg` (Abraço carinhoso do casal) e `foto_07.jpg` (Selfie fofa com biquinho e óculos dourados).
  2. *"Cada momento foi incrível, e eu te amo cada vez mais."* ➔ `foto_02.jpg` (Abraço no mar durante o pôr do sol), `foto_03.png` (Selfie no espelho com camisas de futebol) e `foto_09.jpg` (Selfie ao ar livre descontraída).
  3. Comemoração de 1 ano: *"Já se passou um ano..."* ➔ **# 03/11/2025** ➔ `foto_04.png` (Natureza ensolarada), `foto_06.jpg` (Maria Fernanda com o cãozinho) e `foto_08.png` (O buldogue preto olhando para cima com brinquedo).
  4. Comemoração de 2 anos: *"E agora..."* ➔ Explosão festiva de estrelas ➔ **# FINALMENTE 2 ANOS!!!!** ➔ **# 03/11/2026** ➔ `foto_05.jpg` (Piquenique na grama) e `foto_10.png` (Maria descansando no ombro de Miguel).
  5. Declaração de amor:
     - *"Dois anos desde a melhor escolha da minha vida, que foi te pedir em namoro."* ➔ `foto_01.jpg`
     - *"Muito obrigado, meu amor, por ser essa mulher incrível e por sempre estar ao meu lado."* ➔ `foto_10.png`
     - *"Eu te amo mais e mais, para sempre."*
     - *"Esses são 2 de muitos anos juntos."* ➔ `foto_05.jpg`

### ♾️ Cena 08 — Encerramento Definitivo
- **Tipo:** Cutscene final e encerramento absoluto de todo o jogo.
- **Sequência:**
  1. A última fotografia desaparece suavemente na escuridão.
  2. A música instrumental continua calma e serena.
  3. No centro da tela, surge delicadamente a inscrição:
     # Miguel & Maria Fernanda ∞
  4. Pequenos corações e estrelas em pixel art aparecem discretamente ao redor dos nomes com animação suave de brilho.
  5. Os nomes e ornamentos desaparecem lentamente na tela preta.
  6. Surge a última e definitiva mensagem de amor:
     # Eu te amo para sempre, meu amor. ❤️
  7. A música termina com fade-out gradual e a tela escurece por completo no mais doce silêncio.
- **Regras estritas respeitadas:** Sem datas na Cena 08, sem a palavra "FIM", letras brancas sobre fundo preto, símbolo do infinito (∞) e coração (❤️) suportados nativamente com tipografia elegante.

---

## Novos Recursos e Sistemas do Capítulo Final
- ssets/sprites/characters/miguel_kneel.png — Sprite exclusivo de Miguel ajoelhado em um joelho fazendo o pedido de namoro.
- ssets/sprites/ui/pixel_star.png — Estrela brilhante em pixel art para momentos comemorativos e encerramento.
- ssets/sprites/ui/confetti.png — Folha de confetes coloridos (dourado, rosa, ciano e verde) para a explosão de alegria.
- ssets/audio/sparkle.wav — Efeito sonoro harmônico cintilante para momentos mágicos.
- ssets/audio/music_love_theme.wav — Trilha sonora orquestrada com piano e violão acústico em Dó Maior (Cmaj7, G/B, Am7, Fmaj7).
- ssets/photos/foto_01.jpg a oto_05.jpg — Fotografias reais originais de Miguel e Maria Fernanda preservadas 100% autênticas.
- core/fx/celebration_particles.gd — Emissor configurável de partículas de celebração (corações, confetes e estrelas).
- core/retrospective/photo_retrospective.gd — Sistema cinematográfico de exibição de fotos com preservação de proporção (STRETCH_KEEP_ASPECT_CENTERED) e cartões de texto.
- chapters/chapter_final/chapter.json — Manifesto oficial do Capítulo Final.
- 	ools/test_chapter_final.gd & 	ools/test_chapter_final.tscn — Suíte de testes automatizados com validação 100% verde (código 0).
