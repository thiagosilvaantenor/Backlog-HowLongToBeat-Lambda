from howlongtobeatpy import HowLongToBeat
from src.utils.logger import Logger

logger = Logger().get_logger()


def buscaJogo(nome: str):
    logger.info(f"Iniciando busca do jogo,{nome}")
    resultados = None
    try:
        resultados = HowLongToBeat().search(nome)
    except Exception as ex:
        logger.error(f"Erro ao acessar API do HLTB: {ex}")
        return None

    if not resultados:
        logger.error(f"Nenhum jogo encontrado com o nome: {nome}")
        return None

    jogos = []
    jogos = [resultado for resultado in resultados]
    # for i in range(len(resultados)):
    #     jogos.append(resultados[i])

    logger.info("Jogos encontrados com esse nome: ")
    logger.info([jogo.game_name for jogo in jogos])
    return jogos
