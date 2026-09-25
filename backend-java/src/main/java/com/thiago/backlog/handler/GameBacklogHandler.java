package com.thiago.backlog.handler;

import com.amazonaws.services.lambda.runtime.RequestHandler;

import java.util.HashMap;
import java.util.Map;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import com.amazonaws.services.lambda.runtime.Context;

import com.google.gson.Gson;
import com.thiago.backlog.client.S3ClientWrapper;
import com.thiago.backlog.excel.ExcelManager;
import com.thiago.backlog.model.GameInfo;


public class GameBacklogHandler implements RequestHandler<Map<String, Object>, Map<String, Object>>{
    
    private static final Logger LOGGER = LoggerFactory.getLogger(GameBacklogHandler.class);
    private final S3ClientWrapper s3Client;
    private final Gson gson = new Gson();
    private final ExcelManager excelManager;

    public GameBacklogHandler() {
        String bucketName = System.getenv("BACKLOG_BUCKET_NAME");
        this.s3Client = new S3ClientWrapper(bucketName);
        this.excelManager = new ExcelManager();
    }
    
    @Override
    public Map<String, Object> handleRequest(Map<String, Object> event, Context contexto) {
        
        Map<String, Object> response = new HashMap<>();
        Map<String, Object> headers = new HashMap<>();
        headers.put("Access-Control-Allow-Origin", "*");
        headers.put("Content-Type", "application/json");
        response.put("headers", headers);

        try {
            //Extrai a string do body que vem no evento do API Gateway
            String bodyString = (String) event.get("body");

            //corpo da requisição vazio
            if (bodyString == null || bodyString.isEmpty()){
                response.putAll(criarResposta(400, Map.of("erro", "Corpo da requisição vazio")));
                return response;
            }
            
            //Converte o JSON do frontend para a classe GameInfo
            GameInfo jogo = gson.fromJson(bodyString, GameInfo.class);
            LOGGER.info("Processando jogo: {}", jogo.getNomeJogo());

            //Executa a orquestração
            String nomeArquivo = "meu_backlog.xlsx";
            byte[] planilhaAtual = s3Client.buscaArquivoS3(nomeArquivo);
            byte[] planilhaNova = excelManager.adicionarJogoNaPlanilha(jogo, planilhaAtual);
            s3Client.enviaArquivoS3(planilhaNova, nomeArquivo);

            //retorna sucesso
            response.putAll(criarResposta(200,
                Map.of("mensagem", "Jogo adicionado e enviado na planilha para o bucket do s3")));

        } catch (Exception e) {
            LOGGER.error("Erro interno ao processar a planilha", e);
            response.putAll(criarResposta(500, Map.of("erro", "Erro ao processar: " + e.getMessage())));
        }

        return response;
    }
        
    public Map<String, Object> criarResposta(Integer codigoStatus,Map<String, String> bodyArgs){
        Map<String, Object> response = new HashMap<>();
        response.put("statusCode", codigoStatus);
        response.put("body", gson.toJson(bodyArgs));

        return response;
    }
}