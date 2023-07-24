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
