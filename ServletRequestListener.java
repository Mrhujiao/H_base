package org.example.demo;


import javax.servlet.ServletRequestEvent;
import javax.servlet.annotation.WebListener;
import javax.servlet.http.HttpServletRequest;
import java.io.FileWriter;
import java.io.IOException;
import java.io.PrintWriter;
import java.util.Date;

@WebListener
public class ServletRequestListener implements javax.servlet.ServletRequestListener {

    private static final String LOG_FILE_PATH = "request_log.txt";
//日志表位于ret
    @Override
    public void requestInitialized(ServletRequestEvent sre) {
        HttpServletRequest request = (HttpServletRequest) sre.getServletRequest();
        sre.getServletRequest().setAttribute("startTime", new Date());
    }

    @Override
    public void requestDestroyed(ServletRequestEvent sre) {
        Date startTime = (Date) sre.getServletRequest().getAttribute("startTime");
        if (startTime!= null) {
            Date endTime = new Date();
            long processingTime = endTime.getTime() - startTime.getTime();
//在请求开始时记录开始时间，在请求结束时计算处理时间。
            HttpServletRequest request = (HttpServletRequest) sre.getServletRequest();
            String clientIp = request.getRemoteAddr();
            String method = request.getMethod();
            String uri = request.getRequestURI();
            String queryString = request.getQueryString();
            String userAgent = request.getHeader("User-Agent");
//记录的信息应包括：
//  ○ 请求时间
//  ○ 客户端 IP 地址
//  ○ 请求方法（GET, POST 等）
//  ○ 请求 URI
//  ○ 查询字符串（如果有）
//  ○ User-Agent
//  ○ 请求处理时间
            try (PrintWriter writer = new PrintWriter(new FileWriter(LOG_FILE_PATH, true))) {
                writer.println(String.format("请求时间：%s，客户端 IP 地址：%s，请求方法：%s，请求 URI：%s，查询字符串：%s，User-Agent：%s，请求处理时间：%d 毫秒",
                        startTime, clientIp, method, uri, queryString, userAgent, processingTime));
            } catch (IOException e) {
                e.printStackTrace();
//打印异常的堆栈跟踪信息
            }
        }
    }
}