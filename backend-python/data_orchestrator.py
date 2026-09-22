import json
from src.busca_jogos import buscaJogo

CORS_HEADERS = {"Access-Control-Allow-Origin": "*", "Content-Type": "application/json"}


def lambda_handler(event, context):
    # Pega o nome do jogo que vem na url
    parametros = event.get("queryStringParameters", {})
    nome_jogo = parametros.get("q", "")

    if nome_jogo == "":
        return {
            "statusCode": 400,
            "headers": CORS_HEADERS,
            "body": json.dumps({"error": "Informe o nome do jogo"}),
        }

    resultados = buscaJogo(nome_jogo)

    if resultados is None or resultados == "":
        return {
            "statusCode": 404,
            "headers": CORS_HEADERS,
            "body": json.dumps({"error": "Nenhum jogo encontrado"}),
        }

    lista_formatada = []
    for jogo in resultados:
        lista_formatada.append(
            {
                "id": jogo.game_id,
                "nome": jogo.game_name,
                "imagem": jogo.game_image_url,
                "tempo_main": jogo.main_story,
            }
        )
    return {
        "statusCode": 200,
        "headers": CORS_HEADERS,
        "body": json.dumps({"lista_jogos": lista_formatada}),
    }


# if __name__ == "__main__":
#     lambda_handler("", "")
