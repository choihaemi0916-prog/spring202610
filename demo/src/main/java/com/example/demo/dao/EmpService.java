package com.example.demo.dao;

import java.util.HashMap;
import java.util.List;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service; // @Service 추가
import com.example.demo.mapper.EmpMapper;
import com.example.demo.model.Emp;

@Service // 스프링 빈 등록
public class EmpService {

    @Autowired
    private EmpMapper empMapper; // private 접근 제어자 권장

    public HashMap<String, Object> getEmpList(HashMap<String, Object> map) {
        HashMap<String, Object> resultMap = new HashMap<>();
        List<Emp> list = empMapper.selectEmpList(map); 
        resultMap.put("list", list);
        resultMap.put("result", "success");
        return resultMap;
    }

    public HashMap<String, Object> removeEmp(HashMap<String, Object> map) {
        HashMap<String, Object> resultMap = new HashMap<>();
        empMapper.deleteEmp(map);
        resultMap.put("result", "success");
        return resultMap;
    }
}
