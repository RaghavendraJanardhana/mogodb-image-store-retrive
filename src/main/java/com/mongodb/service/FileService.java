package com.mongodb.service;

import java.io.IOException;
import java.util.Optional;

import org.bson.BsonBinarySubType;
import org.bson.types.Binary;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.mongodb.core.MongoTemplate;
import org.springframework.data.mongodb.core.query.Criteria;
import org.springframework.data.mongodb.core.query.Query;
import org.springframework.data.mongodb.core.query.Update;
import org.springframework.stereotype.Service;
import org.springframework.web.multipart.MultipartFile;

import com.mongodb.model.IFile;
import com.mongodb.repository.FileRepository;



@Service
public class FileService {

	@Autowired
    private MongoTemplate mongoTemplate;
    @Autowired
    private FileRepository fileRepo;

    public IFile getFile(String id) {
        return fileRepo.findById(id).get();
    }
    
    public Optional<IFile> getFileByFileName(String name) {
        return fileRepo.findByFileName(name);
    }
    public Optional<IFile> delFileByFileName(String name) {
        return fileRepo.deleteByFileName(name);
    }

    public String addFile(MultipartFile file,String fileName,String filePath) throws IOException {
        IFile fileObj = new IFile();
        fileObj.setFilePath(filePath);
        fileObj.setFileName(fileName);
        fileObj.setFileData(new Binary(BsonBinarySubType.BINARY, file.getBytes()));
        fileObj = fileRepo.insert(fileObj);
        return fileObj.getId();
        
    }
    public IFile updateFile(MultipartFile file,String id) throws IOException {
        Query query = new Query();
        query.addCriteria(Criteria.where("id").is(id));
        Update update = new Update();
        update.set("fileData",new Binary(BsonBinarySubType.BINARY, file.getBytes()));
        return mongoTemplate.findAndModify(query, update, IFile.class);
        
    }
}