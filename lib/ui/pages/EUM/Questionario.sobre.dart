/*import 'dart:collection';

import 'package:autocomplete_textfield/autocomplete_textfield.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:unicefapp/_api/tokenStorageService.dart';
import 'package:unicefapp/db/local.servie.dart';
import 'package:unicefapp/di/service_locator.dart';
import 'package:unicefapp/models/dto/SurveyQuestionResponse.dart';
import 'package:unicefapp/models/dto/agent.dart';
import 'package:unicefapp/models/dto/appsurveyextraction.dart';
import 'package:unicefapp/models/dto/survey.dart';
import 'package:unicefapp/models/dto/surveyExtraction.dart';
import 'package:unicefapp/ui/pages/home.page.dart';
import 'package:unicefapp/widgets/Autres/Zone.Saisie.dart';
import 'package:unicefapp/widgets/default.colors.dart';
import 'package:unicefapp/widgets/loading.indicator.dart';

class QuestionarioSobrePage extends StatefulWidget {
  const QuestionarioSobrePage({super.key, required this.dtoSurveyExtration});

  final DTOSurveyExtration dtoSurveyExtration;

  @override
  State<QuestionarioSobrePage> createState() => _QuestionarioSobrePageState();
}

class _QuestionarioSobrePageState extends State<QuestionarioSobrePage> {
  final _formKey = GlobalKey<FormState>();
  final storage = locator<TokenStorageService>();
  final dbHandler = locator<LocalService>();
  int _currentStep = 0;
  StepperType stepperType = StepperType.vertical;

  String selectedRegiao = ''; // Région par défaut
  String selectedAreas = ''; // Ville par défaut
  String selectedNameInvestigador = "";
  String selectedOption = '';
  String userid = '';

  late Future<AppSurveyExtraction> tableData;
  List<TextEditingController> textEditingControllers = [];
  final Map<String, TextEditingController> textEditingControllers2 = HashMap();

  Map<String, List<String>> regionCities = {
    'BAFATA': ['Bafata', 'Bambadinca', 'Contuboel', 'Cosse', 'Xitole'],
    'BIJAGOS': ['Bubaque', 'Caravela', 'Bolama', 'Uno'],
    'BIOMBO': ['Quinhamel', 'Safim', 'Prabis'],
    'CACHEU': ['S.Domingos', 'Cantchungo', 'Bula', 'Bigene', 'Cacheu', 'Caio'],
    'GABU': ['Gabu', 'Pitche', 'Sonaco', 'Pirada', 'Beli'],
    'OIO-FARIM': ['Mansoa', 'Bissora', 'Nhacra', 'Mansaba', 'Farim'],
    'QUINARA': ['Buba', 'Empada', 'Fulacunda', 'Tite'],
    'SAB': ['Antula', 'B. Militar', 'Bandim', 'Cuntum', 'Plaque 2'],
    'TOMBALI': ['Cacine', 'Bedanda', 'Catio', 'Komo', 'Quebo'],
  };

  List<String> listOfPessoasEntrevistadas = [
    "Director",
    "RAS",
    "Chefe do centro",
    "PF PAV",
    "Outros",
  ];

  List<String> listOfNameInvestigador = [
    "Miladenimar Vaz",
    "Venicio de Carvalho",
    "Yaouba Djaligué",
    "Victor Bessa",
    "N'dei Soares",
    "Carlota M.Ca",
    "Gibril Sarr",
    "Quecuto Nhaga",
    "Deborah Herbert",
  ];

  List<String> listOfResponses = ["Concludo", "Não executado", "Não aplicável"];

  List<TextEditingController> stepper1Controllers =
      List.generate(8, (index) => TextEditingController());
  List<TextEditingController> stepper2Controllers =
      List.generate(51, (index) => TextEditingController());
  List<TextEditingController> stepper3Controllers =
      List.generate(8, (index) => TextEditingController());
  List<TextEditingController> stepper4Controllers =
      List.generate(43, (index) => TextEditingController());

  List<String> questionsStep1 = [];
  List<String> questionsStep2 = [];
  List<String> questionsStep3 = [];
  List<String> questionsStep4 = [];

  // Liste des questions pour chaque étape
  List<List<String>> questions = [
    [
      "Nome e apelido do Investigador",
      "Numero de TEL",
      "Região",
      "Área da Sanitaria",
      "CENTRO DE SAUDE",
      "Pessoas entrevistadas",
      "Numero TEL",
      "Nomes",
    ],
    [
      "Recenseamento/cartografia dos OBCs, Agentes de Saúde Comunitários, Curandeiros tradicionais, líderes tradicionais e religiosos e análise das suas necessidades em reforço das capacidades para a promoção do PEV de rotina/ das modalidades de trabalho em rede / enquadramento / supervisão / formação dos seus recursos em comunicação pelas ONGs.",
      " Pesquisa qualitativa sobre as restrições/resistências à vacinação (causas da fraca cobertura da vacinação, abandonos), bem como os fatores motivacionais para levantar estes obstáculos e as oportunidades existentes. ",
      "Estudo de audiometria para classificar os media em relação à sua taxa de audiência (influência sobre as mães, famílias e comunidades). ",
      "Estudo para informar um seminário de reflexão sobre o sistema de motivação dos Agentes de Saúde e Agentes de Saúde Comunitários e sobre como estender aos outros atores em matéria de vacinação (líderes comunitários, ONGs, Organizações com Base Comunitária, Curandeiros tradicionais).",
      "Estudo de avaliação do suporte da operadora telefónica MTN na difusão dos dados de cobertura da vacinação e apoio na comunicação para a vacinação (nomeadamente através da análise do volume de chamadas e tipos de questões colocadas através da linha de telefone amarela).",
      "Estudo qualitativo para identificar os dados de base para/e medir a evolução nos objetivos de comunicação (ref. Infra. Indicadores dos objetivos da estratégia de comunicação). Este estudo pode ser conduzido nas regiões de demonstração unicamente na medida em que permitirá validar a estratégia de comunicação para a sua disseminação.",
      "Integração de indicadores sobre os conhecimentos e atitudes (para além das práticas) no inquérito periódico MICS com cobertura nacional. ",
      "Documentação da implementação da estratégia de comunicação nas regiões de demonstração e, nesta base, identificar indicadores de processos para facilitar a disseminação. ",
      "Seminário de desenvolvimento de (i) mensagens informativas, persuasivas e motivacionais sobre o PEV, a integrar no pacote mínimo de mensagens já existente sobre as práticas familiares; (ii) material educativo.",
      "Teste preliminar das mensagens e ferramentas",
      "Produção/distribuição de material de suporte.",
      "Publicação de manuais de formação em comunicação interpessoal para os agentes de saúde comunitários e animadores de ONGs.",
      "Seminário de desenvolvimento/publicação de um manual de formação em comunicação interpessoal dirigido aos vacinadores.",
      "Seminário de desenvolvimento/publicação de suportes de orientação em conteúdos de mensagens PEV dirigido às autoridades tradicionais e religiosas, aos OBCs, aos Curandeiros tradicionais, aos jornalistas. ",
      "Seminário de desenvolvimento/publicação de suportes de orientação em conteúdos de mensagens PEV dirigido às autoridades tradicionais e religiosas, aos OBCs, aos Curandeiros tradicionais, aos jornalistas. ",
      "Seminário de desenvolvimento/publicação de ferramentas pedagógicas para os inspetores de escola no quadro da implementação da estratégia adotada. ",
      "Nomeação de pontos focais para a comunicação  PEV dentro do programa PEV, no Ministério da Comunicação, no âmbito de outros ministérios Educação, Juventude, Mulheres e Administração Territorial e ONGs. ",
      "Constituição de um grupo técnico de trabalho em comunicação para o PEV constituído por pontos focais dos Ministérios e ONGs para planificar e fazer o acompanhamento trimestral da implementação do plano estratégico de comunicação para o PEV. ",
      "Expansão do Comité de Mobilização Social ao conjunto dos parceiros implicados na promoção do PEV (Ministérios, ONGs, sector privado, media, representantes das comunicações tradicionais). ",
      " Reuniões trimestrais do Grupo técnico comunicação PEV para o planeamento e seguimento da implementação do plano estratégico de comunicação para o PEV de rotina.",
      "Grupo técnico – reunião anual de validação do plano anual",
      "Reunio para o PEVnicaçplementaçoo tde comunicaçe planos regionais / de setores com as autoridades administrativas, responsões semestrais de seguimento da implementação do plano nas diversas instituições pelo grupo técnico e pelo Comité Nacional de Mobilização Social.",
      "Missões semestrais de seguimento das atividades a nível regional pelos membros do Comité Nacional de Mobilização Social.",
      "Seminários regionais anuais para o desenvolvimento de planos regionais / de setores com as autoridades administrativas, responsáveis pelas áreas da saúde e parceiros de implementação (ONGs, parceiros técnicos dos ministérios tradicionais (membros do Comité regional de Mobilização Social) ",
      "Missões de seguimento da implementação das atividades ao nível das áreas da saúde pelos membros do Comité Regional de Mobilização Social",
      "Seminário nacional para a revisão das ferramentas de seguimento e supervisão do PEV ",
      "Seminário nacional para o desenvolvimento (i) de ferramentas integradas de supervisão e seguimento das atividades dos agentes de saúde comunitária (ii) ferramentas de procura dos perdidos de vista pelos agentes de saúde comunitários; (iii) ferramentas de elaboração de relatórios das atividades PEV (comunicação/procura ativa dos perdidos de vista) ao enfermeiro chefe da zona pelos agentes de saúde comunitários",
      "Missões de supervisão dos Agentes de Saúde Comunitários por (i) ONGs; (ii) Responsáveis pelas áreas da saúde",
      "Seminários regionais de formação dos agentes de saúde comunitários e animadores das ONGs em (i) comunicação interpessoal, (ii) em conteúdos de mensagens PEV.",
      "Seminários regionais de formação dos agentes de saúde comunitários e animadores das ONGs  em (i) ferramentas de procura dos perdidos de vista (ii) ferramentas de transmissão das atividades do PEV ao enfermeiro chefe da zona	",
      "Seminários de formação dos formadores em comunicação interpessoal para os agentes de saúde",
      "Seminários de formação dos vacinadores em comunicação interpessoal 	",
      "Seminários de formação dos gestores do PEV (gestor do PEV, responsável PEV a nível regional, pontos focais comunicação) em comunicação para o desenvolvimento. ",
      "Seminários de orientação dos líderes das OBCs em conteúdos de mensagens para o PEV / práticas familiares essenciais ao nível das áreas da saúde.",
      "Seminários de orientação dos médicos tradicionais em conteúdos de mensagens para o PEV / práticas familiares essenciais ao nível das áreas da saúde. ",
      "Seminários de formação das autoridades administrativas em advocacia para apoio ao PEV",
      "Seminários de orientação de líderes religiosos em conteúdos de mensagens para o PEV / práticas familiares essenciais ao nível das áreas da saúde	",
      "Seminários de orientação dos líderes tradicionais em conteúdos de mensagens para o PEV /práticas familiares essenciais ao nível das áreas de saúde ",
      "Seminário nacional de formação dos jornalistas membros da Associação dos jornalistas para a promoção da Saúde e sobrevivência da criança (a criar) no PEV e em comunicação para a promoção da saúde da mãe, do recém-nascido e da criança. ",
      "Seminário nacional de formação das ONGs em utilização das ferramentas de supervisão dos Agentes de Saúde Comunitárias",
      "Seminário regional de formação dos agentes de saúde em utilização das ferramentas de supervisão dos Agentes de Saúde Comunitários.	",
      "Seminário de formação regional dos inspetores chefes e diretores de escola sobre o PEV sobre a estratégia de adoção (levar os alunos a recensear os recém-nascidos da sua localidade num caderno e com o apoio do professor assegurar o acompanhamento da vacinação destes recém-nascidos com a colaboração da estrutura de saúde da localidade para verificar no registo da vacinação se as consultas são efetivamente respeitadas).",
      "Seminários de formação regionais dos professores para a implementação da estratégia de adoção",
      "Visitas de advocacia dos chefes de agência das Nações Unidas (UNICEF, OMS, PNUD, UNFPA) no Ministério da Saúde e no gabinete do primeiro-ministro para a criação de um comité de acompanhamento e aceleração das OMDs no gabinete do primeiro-ministro.",
      "Reuniões de resultados trimestrais em conselho de ministros do desempenho do PEV",
      "Reuniões interministeriais sobre o PEV ",
      "Visitas de advocação pelo Comité nacional de Mobilização Social aos líderes políticos (deputados que farão pressão sobre o governo) para a mobilização dos recursos financeiros ao nível central e regional. ",
      "Visitas de advocacia pelo Comité de Mobilização Social às organizações da sociedade civil (ONGs) para a mobilização dos recursos financeiros ao nível central e regional.",
      "Visitas de advocacia pelo Comité de Mobilização Social aos chefes das sociedades privadas (empresas como a MTN, bancos, câmara de comércio) para a mobilização dos recursos financeiros ao nível central e regional.",
      "Desenvolvimento de documentos de projetos (mobilização de fundos) para o financiamento da estratégia de comunicação nas 3 regiões de demonstração e para o seu aumento gradual (cobertura de 4 regiões suplementares ao longo do 3º e 4º ano e cobertura de 4 regiões no último ano)",
      "Financiamento da estratégia de comunicação pelo RSS Gavi	",
    ],
    [
      "Visitas de advocacia aos detentores dos média para alianças programáticas duráveis a partir de uma abordagem mais clara no que respeita ao que é esperado dos média",
      "Visitas conjuntas dos média para cobertura das atividades de comunicação para o PEV no terreno",
      "Seminários anuais de revisão/planeamento do plano de ação com os média",
      "lançar uma iniciativa mulheres e comunicação (mulheres jornalistas fazendo a cobertura das atividades de comunicação para o PEV junto das mães)",
      "Encontros de advocacia com os Ministérios transversais para assinar convenções de parceiros a fim de integrar a componente comunicação PEV nos planos sectoriais.",
      "Encontros de advocacia com os chefes de serviços nacionais e regionais para integração da componente com. PEV nos Planos de Ação das estruturas membros dos comités de mobilização social ",
      "Seminários de advocacia junto dos governos da região e Administradores dos setores no sentido de operacionalizar o comité de mobilização social para a comunicação relacionada com o PEV de rotina.",
      "Seminário anual para revisão/planeamento dos Planos de ação dos comités regionais de mobilização social",
    ],
    [
      "Convenções de parceria com todas as ONGs especializadas em saúde para o enquadramento, formação e seguimento dos Agentes de Saúde Comunitários e outros atores comunitários.",
      "Seminários nacionais e regionais anuais de planeamento/seguimento dos planos de ação	",
      "Seminário de criação de uma associação de jornalistas para a promoção da saúde e a sobrevivência da mãe, do recém-nascido e da criança",
      "Encontros com os patronos de imprensa e editores para negociação dos acordos em vista de uma colaboração durável (pacotes de difusão, plano de reportagens, emissões, etc.)",
      "Seminário anual de orientação/planificação e seguimento dos planos de ação com os membros da associação de jornalistas em saúde para a promoção do PEV ",
      "Principal orgão de imprensa (televisão, rádio e jornal) o mais eficaz na promoção dos comportamentos favoráveis PEV e na cobertura dos acontecimentos relacionados (reconhecimento dos pares)",
      "Elaborar contratos com os órgãos de imprensa nacionais e regionais para um pacote de atividades de promoção do PEV (emissões, difusão de anúncios, emissões públicas, emissões interativas, etc.)",
      "Identificar/encontrar líderes de opinião reconhecidos e credíveis e mobilizá-los enquanto «Campeões» na promoção do PEV ",
      "Jornada de orientação dos representantes dos chefes religiosos e dos animadores de rádio de emissões religiosas",
      "Elaborar e assegurar a difusão de argumentos religiosos sobre o PEV a introduzir nos sermões e emissões religiosas rádio-televisão",
      "Visitas de advocacia com os líderes religiosos a nível regional ",
      "Encontros com os líderes religiosos a nível regional (partilha da problemática sobre o PEV e definição do que é pretendido dos curandeiros tradicionais)",
      "Seminários de criação de associações regionais dos curandeiros tradicionais (caso não existam) ",
      "Encontro com os membros das associações de curandeiros tradicionais (partilha da problemática sobre o PEV e definição do que é pretendido dos curandeiros tradicionais) 	",
      "Encontro nacional com o poder tradicional (régulos e chefes tradicionais) ",
      "Encontros com os inspetores da educação e diretores de escola sobre o PEV",
      "Enquandramento dos alunos pelos professores para a implementação da estratégia de adoção/patrocínio. ",
      "Recenseamento dos domicílios com as crianças não vacinadas e procura dos perdidos de vista pelos agentes de saúde comunitários.",
      " Fóruns regionais para mobilização da liderança dos grupos de mulheres, Grupos de Interesse Económico e as organizações de micro-crédito para motivar as mulheres a respeitar o calendário de vacinação e consagrar o tempo necessário para a vacinação das crianças. ",
      "Encontros com os líderes dos OBC e das associações para a integração das atividades de comunicação PEV na sua agenda",
      "Organizar campanhas mediáticas de comunicação sobre o PEV de rotina/emissões e revistas especializadas consagradas ao PEV de rotina. Debates e demonstrações teatrais",
      "As rádios comunitárias organizam emissões interativas sobre a vacinação de rotina com testemunho das mães, pais, avós modelo e dos líderes comunitários. ",
      "Reportagens no terreno e transmissões ao vivo",
      "Visitas de advocacia aos régulos ",
      "As autoridades tradicionais orientam os chefes de aldeia e os líderes tradicionais e os chefes de aldeia/bairro e os líderes religiosos a pedir aos pais para vacinarem os seus filhos",
      "Os religiosos abordam os temas sobre o PEV nas suas emissões religiosas de rádio e aquando da sua presença na televisão, bem como em conferências religiosas.",
      "Os religiosos introduzem nos seus sermões temas sobre o PEV pelo menos uma vez por semana ",
      "Os chefes de aldeia/bairro e Agentes de Saúde Comunitária encorajam as mães e os pais a vacinar os seus filhos ",
      "Os SMS de alerta e mensagens sobre o PEV são elaborados e difundidos pelas operadoras de telemóvel. 	",
      "Os líderes das associações e OBC organizam conversas sobre a vacinação nos seus grupos.	",
      "Os vacinadores e prestadores de cuidados organizam conversas educativas com as mães ao nível dos centros de saúde nas salas de espera 	",
      "Os vacinadores aconselham as mães nas sessões de vacinação",
      "Encontros de promoção da vacinação junto das pessoas influentes da comunidade ",
      "Encontros de orientação dos professores e restituição dos resultados da estratégia de adoção através das células pedagógicas (inspetores/diretor da escola e professores, representantes dos alunos) responsáveis pela implementação da estratégia de adoção). ",
      "Reuniões de acompanhamento e de coordenação mensais da estratégia de adoção pelas células pedagógicas e pelos enfermeiros chefes das áreas da saúde.",
      "Os professores enquadram os alunos na implementação da obra da estratégia de adoção na promoção da vacinação e organizam reuniões mensais com os alunos para adoção (ao sábado)",
      "Os alunos recenseiam as crianças a vacinar e incentivam os pais a respeitar o calendário de vacinação	",
      "Organizar uma cerimónia para celebrar os alunos a adotar e premiar as escolas com melhor desempenho ao nível das áreas de saúde ",
      "Os agentes de Saúde Comunitários fazem visitas a domicílio sobre a vacinação e falam às mães, aos pais e às avós",
      "Os Agentes de Saúde Comunitários organizam conversas educativas sobre a vacinação com testemunhos das mães, pais e avó modelos para partilhar as suas boas práticas em matéria de vacinação e convidar os outros a seguir o seu exemplo",
      "Os ASCs fazem visitas domiciliares direcionadas às famílias que não respeitam o calendário de vacinação ou são resilientes",
      "Os curandeiros tradicionais sensibilizam os pais que os consultam sobre o PEV e orientam-nos para os centros de saúde que fazem a vacinação ",
      "Líderes de opinião (pessoas influentes, atletas, artistas) agem como Campeões da vacinação	",
    ],
  ];

  // ---------- ID AGENT CONNECTED ---------------//
  Future<Agent?> getAgent() async {
    return await storage.retrieveAgentConnected();
  }

  //----------------- API SUBMIT ET FENETRE POP-UP DE SUCCESS-----------------//

  void _submitEUM() async {
    if (_formKey.currentState!.validate()) {
      LoadingIndicatorDialog().show(context);
      try {
        String surveySid = widget.dtoSurveyExtration.survey_id;

        // Création de la question "Data de administração"
        SurveyQuestionResponse surveyQuestionResponse0 = SurveyQuestionResponse(
            questionid: 0,
            question: "Data de administração",
            response: DateTime.now().toString());

        // Création des réponses aux questions de l'étape 1
        SurveyQuestionResponse surveyQuestionResponse1 = SurveyQuestionResponse(
            questionid: 1,
            question: questions[0][0],
            response: stepper1Controllers[0].text);
        SurveyQuestionResponse surveyQuestionResponse2 = SurveyQuestionResponse(
            questionid: 2,
            question: questions[0][1],
            response: stepper1Controllers[1].text);
        SurveyQuestionResponse surveyQuestionResponse3 = SurveyQuestionResponse(
            questionid: 3,
            question: questions[0][2],
            response: stepper1Controllers[2].text);
        SurveyQuestionResponse surveyQuestionResponse4 = SurveyQuestionResponse(
            questionid: 4,
            question: questions[0][3],
            response: stepper1Controllers[3].text);
        SurveyQuestionResponse surveyQuestionResponse5 = SurveyQuestionResponse(
            questionid: 5,
            question: questions[0][4],
            response: stepper1Controllers[4].text);
        SurveyQuestionResponse surveyQuestionResponse6 = SurveyQuestionResponse(
            questionid: 6,
            question: questions[0][5],
            response: stepper1Controllers[5].text);
        SurveyQuestionResponse surveyQuestionResponse7 = SurveyQuestionResponse(
            questionid: 7,
            question: questions[0][6],
            response: stepper1Controllers[6].text);
        SurveyQuestionResponse surveyQuestionResponse8 = SurveyQuestionResponse(
            questionid: 8,
            question: questions[0][7],
            response: stepper1Controllers[7].text);

        // Création des réponses aux questions de l'étape 2
        SurveyQuestionResponse surveyQuestionResponse9 = SurveyQuestionResponse(
            questionid: 9,
            question: questions[1][0],
            response: stepper2Controllers[0].text);
        SurveyQuestionResponse surveyQuestionResponse10 =
            SurveyQuestionResponse(
                questionid: 10,
                question: questions[1][1],
                response: stepper2Controllers[1].text);
        SurveyQuestionResponse surveyQuestionResponse11 =
            SurveyQuestionResponse(
                questionid: 11,
                question: questions[1][2],
                response: stepper2Controllers[2].text);
        SurveyQuestionResponse surveyQuestionResponse12 =
            SurveyQuestionResponse(
                questionid: 12,
                question: questions[1][3],
                response: stepper2Controllers[3].text);
        SurveyQuestionResponse surveyQuestionResponse13 =
            SurveyQuestionResponse(
                questionid: 13,
                question: questions[1][4],
                response: stepper2Controllers[4].text);
        SurveyQuestionResponse surveyQuestionResponse14 =
            SurveyQuestionResponse(
                questionid: 14,
                question: questions[1][5],
                response: stepper2Controllers[5].text);
        SurveyQuestionResponse surveyQuestionResponse15 =
            SurveyQuestionResponse(
                questionid: 15,
                question: questions[1][6],
                response: stepper2Controllers[6].text);
        SurveyQuestionResponse surveyQuestionResponse16 =
            SurveyQuestionResponse(
                questionid: 16,
                question: questions[1][7],
                response: stepper2Controllers[7].text);
        SurveyQuestionResponse surveyQuestionResponse17 =
            SurveyQuestionResponse(
                questionid: 17,
                question: questions[1][8],
                response: stepper2Controllers[8].text);
        SurveyQuestionResponse surveyQuestionResponse18 =
            SurveyQuestionResponse(
                questionid: 18,
                question: questions[1][9],
                response: stepper2Controllers[9].text);
        SurveyQuestionResponse surveyQuestionResponse19 =
            SurveyQuestionResponse(
                questionid: 19,
                question: questions[1][10],
                response: stepper2Controllers[10].text);
        SurveyQuestionResponse surveyQuestionResponse20 =
            SurveyQuestionResponse(
                questionid: 20,
                question: questions[1][11],
                response: stepper2Controllers[11].text);
        SurveyQuestionResponse surveyQuestionResponse21 =
            SurveyQuestionResponse(
                questionid: 21,
                question: questions[1][12],
                response: stepper2Controllers[12].text);
        SurveyQuestionResponse surveyQuestionResponse22 =
            SurveyQuestionResponse(
                questionid: 22,
                question: questions[1][13],
                response: stepper2Controllers[13].text);
        SurveyQuestionResponse surveyQuestionResponse23 =
            SurveyQuestionResponse(
                questionid: 23,
                question: questions[1][14],
                response: stepper2Controllers[14].text);
        SurveyQuestionResponse surveyQuestionResponse24 =
            SurveyQuestionResponse(
                questionid: 24,
                question: questions[1][15],
                response: stepper2Controllers[15].text);
        SurveyQuestionResponse surveyQuestionResponse25 =
            SurveyQuestionResponse(
                questionid: 25,
                question: questions[1][16],
                response: stepper2Controllers[16].text);
        SurveyQuestionResponse surveyQuestionResponse26 =
            SurveyQuestionResponse(
                questionid: 26,
                question: questions[1][17],
                response: stepper2Controllers[17].text);
        SurveyQuestionResponse surveyQuestionResponse27 =
            SurveyQuestionResponse(
                questionid: 27,
                question: questions[1][18],
                response: stepper2Controllers[18].text);
        SurveyQuestionResponse surveyQuestionResponse28 =
            SurveyQuestionResponse(
                questionid: 28,
                question: questions[1][19],
                response: stepper2Controllers[19].text);
        SurveyQuestionResponse surveyQuestionResponse29 =
            SurveyQuestionResponse(
                questionid: 29,
                question: questions[1][20],
                response: stepper2Controllers[20].text);
        SurveyQuestionResponse surveyQuestionResponse30 =
            SurveyQuestionResponse(
                questionid: 30,
                question: questions[1][21],
                response: stepper2Controllers[21].text);
        SurveyQuestionResponse surveyQuestionResponse31 =
            SurveyQuestionResponse(
                questionid: 31,
                question: questions[1][22],
                response: stepper2Controllers[22].text);
        SurveyQuestionResponse surveyQuestionResponse32 =
            SurveyQuestionResponse(
                questionid: 32,
                question: questions[1][23],
                response: stepper2Controllers[23].text);
        SurveyQuestionResponse surveyQuestionResponse33 =
            SurveyQuestionResponse(
                questionid: 33,
                question: questions[1][24],
                response: stepper2Controllers[24].text);
        SurveyQuestionResponse surveyQuestionResponse34 =
            SurveyQuestionResponse(
                questionid: 34,
                question: questions[1][25],
                response: stepper2Controllers[25].text);
        SurveyQuestionResponse surveyQuestionResponse35 =
            SurveyQuestionResponse(
                questionid: 35,
                question: questions[1][26],
                response: stepper2Controllers[26].text);
        SurveyQuestionResponse surveyQuestionResponse36 =
            SurveyQuestionResponse(
                questionid: 36,
                question: questions[1][27],
                response: stepper2Controllers[27].text);
        SurveyQuestionResponse surveyQuestionResponse37 =
            SurveyQuestionResponse(
                questionid: 37,
                question: questions[1][28],
                response: stepper2Controllers[28].text);
        SurveyQuestionResponse surveyQuestionResponse38 =
            SurveyQuestionResponse(
                questionid: 38,
                question: questions[1][29],
                response: stepper2Controllers[29].text);
        SurveyQuestionResponse surveyQuestionResponse39 =
            SurveyQuestionResponse(
                questionid: 39,
                question: questions[1][30],
                response: stepper2Controllers[30].text);
        SurveyQuestionResponse surveyQuestionResponse40 =
            SurveyQuestionResponse(
                questionid: 40,
                question: questions[1][31],
                response: stepper2Controllers[31].text);
        SurveyQuestionResponse surveyQuestionResponse41 =
            SurveyQuestionResponse(
                questionid: 41,
                question: questions[1][32],
                response: stepper2Controllers[32].text);
        SurveyQuestionResponse surveyQuestionResponse42 =
            SurveyQuestionResponse(
                questionid: 42,
                question: questions[1][33],
                response: stepper2Controllers[33].text);
        SurveyQuestionResponse surveyQuestionResponse43 =
            SurveyQuestionResponse(
                questionid: 43,
                question: questions[1][34],
                response: stepper2Controllers[34].text);
        SurveyQuestionResponse surveyQuestionResponse44 =
            SurveyQuestionResponse(
                questionid: 44,
                question: questions[1][35],
                response: stepper2Controllers[35].text);
        SurveyQuestionResponse surveyQuestionResponse45 =
            SurveyQuestionResponse(
                questionid: 45,
                question: questions[1][36],
                response: stepper2Controllers[36].text);
        SurveyQuestionResponse surveyQuestionResponse46 =
            SurveyQuestionResponse(
                questionid: 46,
                question: questions[1][37],
                response: stepper2Controllers[37].text);
        SurveyQuestionResponse surveyQuestionResponse47 =
            SurveyQuestionResponse(
                questionid: 47,
                question: questions[1][38],
                response: stepper2Controllers[38].text);
        SurveyQuestionResponse surveyQuestionResponse48 =
            SurveyQuestionResponse(
                questionid: 48,
                question: questions[1][39],
                response: stepper2Controllers[39].text);
        SurveyQuestionResponse surveyQuestionResponse49 =
            SurveyQuestionResponse(
                questionid: 49,
                question: questions[1][40],
                response: stepper2Controllers[40].text);
        SurveyQuestionResponse surveyQuestionResponse50 =
            SurveyQuestionResponse(
                questionid: 50,
                question: questions[1][41],
                response: stepper2Controllers[41].text);
        SurveyQuestionResponse surveyQuestionResponse51 =
            SurveyQuestionResponse(
                questionid: 51,
                question: questions[1][42],
                response: stepper2Controllers[42].text);
        SurveyQuestionResponse surveyQuestionResponse52 =
            SurveyQuestionResponse(
                questionid: 52,
                question: questions[1][43],
                response: stepper2Controllers[43].text);
        SurveyQuestionResponse surveyQuestionResponse53 =
            SurveyQuestionResponse(
                questionid: 53,
                question: questions[1][44],
                response: stepper2Controllers[44].text);
        SurveyQuestionResponse surveyQuestionResponse54 =
            SurveyQuestionResponse(
                questionid: 54,
                question: questions[1][45],
                response: stepper2Controllers[45].text);
        SurveyQuestionResponse surveyQuestionResponse55 =
            SurveyQuestionResponse(
                questionid: 55,
                question: questions[1][46],
                response: stepper2Controllers[46].text);
        SurveyQuestionResponse surveyQuestionResponse56 =
            SurveyQuestionResponse(
                questionid: 56,
                question: questions[1][47],
                response: stepper2Controllers[47].text);
        SurveyQuestionResponse surveyQuestionResponse57 =
            SurveyQuestionResponse(
                questionid: 57,
                question: questions[1][48],
                response: stepper2Controllers[48].text);
        SurveyQuestionResponse surveyQuestionResponse58 =
            SurveyQuestionResponse(
                questionid: 58,
                question: questions[1][49],
                response: stepper2Controllers[49].text);
        SurveyQuestionResponse surveyQuestionResponse59 =
            SurveyQuestionResponse(
                questionid: 59,
                question: questions[1][50],
                response: stepper2Controllers[50].text);

        // Création des réponses aux questions de l'étape 3
        SurveyQuestionResponse surveyQuestionResponse60 =
            SurveyQuestionResponse(
                questionid: 60,
                question: questions[2][0],
                response: stepper3Controllers[0].text);
        SurveyQuestionResponse surveyQuestionResponse61 =
            SurveyQuestionResponse(
                questionid: 61,
                question: questions[2][1],
                response: stepper3Controllers[1].text);
        SurveyQuestionResponse surveyQuestionResponse62 =
            SurveyQuestionResponse(
                questionid: 62,
                question: questions[2][2],
                response: stepper3Controllers[2].text);
        SurveyQuestionResponse surveyQuestionResponse63 =
            SurveyQuestionResponse(
                questionid: 63,
                question: questions[2][3],
                response: stepper3Controllers[3].text);
        SurveyQuestionResponse surveyQuestionResponse64 =
            SurveyQuestionResponse(
                questionid: 64,
                question: questions[2][4],
                response: stepper3Controllers[4].text);
        SurveyQuestionResponse surveyQuestionResponse65 =
            SurveyQuestionResponse(
                questionid: 65,
                question: questions[2][5],
                response: stepper3Controllers[5].text);
        SurveyQuestionResponse surveyQuestionResponse66 =
            SurveyQuestionResponse(
                questionid: 66,
                question: questions[2][6],
                response: stepper3Controllers[6].text);
        SurveyQuestionResponse surveyQuestionResponse67 =
            SurveyQuestionResponse(
                questionid: 67,
                question: questions[2][7],
                response: stepper3Controllers[7].text);

        // Création des réponses aux questions de l'étape 4
        SurveyQuestionResponse surveyQuestionResponse68 =
            SurveyQuestionResponse(
                questionid: 68,
                question: questions[3][0],
                response: stepper4Controllers[0].text);
        SurveyQuestionResponse surveyQuestionResponse69 =
            SurveyQuestionResponse(
                questionid: 69,
                question: questions[3][1],
                response: stepper4Controllers[1].text);
        SurveyQuestionResponse surveyQuestionResponse70 =
            SurveyQuestionResponse(
                questionid: 70,
                question: questions[3][2],
                response: stepper4Controllers[2].text);
        SurveyQuestionResponse surveyQuestionResponse71 =
            SurveyQuestionResponse(
                questionid: 71,
                question: questions[3][3],
                response: stepper4Controllers[3].text);
        SurveyQuestionResponse surveyQuestionResponse72 =
            SurveyQuestionResponse(
                questionid: 72,
                question: questions[3][4],
                response: stepper4Controllers[4].text);
        SurveyQuestionResponse surveyQuestionResponse73 =
            SurveyQuestionResponse(
                questionid: 73,
                question: questions[3][5],
                response: stepper4Controllers[5].text);
        SurveyQuestionResponse surveyQuestionResponse74 =
            SurveyQuestionResponse(
                questionid: 74,
                question: questions[3][6],
                response: stepper4Controllers[6].text);
        SurveyQuestionResponse surveyQuestionResponse75 =
            SurveyQuestionResponse(
                questionid: 75,
                question: questions[3][7],
                response: stepper4Controllers[7].text);
        SurveyQuestionResponse surveyQuestionResponse76 =
            SurveyQuestionResponse(
                questionid: 76,
                question: questions[3][8],
                response: stepper4Controllers[8].text);
        SurveyQuestionResponse surveyQuestionResponse77 =
            SurveyQuestionResponse(
                questionid: 77,
                question: questions[3][9],
                response: stepper4Controllers[9].text);
        SurveyQuestionResponse surveyQuestionResponse78 =
            SurveyQuestionResponse(
                questionid: 78,
                question: questions[3][10],
                response: stepper4Controllers[10].text);
        SurveyQuestionResponse surveyQuestionResponse79 =
            SurveyQuestionResponse(
                questionid: 79,
                question: questions[3][11],
                response: stepper4Controllers[11].text);
        SurveyQuestionResponse surveyQuestionResponse80 =
            SurveyQuestionResponse(
                questionid: 80,
                question: questions[3][12],
                response: stepper4Controllers[12].text);
        SurveyQuestionResponse surveyQuestionResponse81 =
            SurveyQuestionResponse(
                questionid: 81,
                question: questions[3][13],
                response: stepper4Controllers[13].text);
        SurveyQuestionResponse surveyQuestionResponse82 =
            SurveyQuestionResponse(
                questionid: 82,
                question: questions[3][14],
                response: stepper4Controllers[14].text);
        SurveyQuestionResponse surveyQuestionResponse83 =
            SurveyQuestionResponse(
                questionid: 83,
                question: questions[3][15],
                response: stepper4Controllers[15].text);
        SurveyQuestionResponse surveyQuestionResponse84 =
            SurveyQuestionResponse(
                questionid: 84,
                question: questions[3][16],
                response: stepper4Controllers[16].text);
        SurveyQuestionResponse surveyQuestionResponse85 =
            SurveyQuestionResponse(
                questionid: 85,
                question: questions[3][17],
                response: stepper4Controllers[17].text);
        SurveyQuestionResponse surveyQuestionResponse86 =
            SurveyQuestionResponse(
                questionid: 86,
                question: questions[3][18],
                response: stepper4Controllers[18].text);
        SurveyQuestionResponse surveyQuestionResponse87 =
            SurveyQuestionResponse(
                questionid: 87,
                question: questions[3][19],
                response: stepper4Controllers[19].text);
        SurveyQuestionResponse surveyQuestionResponse88 =
            SurveyQuestionResponse(
                questionid: 88,
                question: questions[3][20],
                response: stepper4Controllers[20].text);
        SurveyQuestionResponse surveyQuestionResponse89 =
            SurveyQuestionResponse(
                questionid: 89,
                question: questions[3][21],
                response: stepper4Controllers[21].text);
        SurveyQuestionResponse surveyQuestionResponse90 =
            SurveyQuestionResponse(
                questionid: 90,
                question: questions[3][22],
                response: stepper4Controllers[22].text);
        SurveyQuestionResponse surveyQuestionResponse91 =
            SurveyQuestionResponse(
                questionid: 91,
                question: questions[3][23],
                response: stepper4Controllers[23].text);
        SurveyQuestionResponse surveyQuestionResponse92 =
            SurveyQuestionResponse(
                questionid: 92,
                question: questions[3][24],
                response: stepper4Controllers[24].text);
        SurveyQuestionResponse surveyQuestionResponse93 =
            SurveyQuestionResponse(
                questionid: 93,
                question: questions[3][25],
                response: stepper4Controllers[25].text);
        SurveyQuestionResponse surveyQuestionResponse94 =
            SurveyQuestionResponse(
                questionid: 94,
                question: questions[3][26],
                response: stepper4Controllers[26].text);
        SurveyQuestionResponse surveyQuestionResponse95 =
            SurveyQuestionResponse(
                questionid: 95,
                question: questions[3][27],
                response: stepper4Controllers[27].text);
        SurveyQuestionResponse surveyQuestionResponse96 =
            SurveyQuestionResponse(
                questionid: 96,
                question: questions[3][28],
                response: stepper4Controllers[28].text);
        SurveyQuestionResponse surveyQuestionResponse97 =
            SurveyQuestionResponse(
                questionid: 97,
                question: questions[3][29],
                response: stepper4Controllers[29].text);
        SurveyQuestionResponse surveyQuestionResponse98 =
            SurveyQuestionResponse(
                questionid: 98,
                question: questions[3][30],
                response: stepper4Controllers[30].text);
        SurveyQuestionResponse surveyQuestionResponse99 =
            SurveyQuestionResponse(
                questionid: 99,
                question: questions[3][31],
                response: stepper4Controllers[31].text);
        SurveyQuestionResponse surveyQuestionResponse100 =
            SurveyQuestionResponse(
                questionid: 100,
                question: questions[3][32],
                response: stepper4Controllers[32].text);
        SurveyQuestionResponse surveyQuestionResponse101 =
            SurveyQuestionResponse(
                questionid: 101,
                question: questions[3][33],
                response: stepper4Controllers[33].text);
        SurveyQuestionResponse surveyQuestionResponse102 =
            SurveyQuestionResponse(
                questionid: 102,
                question: questions[3][34],
                response: stepper4Controllers[34].text);
        SurveyQuestionResponse surveyQuestionResponse103 =
            SurveyQuestionResponse(
                questionid: 103,
                question: questions[3][35],
                response: stepper4Controllers[35].text);
        SurveyQuestionResponse surveyQuestionResponse104 =
            SurveyQuestionResponse(
                questionid: 104,
                question: questions[3][36],
                response: stepper4Controllers[36].text);
        SurveyQuestionResponse surveyQuestionResponse105 =
            SurveyQuestionResponse(
                questionid: 105,
                question: questions[3][37],
                response: stepper4Controllers[37].text);
        SurveyQuestionResponse surveyQuestionResponse106 =
            SurveyQuestionResponse(
                questionid: 106,
                question: questions[3][38],
                response: stepper4Controllers[38].text);
        SurveyQuestionResponse surveyQuestionResponse107 =
            SurveyQuestionResponse(
                questionid: 107,
                question: questions[3][39],
                response: stepper4Controllers[39].text);
        SurveyQuestionResponse surveyQuestionResponse108 =
            SurveyQuestionResponse(
                questionid: 108,
                question: questions[3][40],
                response: stepper4Controllers[40].text);
        SurveyQuestionResponse surveyQuestionResponse109 =
            SurveyQuestionResponse(
                questionid: 109,
                question: questions[3][41],
                response: stepper4Controllers[41].text);
        SurveyQuestionResponse surveyQuestionResponse110 =
            SurveyQuestionResponse(
                questionid: 110,
                question: questions[3][42],
                response: stepper4Controllers[42].text);

        // Fusion de toutes les réponses
        List<SurveyQuestionResponse> allResponses = [];
        allResponses
            .add(surveyQuestionResponse0); // Ajout de "Data de administração"

        // Création des réponses aux questions de l'étape 1
        allResponses.add(surveyQuestionResponse1);
        allResponses.add(surveyQuestionResponse2);
        allResponses.add(surveyQuestionResponse3);
        allResponses.add(surveyQuestionResponse4);
        allResponses.add(surveyQuestionResponse5);
        allResponses.add(surveyQuestionResponse6);
        allResponses.add(surveyQuestionResponse7);
        allResponses.add(surveyQuestionResponse8);

        // Création des réponses aux questions de l'étape 2
        allResponses.add(surveyQuestionResponse9);
        allResponses.add(surveyQuestionResponse10);
        allResponses.add(surveyQuestionResponse11);
        allResponses.add(surveyQuestionResponse12);
        allResponses.add(surveyQuestionResponse13);
        allResponses.add(surveyQuestionResponse14);
        allResponses.add(surveyQuestionResponse15);
        allResponses.add(surveyQuestionResponse16);
        allResponses.add(surveyQuestionResponse17);
        allResponses.add(surveyQuestionResponse18);
        allResponses.add(surveyQuestionResponse19);
        allResponses.add(surveyQuestionResponse20);
        allResponses.add(surveyQuestionResponse21);
        allResponses.add(surveyQuestionResponse22);
        allResponses.add(surveyQuestionResponse23);
        allResponses.add(surveyQuestionResponse24);
        allResponses.add(surveyQuestionResponse25);
        allResponses.add(surveyQuestionResponse26);
        allResponses.add(surveyQuestionResponse27);
        allResponses.add(surveyQuestionResponse28);
        allResponses.add(surveyQuestionResponse29);
        allResponses.add(surveyQuestionResponse30);
        allResponses.add(surveyQuestionResponse31);
        allResponses.add(surveyQuestionResponse32);
        allResponses.add(surveyQuestionResponse33);
        allResponses.add(surveyQuestionResponse34);
        allResponses.add(surveyQuestionResponse35);
        allResponses.add(surveyQuestionResponse36);
        allResponses.add(surveyQuestionResponse37);
        allResponses.add(surveyQuestionResponse38);
        allResponses.add(surveyQuestionResponse39);
        allResponses.add(surveyQuestionResponse40);
        allResponses.add(surveyQuestionResponse41);
        allResponses.add(surveyQuestionResponse42);
        allResponses.add(surveyQuestionResponse43);
        allResponses.add(surveyQuestionResponse44);
        allResponses.add(surveyQuestionResponse45);
        allResponses.add(surveyQuestionResponse46);
        allResponses.add(surveyQuestionResponse47);
        allResponses.add(surveyQuestionResponse48);
        allResponses.add(surveyQuestionResponse49);
        allResponses.add(surveyQuestionResponse50);
        allResponses.add(surveyQuestionResponse51);
        allResponses.add(surveyQuestionResponse52);
        allResponses.add(surveyQuestionResponse53);
        allResponses.add(surveyQuestionResponse54);
        allResponses.add(surveyQuestionResponse55);
        allResponses.add(surveyQuestionResponse56);
        allResponses.add(surveyQuestionResponse57);
        allResponses.add(surveyQuestionResponse58);
        allResponses.add(surveyQuestionResponse59);

        // Création des réponses aux questions de l'étape 3
        allResponses.add(surveyQuestionResponse60);
        allResponses.add(surveyQuestionResponse61);
        allResponses.add(surveyQuestionResponse62);
        allResponses.add(surveyQuestionResponse63);
        allResponses.add(surveyQuestionResponse64);
        allResponses.add(surveyQuestionResponse65);
        allResponses.add(surveyQuestionResponse66);
        allResponses.add(surveyQuestionResponse67);

        // Création des réponses aux questions de l'étape 4
        allResponses.add(surveyQuestionResponse68);
        allResponses.add(surveyQuestionResponse69);
        allResponses.add(surveyQuestionResponse70);
        allResponses.add(surveyQuestionResponse71);
        allResponses.add(surveyQuestionResponse72);
        allResponses.add(surveyQuestionResponse73);
        allResponses.add(surveyQuestionResponse74);
        allResponses.add(surveyQuestionResponse75);
        allResponses.add(surveyQuestionResponse76);
        allResponses.add(surveyQuestionResponse77);
        allResponses.add(surveyQuestionResponse78);
        allResponses.add(surveyQuestionResponse79);
        allResponses.add(surveyQuestionResponse80);
        allResponses.add(surveyQuestionResponse81);
        allResponses.add(surveyQuestionResponse82);
        allResponses.add(surveyQuestionResponse83);
        allResponses.add(surveyQuestionResponse84);
        allResponses.add(surveyQuestionResponse85);
        allResponses.add(surveyQuestionResponse86);
        allResponses.add(surveyQuestionResponse87);
        allResponses.add(surveyQuestionResponse88);
        allResponses.add(surveyQuestionResponse89);
        allResponses.add(surveyQuestionResponse90);
        allResponses.add(surveyQuestionResponse91);
        allResponses.add(surveyQuestionResponse92);
        allResponses.add(surveyQuestionResponse93);
        allResponses.add(surveyQuestionResponse94);
        allResponses.add(surveyQuestionResponse95);
        allResponses.add(surveyQuestionResponse96);
        allResponses.add(surveyQuestionResponse97);
        allResponses.add(surveyQuestionResponse98);
        allResponses.add(surveyQuestionResponse99);
        allResponses.add(surveyQuestionResponse100);
        allResponses.add(surveyQuestionResponse101);
        allResponses.add(surveyQuestionResponse102);
        allResponses.add(surveyQuestionResponse103);
        allResponses.add(surveyQuestionResponse104);
        allResponses.add(surveyQuestionResponse105);
        allResponses.add(surveyQuestionResponse106);
        allResponses.add(surveyQuestionResponse107);
        allResponses.add(surveyQuestionResponse108);
        allResponses.add(surveyQuestionResponse109);
        allResponses.add(surveyQuestionResponse110);

        Survey survey = Survey(
          userid: userid, // Assurez-vous que userid est correctement défini
          surveyid: surveySid,
          questionresponse: allResponses,
        );

        await dbHandler.SaveEum(survey);
        LoadingIndicatorDialog().dismiss();

        // ignore: use_build_context_synchronously
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text(
              'SUCESSO',
              textAlign: TextAlign.center,
            ),
            content: SizedBox(
              height: 120,
              child: Column(
                children: [
                  Lottie.asset(
                    'animations/success.json',
                    repeat: true,
                    reverse: true,
                    fit: BoxFit.cover,
                    height: 100,
                  ),
                  const Text(
                    'Atualisaçao effectua com sucesso',
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
            actions: [
              TextButton(
                  onPressed: () {
                    Navigator.pushReplacement(context,
                        MaterialPageRoute(builder: (_) => const HomePage()));
                  },
                  child: const Text('VOLTAR'))
            ],
          ),
        );
      } catch (e) {
        LoadingIndicatorDialog().dismiss();

        // ignore: use_build_context_synchronously
        showDialog(
          context: context,
          barrierDismissible: false,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text(
                'ERRO',
                textAlign: TextAlign.center,
              ),
              content: SizedBox(
                height: 150,
                child: Column(
                  children: [
                    Lottie.asset(
                      'animations/error-dialog.json',
                      repeat: true,
                      reverse: true,
                      fit: BoxFit.cover,
                      height: 120,
                    ),
                    const Text(
                      'Erro occoreu durante atualiçao',
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
              actions: [
                TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: const Text('Tenta de novo'))
              ],
            );
          },
        );
      }
    }
  }

  @override
  void initState() {
    super.initState();

    questionsStep1 = questions[0];
    questionsStep2 = questions[1];
    questionsStep3 = questions[2];
    questionsStep4 = questions[3];

    getAgent().then((value) => userid = value!.id);
  }

  @override
  void dispose() {
    // Libération des contrôleurs pour STEPPER 1
    for (var controller in stepper1Controllers) {
      controller.dispose();
    }

    // Libération des contrôleurs pour STEPPER 2
    for (var controller in stepper2Controllers) {
      controller.dispose();
    }

    // Libération des contrôleurs pour STEPPER 3
    for (var controller in stepper3Controllers) {
      controller.dispose();
    }

    // Libération des contrôleurs pour STEPPER 4
    for (var controller in stepper4Controllers) {
      controller.dispose();
    }

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(70),
        child: AppBar(
          backgroundColor: Defaults.white,
          centerTitle: false,
          leading: Row(
            children: [
              IconButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const HomePage()),
                    );
                  },
                  icon: const Icon(
                    Icons.arrow_back,
                    color: Defaults.bluePrincipal,
                  )),
            ],
          ),
          title: const Text(
            'Questionário Plano',
            softWrap: true,
            style: TextStyle(
                color: Colors.black, fontSize: 16, fontWeight: FontWeight.bold),
          ),
          actions: <Widget>[
            IconButton(
              icon: Image.asset(
                'images/unicef1.png',
                width: 100.0,
                height: 100.0,
              ),
              onPressed: () {
                // Actions à effectuer lorsque le bouton est pressé
              },
            ),
          ],
        ),
      ),
      body: Container(
        height: 2000,
        decoration: const BoxDecoration(color: Defaults.blueFondCadre),
        child: Form(
          key: _formKey,
          child: Theme(
            data: ThemeData(primarySwatch: Defaults.primaryBleuColor),
            child: Stepper(
              controlsBuilder: (BuildContext context, ControlsDetails details) {
                return Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    if (_currentStep == 0) ...[
                      ElevatedButton(
                          onPressed: details.onStepContinue,
                          child: const Text('Next',
                              style: TextStyle(
                                  fontSize: 15, color: Colors.white))),
                    ] else if (_currentStep == 3) ...[
                      ElevatedButton(
                          onPressed: details.onStepCancel,
                          child: const Text('Previous',
                              style: TextStyle(
                                  fontSize: 15, color: Colors.white))),
                      ElevatedButton(
                          onPressed: () {
                            _submitEUM();
                          },
                          child: const Text('Send',
                              style: TextStyle(
                                  fontSize: 15, color: Colors.white))),
                    ] else ...[
                      ElevatedButton(
                          onPressed: details.onStepCancel,
                          child: const Text('Previous',
                              style: TextStyle(
                                  fontSize: 15, color: Colors.white))),
                      ElevatedButton(
                          onPressed: details.onStepContinue,
                          child: const Text('Next',
                              style: TextStyle(
                                  fontSize: 15, color: Colors.white))),
                    ]
                  ],
                );
              },
              type: stepperType,
              physics: const ScrollPhysics(),
              currentStep: _currentStep,
              onStepTapped: (step) => tapped(step),
              onStepContinue: continued,
              onStepCancel: cancel,
              steps: [
                ///--------- STEPPER 1-----------//////

                Step(
                  title: const Text("Investigador informação",
                      softWrap: true,
                      textAlign: TextAlign.justify,
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
                  content: SingleChildScrollView(
                    child: Column(
                      children: <Widget>[
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // 1ère question (liste déroulante)
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                '${questions[0][0]}',
                                softWrap: true,
                                textAlign: TextAlign.justify,
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: AutoCompleteTextField<String>(
                                key: GlobalKey(),
                                suggestions: listOfNameInvestigador,
                                clearOnSubmit: false,
                                textInputAction: TextInputAction.next,
                                controller: stepper1Controllers[0],
                                decoration: InputDecoration(
                                  fillColor: Defaults.white,
                                  filled: true,
                                  border: InputBorder.none,
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12),
                                    borderSide: const BorderSide(
                                        color: Defaults.white, width: 2),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12),
                                    borderSide: const BorderSide(
                                        color: Defaults.white, width: 2),
                                  ),
                                  hintText: "Nome e apelido do Investigador",
                                ),
                                itemFilter: (item, query) {
                                  return item
                                      .toLowerCase()
                                      .contains(query.toLowerCase());
                                },
                                itemSorter: (a, b) {
                                  return a.compareTo(b);
                                },
                                itemSubmitted: (item) {
                                  setState(() {
                                    selectedNameInvestigador = item;
                                  });
                                },
                                itemBuilder: (context, item) {
                                  return Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Text(
                                      item,
                                      style: const TextStyle(fontSize: 16.0),
                                    ),
                                  );
                                },
                              ),
                            ),

                            // 2e question (champ de saisie)
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                '${questions[0][1]}',
                                softWrap: true,
                                textAlign: TextAlign.justify,
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child:
                                  ZoneSaisie(context, stepper1Controllers[1]),
                            ),

                            // 3e question (liste déroulante)

                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                '${questions[0][2]}',
                                softWrap: true,
                                textAlign: TextAlign.justify,
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: DropdownButtonFormField(
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Select Sanitaria';
                                  }
                                  return null;
                                },
                                decoration: InputDecoration(
                                  fillColor: Defaults.white,
                                  filled: true,
                                  border: InputBorder.none,
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12),
                                    borderSide: const BorderSide(
                                        color: Defaults.white, width: 2),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12),
                                    borderSide: const BorderSide(
                                        color: Defaults.white, width: 2),
                                  ),
                                ),
                                value: stepper1Controllers[2].text.isNotEmpty
                                    ? stepper1Controllers[2].text
                                    : null, // Valeur sélectionnée
                                onChanged: (newValue) {
                                  setState(() {
                                    selectedRegiao = newValue!;
                                    // Mettez à jour la liste de la question 4 en fonction de la sélection de la question 3
                                    stepper1Controllers[2].text = newValue;
                                  });
                                },
                                items: regionCities.keys.map((regiao) {
                                  return DropdownMenuItem<String>(
                                    value: regiao,
                                    child: Text(regiao),
                                  );
                                }).toList(),
                              ),
                            ),

                            // 4e question (liste déroulante liée à la question 3)
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                '${questions[0][3]}',
                                softWrap: true,
                                textAlign: TextAlign.justify,
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: DropdownButtonFormField(
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Select Sanitaria';
                                  }
                                  return null;
                                },
                                decoration: InputDecoration(
                                  fillColor: Defaults.white,
                                  filled: true,
                                  border: InputBorder.none,
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12),
                                    borderSide: const BorderSide(
                                        color: Defaults.white, width: 2),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12),
                                    borderSide: const BorderSide(
                                        color: Defaults.white, width: 2),
                                  ),
                                ),
                                value: stepper1Controllers[3].text.isNotEmpty
                                    ? stepper1Controllers[3].text
                                    : null, // Valeur sélectionnée
                                onChanged: (newValue) {
                                  setState(() {
                                    selectedAreas = newValue!;
                                    stepper1Controllers[3].text = newValue;
                                  });
                                },
                                items: (regionCities[selectedRegiao] ?? [])
                                    .map((area) {
                                  return DropdownMenuItem<String>(
                                    value: area,
                                    child: Text(area),
                                  );
                                }).toList(),
                              ),
                            ),

                            // 5e question (champ de saisie)

                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                '${questions[0][4]}',
                                softWrap: true,
                                textAlign: TextAlign.justify,
                              ),
                            ),
                            Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: ZoneSaisie(
                                    context, stepper1Controllers[4])),

                            // 6e question (liste déroulante)

                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                '${questions[0][5]}',
                                softWrap: true,
                                textAlign: TextAlign.justify,
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: DropdownButtonFormField(
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Select persona';
                                  }
                                  return null;
                                },
                                decoration: InputDecoration(
                                  fillColor: Defaults.white,
                                  filled: true,
                                  border: InputBorder.none,
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12),
                                    borderSide: const BorderSide(
                                        color: Defaults.white, width: 2),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12),
                                    borderSide: const BorderSide(
                                        color: Defaults.white, width: 2),
                                  ),
                                ),
                                value: stepper1Controllers[5].text.isNotEmpty
                                    ? stepper1Controllers[5].text
                                    : null, // Valeur sélectionnée
                                onChanged: (newValue) {
                                  setState(() {
                                    stepper1Controllers[5].text = newValue!;
                                  });
                                },
                                items: listOfPessoasEntrevistadas.map((option) {
                                  return DropdownMenuItem<String>(
                                    value: option,
                                    child: Text(option),
                                  );
                                }).toList(),
                              ),
                            ),

                            // 7e question (champ de saisie)

                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                '${questions[0][6]}',
                                softWrap: true,
                                textAlign: TextAlign.justify,
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: TextFormField(
                                controller: stepper1Controllers[
                                    6], // Utilisez le troisième contrôleur de votre liste
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Entra nomme de perssoa';
                                  }
                                  return null;
                                },
                                decoration: InputDecoration(
                                  fillColor: Defaults.white,
                                  filled: true,
                                  border: InputBorder.none,
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12),
                                    borderSide: const BorderSide(
                                        color: Defaults.white, width: 2),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12),
                                    borderSide: const BorderSide(
                                        color: Defaults.white, width: 2),
                                  ),
                                ),
                              ),
                            ),

                            // 8e question (champ de saisie)

                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                '${questions[0][7]}',
                                softWrap: true,
                                textAlign: TextAlign.justify,
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: TextFormField(
                                controller: stepper1Controllers[
                                    7], // Utilisez le quatrième contrôleur de votre liste
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Entra numero de perssoa';
                                  }
                                  return null;
                                },
                                decoration: InputDecoration(
                                  fillColor: Defaults.white,
                                  filled: true,
                                  border: InputBorder.none,
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12),
                                    borderSide: const BorderSide(
                                        color: Defaults.white, width: 2),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12),
                                    borderSide: const BorderSide(
                                        color: Defaults.white, width: 2),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  isActive: _currentStep >= 0,
                  state: _currentStep >= 0
                      ? StepState.complete
                      : StepState.disabled,
                ),

                ///--------- STEPPER 2-----------//////

                Step(
                  title: const Text(
                      "Actividades previstas no PSC 2018-2022 do PAV",
                      softWrap: true,
                      textAlign: TextAlign.justify,
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
                  content: Column(
                    children: <Widget>[
                      ...questionsStep2.map((question) {
                        int index = questionsStep2.indexOf(question);
                        TextEditingController controller =
                            stepper2Controllers[index];
                        return Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                '${questions[1][index]}',
                                softWrap: true,
                                textAlign: TextAlign.justify,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: DropdownButtonFormField(
                                decoration: InputDecoration(
                                  fillColor: Defaults.white,
                                  filled: true,
                                  border: InputBorder.none,
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12),
                                    borderSide: const BorderSide(
                                        color: Defaults.white, width: 2),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12),
                                    borderSide: const BorderSide(
                                        color: Defaults.white, width: 2),
                                  ),
                                ),
                                value: controller.text.isNotEmpty
                                    ? controller.text
                                    : null, // Valeur sélectionnée
                                onChanged: (String? newValue) {
                                  setState(() {
                                    controller.text = newValue!;
                                  });
                                },
                                items: listOfResponses.map((name) {
                                  return DropdownMenuItem<String>(
                                    value: name,
                                    child: Text(name),
                                  );
                                }).toList(),
                              ),
                            ),
                          ],
                        );
                      }).toList(),
                    ],
                  ),
                  isActive: _currentStep >= 0,
                  state: _currentStep >= 1
                      ? StepState.complete
                      : StepState.disabled,
                ),

                ///--------- STEPPER 3-----------//////

                Step(
                  title: const Text(
                    "Os detentores dos media oferecem tempo de antena e asseguram a difusão/publicação regular de emissões e de artigos consagrados ao PEV",
                    softWrap: true,
                    textAlign: TextAlign.justify,
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                  ),
                  content: Column(
                    children: <Widget>[
                      ...questionsStep3.map((question) {
                        int index = questionsStep3.indexOf(question);
                        TextEditingController controller =
                            stepper3Controllers[index];
                        return Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                '${questions[2][index]}',
                                softWrap: true,
                                textAlign: TextAlign.justify,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: DropdownButtonFormField(
                                decoration: InputDecoration(
                                  fillColor: Defaults.white,
                                  filled: true,
                                  border: InputBorder.none,
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12),
                                    borderSide: const BorderSide(
                                        color: Defaults.white, width: 2),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12),
                                    borderSide: const BorderSide(
                                        color: Defaults.white, width: 2),
                                  ),
                                ),
                                value: controller.text.isNotEmpty
                                    ? controller.text
                                    : null, // Valeur sélectionnée
                                onChanged: (String? newValue) {
                                  setState(() {
                                    controller.text = newValue!;
                                  });
                                },
                                items: listOfResponses.map((name) {
                                  return DropdownMenuItem<String>(
                                    value: name,
                                    child: Text(name),
                                  );
                                }).toList(),
                              ),
                            ),
                          ],
                        );
                      }).toList(),
                    ],
                  ),
                  isActive: _currentStep >= 0,
                  state: _currentStep >= 2
                      ? StepState.complete
                      : StepState.disabled,
                ),

                ///--------- STEPPER 4-----------//////

                Step(
                  title: const Text(
                      "As ONGs participam nas atividades de comunicação PEV",
                      softWrap: true,
                      textAlign: TextAlign.justify,
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
                  content: Column(
                    children: <Widget>[
                      ...questionsStep4.map((question) {
                        int index = questionsStep4.indexOf(question);
                        TextEditingController controller =
                            stepper4Controllers[index];
                        return Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                '${questions[3][index]}',
                                softWrap: true,
                                textAlign: TextAlign.justify,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: DropdownButtonFormField(
                                decoration: InputDecoration(
                                  fillColor: Defaults.white,
                                  filled: true,
                                  border: InputBorder.none,
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12),
                                    borderSide: const BorderSide(
                                        color: Defaults.white, width: 2),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12),
                                    borderSide: const BorderSide(
                                        color: Defaults.white, width: 2),
                                  ),
                                ),
                                value: controller.text.isNotEmpty
                                    ? controller.text
                                    : null, // Valeur sélectionnée
                                onChanged: (String? newValue) {
                                  setState(() {
                                    controller.text = newValue!;
                                  });
                                },
                                items: listOfResponses.map((name) {
                                  return DropdownMenuItem<String>(
                                    value: name,
                                    child: Text(name),
                                  );
                                }).toList(),
                              ),
                            ),
                          ],
                        );
                      }).toList(),
                    ],
                  ),
                  isActive: _currentStep >= 0,
                  state: _currentStep >= 3
                      ? StepState.complete
                      : StepState.disabled,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  tapped(int step) {
    setState(() => _currentStep = step);
  }

  continued() {
    _currentStep < 3 ? setState(() => _currentStep += 1) : null;
  }

  cancel() {
    _currentStep > 0 ? setState(() => _currentStep -= 1) : null;
  }
}*/
