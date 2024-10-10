package org.example.demo;

import javax.servlet.*;
import javax.servlet.annotation.WebFilter;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;
import java.util.ArrayList;
import java.util.List;

@WebFilter(filterName = "LoginFilter", urlPatterns = "/*")
public class LoginFilter implements Filter {

    private List<String> excludedPaths;


    @Override
    public void init(FilterConfig filterConfig) throws ServletException {
        excludedPaths = new ArrayList<>();
        excludedPaths.add("/login");
        excludedPaths.add("/register");
        excludedPaths.add("/public");
    }//排除列表
    private boolean isExcluded(String path) {
        for (String excludedPath : excludedPaths) {
            if (path.startsWith(excludedPath)) {
                return true;
            }
        }
        return false;
    }//判断是否在排除列表中
    @Override
    public void doFilter(ServletRequest servletRequest, ServletResponse servletResponse, FilterChain filterChain) throws IOException, ServletException {
        HttpServletRequest request = (HttpServletRequest) servletRequest;
        HttpServletResponse response = (HttpServletResponse) servletResponse;

        String requestPath = request.getServletPath();

        if (isExcluded(requestPath)) {
            filterChain.doFilter(request, response);
            return;
        }//检查当前请求是否是对登录页面、注册页面或公共资源的请求,其实就是检查是否在排除列表之中。如果是,则允许请求通过。

        HttpSession session = request.getSession(false);
        if (session!= null && session.getAttribute("user")!= null) {
            filterChain.doFilter(request, response);
        } else {
            response.sendRedirect("/login");
        }//检查用户是否有user属性来判断是否已登录，否则，重定向到登录页面。
    }

    @Override
    public void destroy() {

    }


}