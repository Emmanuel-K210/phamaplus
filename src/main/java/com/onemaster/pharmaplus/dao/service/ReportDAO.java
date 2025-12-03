package com.onemaster.pharmaplus.dao.service;

import com.onemaster.pharmaplus.model.Report;

import java.time.LocalDate;
import java.util.List;
import java.util.Map;

public interface ReportDAO {
    void insert(Report report);

    void update(Report report);

    void delete(Integer reportId);

    Report findById(Integer reportId);

    List<Report> findAll();

    List<Report> findByType(String reportType);

    List<Report> findByDateRange(LocalDate startDate, LocalDate endDate);

    List<Report> findRecentReports(int limit);

    int countByType(String reportType);

    Map<String, Integer> getReportStatistics();
}
