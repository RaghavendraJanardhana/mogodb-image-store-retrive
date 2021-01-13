package com.mongodb.controller;
import java.io.File;
import java.io.FileOutputStream;
import java.io.IOException;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.util.Base64;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.core.io.ResourceLoader;
import org.springframework.http.HttpHeaders;
import org.springframework.http.HttpStatus;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.DeleteMapping;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.PutMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;
import org.springframework.web.multipart.MultipartFile;

import com.mongodb.model.IFile;
import com.mongodb.service.FileService;

@RestController
public class FileController {

	private static final Logger logger = LoggerFactory.getLogger(FileController.class);

	@Autowired
	private FileService fileService;
	@Autowired
	ResourceLoader resourceLoader;

	@GetMapping(value="/files/{id}",produces=MediaType.MULTIPART_FORM_DATA_VALUE)
	public String getFile(@PathVariable String id) {
		IFile file = fileService.getFile(id);
		byte[] decodedBytes = Base64.getDecoder()
				.decode(Base64.getEncoder().encodeToString(file.getFileData().getData()));
		String decodedString = new String(decodedBytes);
		return decodedString;
	}

	@GetMapping(value="/files/id/{id}",produces=MediaType.MULTIPART_FORM_DATA_VALUE)
	public ResponseEntity<byte[]> getDownloadData(@PathVariable String id) throws Exception {
		IFile file = fileService.getFile(id);

		byte[] decodedBytes = Base64.getDecoder()
				.decode(Base64.getEncoder().encodeToString(file.getFileData().getData()));
		String decodedString = new String(decodedBytes);
		String fileName = file.getFileName();
		HttpHeaders responseHeaders = new HttpHeaders();
		responseHeaders.set("charset", "utf-8");
		responseHeaders.setContentType(MediaType.valueOf("text/html"));
		responseHeaders.setContentLength(decodedBytes.length);
		String filename = "attachment; filename=" + fileName;
		// responseHeaders.set("Content-disposition", "attachment;
		// filename=fileName.fileExtenstion");
		responseHeaders.set("Content-disposition", filename);
		return new ResponseEntity<byte[]>(decodedBytes, responseHeaders, HttpStatus.OK);
	}

	@GetMapping(value="/files/name/{fileName}",produces = MediaType.APPLICATION_OCTET_STREAM_VALUE)
	public ResponseEntity<byte[]> getDownloadDataByName(@PathVariable String fileName) {
		FileOutputStream fos;
		IFile ifile = fileService.getFileByFileName(fileName).orElse(null);
		if (ifile == null) {
			HttpHeaders responseHeaders = new HttpHeaders();
			responseHeaders.set("charset", "utf-8");
			responseHeaders.setContentType(MediaType.valueOf("text/html"));

			return new ResponseEntity<byte[]>(responseHeaders, HttpStatus.NO_CONTENT);
		}
		String filePath = ifile.getFilePath();
		byte[] decodedBytes = Base64.getDecoder()
				.decode(Base64.getEncoder().encodeToString(ifile.getFileData().getData()));
		String decodedString = new String(decodedBytes);

		try {
			Path path = Paths.get(filePath);
			Files.createDirectories(path);
			logger.info("The donloaded path is :: " +filePath + "/" + fileName);
			// fos = new FileOutputStream(new File("src/main/resources/" + fileName));
			fos = new FileOutputStream(new File(filePath + "/" + fileName));
			fos.write(decodedBytes);
			fos.close();

		} catch (Exception e) {
			logger.error(e.toString());

		}
		HttpHeaders responseHeaders = new HttpHeaders();
		responseHeaders.set("charset", "utf-8");
		responseHeaders.setContentType(MediaType.valueOf("text/html"));
		responseHeaders.setContentLength(decodedBytes.length);
		String filename = "attachment; filename=" + fileName;
		responseHeaders.set("Content-disposition", filename);
		return new ResponseEntity<byte[]>(decodedBytes, responseHeaders, HttpStatus.OK);
	}

	@PostMapping(value="/files/add",consumes= MediaType.MULTIPART_FORM_DATA_VALUE)
	public String addFile(@RequestParam("file") MultipartFile file, @RequestParam("filePath") String filePath) {
		String id = null;
		try {
			logger.info("The file name is :: " + file.getOriginalFilename());
			id = fileService.addFile(file, file.getOriginalFilename(), filePath);
			logger.info("The file id is :: " + id);
			return id;

		} catch (Exception e) {
			id = "File does't exist or dupilcation file name";
			logger.error("Exception inside the post metods");
			e.printStackTrace();
		}
		return id;
	}

	@DeleteMapping("/files/name/{fileName}")
	public String delFileByName(@PathVariable String fileName) {
		IFile ifile = fileService.delFileByFileName(fileName).orElse(null);
		if (ifile == null) {
			return "The file " + fileName + " is not present.";

		}
		return "The file " + fileName + " is deleted successfully.";

	}

	@PutMapping(value="/files/name/{fileName}",consumes=MediaType.MULTIPART_FORM_DATA_VALUE)
	public ResponseEntity<String> updateByFileName(@RequestParam("file") MultipartFile file,
			@PathVariable() String fileName) throws IOException {
		logger.info("The file name is :: " + file.getOriginalFilename());
		IFile ifile = fileService.getFileByFileName(fileName).orElse(null);
		if (ifile == null) {
			return new ResponseEntity<String>("The " + fileName + " does not exist.", HttpStatus.BAD_REQUEST);
		} else {
			IFile id = fileService.updateFile(file, ifile.getId());
			logger.info("The file id is :: " + id);
			return new ResponseEntity<String>("The " + fileName + " updated successfully and Id " + id,
					HttpStatus.ACCEPTED);

		}

	}

}