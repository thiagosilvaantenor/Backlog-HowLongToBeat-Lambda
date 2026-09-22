import json
from howlongtobeatpy import HowLongToBeat
from src.utils.logger import Logger

logger = Logger().get_logger()

def buscaJogo(nome:str):
    logger.info(f"Iniciando busca do jogo,{nome}")
    resultados = None;
    while resultados is None:
        resultados = HowLongToBeat().search(nome);
        if resultados is None:
            logger.error(f'Nenhum jogo encontrado com o nome: {nome}')
            return None
        
        jogos = []
        for i in range(len(resultados)):
            jogos.append(resultados[i])
        
        logger.info('Jogos encontrados com esse nome: ')
        logger.info([jogo.game_name for jogo in jogos])
        return jogos
    
        

        