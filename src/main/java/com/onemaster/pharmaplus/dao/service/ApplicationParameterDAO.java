package com.onemaster.pharmaplus.dao.service;

import com.onemaster.pharmaplus.model.ApplicationParameter;

import java.util.List;
import java.util.Map;

public interface ApplicationParameterDAO {

    void insert(ApplicationParameter parameter);

    void update(ApplicationParameter parameter);

    void delete(String parameterKey);

    ApplicationParameter findByKey(String parameterKey);

    List<ApplicationParameter> findAll();

    List<ApplicationParameter> findByCategory(String category);

    Map<String, String> getAllAsMap();

    boolean existsByKey(String parameterKey);

    // Méthodes utilitaires
    String getValue(String parameterKey, String defaultValue);

    Integer getIntValue(String parameterKey, Integer defaultValue);

    Boolean getBooleanValue(String parameterKey, Boolean defaultValue);

    Double getDoubleValue(String parameterKey, Double defaultValue);
}
