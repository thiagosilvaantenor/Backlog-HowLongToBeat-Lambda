package com.thiago.backlog.excel;

import java.io.ByteArrayInputStream;
import java.io.ByteArrayOutputStream;
import java.io.IOException;
import java.io.InputStream;

import org.apache.poi.ss.usermodel.Row;
import org.apache.poi.ss.usermodel.Sheet;
import org.apache.poi.ss.usermodel.Workbook;
import org.apache.poi.xssf.usermodel.XSSFWorkbook;

import com.thiago.backlog.model.GameInfo;

public class ExcelManager {
    
    public byte[] adicionarJogoNaPlanilha(GameInfo jogo, byte[] dadosS3) throws IOException{
        //Caso retornar vazio do s3
        Workbook workbook = null;
        Sheet sheet = null;
        
        if (dadosS3 == null || dadosS3.length == 0){
            criarPlanilha(workbook, sheet);
        } else{
            //Lida com os dados do s3
            InputStream streamDados = new ByteArrayInputStream(dadosS3);
            workbook = new XSSFWorkbook(streamDados);
            sheet = workbook.getSheetAt(0);
        }

        // Lida com as linhas da planilha
        int ultimaLinha = sheet.getLastRowNum();
        Row linha = sheet.createRow(ultimaLinha+1);

        //Add dados
        int cellnum = 0;
        //Nome jogo
        linha.createCell(cellnum++).setCellValue(jogo.getNomeJogo() != null ? jogo.getNomeJogo() : "");

        //Plataforma
        linha.createCell(cellnum++).setCellValue(jogo.getPlataforma() != null ? jogo.getPlataforma() : "");

        //Tempo medio
        if (jogo.getTempoMedio() != null) linha.createCell(cellnum).setCellValue(jogo.getTempoMedio());
        cellnum++;

        //tempoComplecionista
        if (jogo.getTempoComplecionista() != null) linha.createCell(cellnum).setCellValue(jogo.getTempoComplecionista());
        cellnum++;

        //tempoGasto
        if (jogo.getTempoGasto() != null ) linha.createCell(cellnum).setCellValue(jogo.getTempoGasto());
        cellnum++;

        //Status
        linha.createCell(cellnum++).setCellValue(jogo.getStatus() != null ? jogo.getStatus() : "A definir");

        //nota
        linha.createCell(cellnum++).setCellValue(jogo.getNota() != null ? jogo.getNota() : "A definir");


        try{
            ByteArrayOutputStream outputStream = new ByteArrayOutputStream();
            workbook.write(outputStream);
            workbook.close();
            //Salva tudo e retorna
            return outputStream.toByteArray();
        }
        catch(IOException ex){
            throw new IOException("Oops, houve um erro na hora de escrever a planilha");
        }
    }


    private void criarPlanilha(Workbook workbook, Sheet sheet){
        workbook = new XSSFWorkbook();
        sheet = workbook.createSheet("Backlog");

        // Cria headers
        Row headerRow = sheet.createRow(0);
        headerRow.createCell(0).setCellValue("Nome do Jogo");
        headerRow.createCell(1).setCellValue("Plataforma");
        headerRow.createCell(2).setCellValue("Tempo Médio");
        headerRow.createCell(3).setCellValue("Tempo Complecionista");
        headerRow.createCell(4).setCellValue("Tempo Gasto");
        headerRow.createCell(5).setCellValue("Status");
        headerRow.createCell(6).setCellValue("Nota");
    }


}
