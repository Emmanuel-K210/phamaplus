package com.onemaster.pharmaplus.dao.service;

import com.onemaster.pharmaplus.model.MedicalServiceType;
import java.util.List;

public interface MedicalServiceTypeDAO {
    Integer save(MedicalServiceType serviceType);
    MedicalServiceType findById(Integer id);
    MedicalServiceType findByCode(String serviceCode);
    List<MedicalServiceType> findAll();
    List<MedicalServiceType> findByCategory(String category);
    List<MedicalServiceType> findActiveServices();
    boolean update(MedicalServiceType serviceType);
    boolean delete(Integer id);
    boolean deactivate(Integer id);
    boolean activate(Integer id);
}