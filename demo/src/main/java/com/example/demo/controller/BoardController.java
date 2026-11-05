package com.example.demo.controller;

import java.util.HashMap;
import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import com.example.demo.dao.BoardService;
import com.fasterxml.jackson.core.type.TypeReference;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.google.gson.Gson;

@Controller
public class BoardController {
	@Autowired
	BoardService boardService;
	
	@RequestMapping("/board/list.do")
	public String list(Model model) throws Exception{
		return "/board/list";
	}
	
	@RequestMapping(value = "/board/list.dox", method = RequestMethod.POST, produces = "application/json;charset=UTF-8")
	@ResponseBody
	public String list(Model model, @RequestParam HashMap<String, Object> map) throws Exception {
		HashMap<String, Object> resultMap = new HashMap<String, Object>();
		System.out.println("dox 호출!!");
		
		resultMap = boardService.getBoardList(map);
		
		return new Gson().toJson(resultMap); 
	}
	
	@RequestMapping(value = "/board/remove.dox", method = RequestMethod.POST, produces = "application/json;charset=UTF-8")
	@ResponseBody
	public String remove(Model model, @RequestParam HashMap<String, Object> map) throws Exception {
		HashMap<String, Object> resultMap = new HashMap<String, Object>();
		System.out.println(map);
		resultMap = boardService.removeBoard(map);
		
		return new Gson().toJson(resultMap); 
	}	
	
	// 여러개 삭제
	@RequestMapping(value = "/board/remove-all.dox", method = RequestMethod.POST, produces = "application/json;charset=UTF-8")
	@ResponseBody
	public String removeAll(Model model, @RequestParam HashMap<String, Object> map) throws Exception {
		HashMap<String, Object> resultMap = new HashMap<String, Object>();
		String json = map.get("selectItemList").toString();
		ObjectMapper mapper = new ObjectMapper();
		List<Object> list = mapper.readValue(json, new TypeReference<List<Object>>() {});
		map.put("list", list);
		System.out.println(map);
		
		resultMap = boardService.removeBoardAll(map);
		
		return new Gson().toJson(resultMap); 
	}
	
}
