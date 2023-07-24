User Function EXP0018()
	Local oScroll
	Local nGrafico := BARCOMPCHART
	
	Static oMonitor

	DEFINE MSDIALOG oMonitor TITLE "Grafico" FROM 0,0  TO 600,900 COLORS 0, 16777215 PIXEL 
	oScroll := TScrollArea():New(oMonitor,01,01,500,800)
	oScroll:Align := CONTROL_ALIGN_ALLCLIENT    
	
	Grafico(oScroll,nGrafico)
	
	oMenu := TBar():New( oMonitor, 48, 48, .T., , ,"CONTEUDO_BODY-FUNDO", .T. )
	DEFINE BUTTON RESOURCE "FW_PIECHART_1"		OF oMenu	ACTION Grafico(oScroll,PIECHART) 	 PROMPT " "	TOOLTIP "Pizza"			
	DEFINE BUTTON RESOURCE "FW_LINECHART_1"		OF oMenu	ACTION Grafico(oScroll,LINECHART) 	 PROMPT " "	TOOLTIP "Linha"			
	DEFINE BUTTON RESOURCE "FW_BARCHART_1"		OF oMenu	ACTION Grafico(oScroll,BARCHART) 	 PROMPT " "	TOOLTIP "Barra"			
	DEFINE BUTTON RESOURCE "FW_BARCOMPCHART_2"	OF oMenu	ACTION Grafico(oScroll,BARCOMPCHART) PROMPT " "	TOOLTIP "Barra"			
	
	ACTIVATE MSDIALOG oMonitor CENTERED
Return

Static Function Grafico(oScroll,nGrafico)
	Local oChart
	Local cQuery:= ""
	
	If Valtype(oChart)=="O"
		FreeObj(@oChart) //Usando a função FreeObj liberamos o objeto para ser recriado novamente, gerando um novo gráfico
	Endif
	
	oChart := FWChartFactory():New()
	oChart := oChart:getInstance( nGrafico ) 
	oChart:init( oScroll )
	oChart:SetTitle("Saldos Bancários", CONTROL_ALIGN_LEFT)
	oChart:SetMask( "R$ *@*")
	oChart:SetPicture("@E 999,999,999.99")
	oChart:setColor("Random") //Deixamos o protheus definir as cores do gráfico
	If nGrafico == PIECHART //se o gráfico tipo pizza, deixamos a legenda no rodapé
		oChart:SetLegend( CONTROL_ALIGN_BOTTOM )
	Endif	
	oChart:nTAlign := CONTROL_ALIGN_ALLCLIENT

	//Uma consulta bem Simples
	cQuery := " SELECT * FROM "+ RETSQLNAME("SE8") + " SE8 "
	cQuery += " WHERE SE8.D_E_L_E_T_='' "
	cQuery += " AND E8_FILIAL='"+xFilial("SE8")+"' "
	cQuery += " AND E8_CONTA='XXXXX-X' AND E8_DTSALAT &gt;= '20190601'"
	cQuery += " ORDER BY E8_DTSALAT"

	If ( SELECT("TRBACD") ) &gt; 0
		dbSelectArea("TRBACD")
		TRBACD-&gt;(dbCloseArea())
	EndIf

	TcQuery cQuery Alias "TRBACD" New
	TRBACD-&gt;(dbGoTop())

	//Se a série for unica o tipo de variável deve ser NUMÉRICO Ex.: (cTitle, 10)
	//Se for multi série o tipo de variável deve ser Array de numéricos Ex.: (cTitle, {10,20,30} )
	If TRBACD-&gt;(!EOF())
		While TRBACD-&gt;(!EOF())
			if nGrafico==LINECHART .OR. nGrafico==BARCOMPCHART 
				//Neste dois tipos de graficos temos:
				//(Titulo, {{ Descrição, Valor }})
				oChart:addSerie( "Conta " + TRBACD-&gt;E8_CONTA   , { { DTOC(STOD(TRBACD-&gt;E8_DTSALAT)), TRBACD-&gt;E8_SALATUA   } } )
			Else
				//Aqui temos:
				//(Titulo, Valor)
				oChart:AddSerie(DTOC(STOD(TRBACD-&gt;E8_DTSALAT)),TRBACD-&gt;E8_SALATUA)
			Endif
			TRBACD-&gt;(dbSkip())
		End
		oChart:build()
	Endif

	
Return
