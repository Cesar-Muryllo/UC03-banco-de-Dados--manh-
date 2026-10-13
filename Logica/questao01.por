programa
{
	funcao inicio()
	{

		inteiro caixas_produzidas, paletes_completos, caixas_sobra
		real peso_caixa_kg, temperatura_camara, peso_total
		logico camara_ok, palete_ok

        const inteiro CAIXAS_POR_PALETE = 40
		const real TEMP_MAXIMA_PERMITIDA = -18.0

		escreva("Digite a quantidade de caixas produzidas: ")
		leia(caixas_produzidas)
		escreva("Digite o peso de cada caixa (kg): ")
		leia(peso_caixa_kg)
		escreva("Digite a temperatura da câmara fria (°C): ")
		leia(temperatura_camara)

		peso_total = caixas_produzidas * peso_caixa_kg
		paletes_completos = caixas_produzidas / CAIXAS_POR_PALETE
		caixas_sobra = caixas_produzidas % CAIXAS_POR_PALETE
		camara_ok = temperatura_camara <= TEMP_MAXIMA_PERMITIDA
		palete_ok = paletes_completos >= 1

		escreva("--- PRODUÇÃO ---\n")
		escreva("1) Peso total produzido: ", peso_total, " kg\n")
		escreva("2) Paletes completos: ", paletes_completos, " | Caixas restantes: ", caixas_sobra, "\n")
		escreva("3) Status: ")
		
        se (camara_ok e palete_ok)
		{
			escreva("Carregamento liberado\n")
		}
		senao se (nao camara_ok e nao palete_ok)
		{
			escreva("Bloqueado: câmara acima de −18 °C e nenhum palete completo\n")
		}
		senao se (nao camara_ok)
		{
			escreva("Bloqueado: câmara acima de −18 °C\n")
		}
		senao
		{
			escreva("Bloqueado: nenhum palete completo\n")
		}
	}
}