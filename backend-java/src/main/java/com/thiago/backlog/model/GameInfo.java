package com.thiago.backlog.model;

public class GameInfo {
    /**
     * Classe modelo de informações do jogo
     * Nome do jogo
     * TempoMedio de finalização
     */
    private String nomeJogo;
    private String plataforma;
    private Double tempoMedio;
    private Double tempoComplecionista;
    private Double tempoGasto;
    private String status;
    private String nota;

    //GETTERS
    public String getNomeJogo() {
        return this.nomeJogo;
    }

    public Double getTempoMedio() {
        return this.tempoMedio;
    }

    public String getPlataforma() {
        return plataforma;
    }

    public Double getTempoComplecionista() {
        return tempoComplecionista;
    }

    public Double getTempoGasto() {
        return tempoGasto;
    }

    public String getStatus() {
        return status;
    }

    public String getNota() {
        return nota;
    }

    //SETTERS
    public void setNomeJogo(String nomeJogo) {
        this.nomeJogo = nomeJogo;
    }
    public void setTempoMedio(Double tempoMedio) {
        this.tempoMedio = tempoMedio;
    }

    public void setPlataforma(String plataforma) {
        this.plataforma = plataforma;
    }

    public void setTempoComplecionista(Double tempoComplecionista) {
        this.tempoComplecionista = tempoComplecionista;
    }

    public void setTempoGasto(Double tempoGasto) {
        this.tempoGasto = tempoGasto;
    }

    public void setStatus(String status) {
        this.status = status;
    }

    public void setNota(String nota) {
        this.nota = nota;
    }
    

}
