package com.pocketmind.config;

import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import org.springframework.stereotype.Component;
import org.springframework.web.servlet.HandlerInterceptor;

import java.util.Map;
import java.util.concurrent.ConcurrentHashMap;
import java.util.concurrent.atomic.AtomicInteger;

/**
 * Simple rate limiting interceptor
 * Limits requests per IP address
 */
@Component
public class RateLimitInterceptor implements HandlerInterceptor {
    
    private static final int MAX_REQUESTS = 100;
    private static final long TIME_WINDOW_MS = 60000; // 1 minute
    
    private final Map<String, RequestCounter> requestCounters = new ConcurrentHashMap<>();
    
    @Override
    public boolean preHandle(HttpServletRequest request, HttpServletResponse response, Object handler) {
        String clientIp = getClientIp(request);
        RequestCounter counter = requestCounters.computeIfAbsent(
            clientIp, 
            k -> new RequestCounter()
        );
        
        if (counter.isRateLimited()) {
            response.setStatus(HttpServletResponse.SC_TOO_MANY_REQUESTS);
            response.setHeader("X-RateLimit-Limit", String.valueOf(MAX_REQUESTS));
            response.setHeader("X-RateLimit-Remaining", "0");
            return false;
        }
        
        counter.increment();
        response.setHeader("X-RateLimit-Limit", String.valueOf(MAX_REQUESTS));
        response.setHeader("X-RateLimit-Remaining", String.valueOf(MAX_REQUESTS - counter.getCount()));
        
        return true;
    }
    
    private String getClientIp(HttpServletRequest request) {
        String ip = request.getHeader("X-Forwarded-For");
        if (ip == null || ip.isEmpty()) {
            ip = request.getRemoteAddr();
        }
        return ip;
    }
    
    private static class RequestCounter {
        private final AtomicInteger count = new AtomicInteger(0);
        private long windowStart = System.currentTimeMillis();
        
        public synchronized boolean isRateLimited() {
            long now = System.currentTimeMillis();
            if (now - windowStart > TIME_WINDOW_MS) {
                // Reset window
                count.set(0);
                windowStart = now;
                return false;
            }
            return count.get() >= MAX_REQUESTS;
        }
        
        public synchronized void increment() {
            count.incrementAndGet();
        }
        
        public int getCount() {
            return count.get();
        }
    }
}

