package com.mongodb.utility;

import java.io.File;
import java.io.FileOutputStream;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.util.Base64;
import java.util.List;

import org.bson.types.Binary;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.CommandLineRunner;
import org.springframework.stereotype.Component;

import com.mongodb.model.IFile;
import com.mongodb.repository.FileRepository;

@Component
public class MongoDbRunner implements CommandLineRunner {
	
	private static final Logger logger = LoggerFactory.getLogger(MongoDbRunner.class);

	@Autowired
	FileRepository fileRepository;

	@Override
	public void run(String... args) throws Exception {
		@SuppressWarnings("unused")
		List<IFile> filesList = fileRepository.findAll();
		logger.info("------------------------------------");
		logger.info("The number of documents in the collection is :: " + filesList.size());
		for (int i = 0; i < filesList.size(); i++) {
			String fileName = filesList.get(i).getFileName();
			String filePath = filesList.get(i).getFilePath();
			if (filePath == null) {
				filePath = "default";
				logger.info(" path is ::  " + filePath);
			}
			logger.info("The file path and name is ::  " + filePath +"   "+fileName );

			Binary fileData = filesList.get(i).getFileData();
			FileOutputStream fos;
			byte[] decodedBytes = Base64.getDecoder()
					.decode(Base64.getEncoder().encodeToString(filesList.get(i).getFileData().getData()));
			try {
				Path path = Paths.get(filePath);
				Files.createDirectories(path);
				//logger.info("The downloaded path is :: " + filePath + "/" + fileName);
				fos = new FileOutputStream(new File(filePath + "/" + fileName));
				fos.write(decodedBytes);
				fos.close();
			} catch (Exception e) {
				logger.info(e.getStackTrace().toString());
			}
		}
		logger.info("------------------------------------");
	}

}
