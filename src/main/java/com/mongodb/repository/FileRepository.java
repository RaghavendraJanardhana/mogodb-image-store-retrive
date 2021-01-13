package com.mongodb.repository;

import java.util.Optional;

import org.springframework.data.mongodb.repository.MongoRepository;

import com.mongodb.model.IFile;


public interface FileRepository extends MongoRepository<IFile, String> {

	Optional<IFile> findByFileName(String name);
	Optional<IFile> deleteByFileName(String name);



}