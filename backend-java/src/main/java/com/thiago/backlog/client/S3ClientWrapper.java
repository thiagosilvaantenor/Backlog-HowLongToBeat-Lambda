package com.thiago.backlog.client;
import org.slf4j.LoggerFactory;
import org.slf4j.Logger;

import software.amazon.awssdk.core.ResponseBytes;
import software.amazon.awssdk.core.sync.RequestBody;
import software.amazon.awssdk.regions.Region;
import software.amazon.awssdk.services.s3.S3Client;
import software.amazon.awssdk.services.s3.model.GetObjectRequest;
import software.amazon.awssdk.services.s3.model.GetObjectResponse;
import software.amazon.awssdk.services.s3.model.NoSuchKeyException;
import software.amazon.awssdk.services.s3.model.PutObjectRequest;

public class S3ClientWrapper {
    private String bucketName;
    private S3Client s3Client;
    private static final Logger LOGGER = LoggerFactory.getLogger(S3ClientWrapper.class);

    public S3ClientWrapper(String bucketName){
        this.s3Client = S3Client.builder()
            .region(Region.US_EAST_1)
            .build();
        this.bucketName = bucketName;
    }


    public byte[] buscaArquivoS3(String nomeArquivo){
        try {
            GetObjectRequest getRequest = GetObjectRequest.builder()
                    .bucket(this.bucketName)
                    .key(nomeArquivo)
                    .build();
            ResponseBytes<GetObjectResponse> objetoBytes = this.s3Client.getObjectAsBytes(
                getRequest);
            return objetoBytes.asByteArray();
        } catch (NoSuchKeyException e) {
            // Arquivo não existe, retorna array vazio
            // ExcelManager vai saber que precisa criar do zero
            LOGGER.warn("Arquivo não encontrado no S3. Uma nova planilha sera criada");
            return new byte[0];
        }
    }

    public void enviaArquivoS3(byte[] dadosAtualizados, String nomeArquivo){
        PutObjectRequest putRequest = PutObjectRequest.builder()
            .bucket(this.bucketName)
            .key(nomeArquivo)
            .build();
        
        this.s3Client.putObject(putRequest, RequestBody.fromBytes(dadosAtualizados));
    }

}
