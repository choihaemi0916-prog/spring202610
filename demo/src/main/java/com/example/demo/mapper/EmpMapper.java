package com.example.demo.mapper;

import java.util.HashMap;
import java.util.List;

import org.apache.ibatis.annotations.Mapper;

import com.example.demo.model.Emp;
import com.example.demo.model.Professor;
@Mapper
public interface EmpMapper {
	// 사원 목록
	List<Emp> selectEmpList(HashMap<String, Object> map);
	
	// 사원 삭제
	int deleteEmp(HashMap<String, Object> map); 
	
	// 사원 추가
	int insertEmp(HashMap<String, Object> map); 
	
	// 사원 조회
	Emp selectEmp(HashMap<String, Object> map);
	
	// 사원 수정
	void updateEmp(HashMap<String, Object> map); 
	
	List<Emp> selectGradeList(HashMap<String, Object> map);
}

