package com.onemaster.pharmaplus.service;


import com.onemaster.pharmaplus.dao.impl.MedicalServiceTypeDAOImpl;
import com.onemaster.pharmaplus.dao.service.MedicalServiceTypeDAO;
import com.onemaster.pharmaplus.model.MedicalServiceType;
import java.util.List;

public class MedicalServiceTypeService {
    
    private MedicalServiceTypeDAO serviceTypeDAO;
    
    public MedicalServiceTypeService() {
        this.serviceTypeDAO = new MedicalServiceTypeDAOImpl();
    }
    
    public Integer saveServiceType(MedicalServiceType serviceType) {
        return serviceTypeDAO.save(serviceType);
    }
    
    public MedicalServiceType getServiceTypeById(Integer id) {
        return serviceTypeDAO.findById(id);
    }
    
    public MedicalServiceType getServiceTypeByCode(String serviceCode) {
        return serviceTypeDAO.findByCode(serviceCode);
    }
    
    public List<MedicalServiceType> getAllServiceTypes() {
        return serviceTypeDAO.findAll();
    }
    
    public List<MedicalServiceType> getServiceTypesByCategory(String category) {
        return serviceTypeDAO.findByCategory(category);
    }
    
    public List<MedicalServiceType> getActiveServiceTypes() {
        return serviceTypeDAO.findActiveServices();
    }
    
    public boolean updateServiceType(MedicalServiceType serviceType) {
        return serviceTypeDAO.update(serviceType);
    }
    
    public boolean deleteServiceType(Integer id) {
        return serviceTypeDAO.delete(id);
    }
    
    public boolean deactivateServiceType(Integer id) {
        return serviceTypeDAO.deactivate(id);
    }
    
    public boolean activateServiceType(Integer id) {
        return serviceTypeDAO.activate(id);
    }
    
    public List<String> getAllCategories() {
        if (serviceTypeDAO instanceof MedicalServiceTypeDAOImpl) {
            return ((MedicalServiceTypeDAOImpl) serviceTypeDAO).getAllCategories();
        }
        return List.of();
    }
    
    public Double getServicePrice(String serviceCode) {
        if (serviceTypeDAO instanceof MedicalServiceTypeDAOImpl) {
            return ((MedicalServiceTypeDAOImpl) serviceTypeDAO).getServicePrice(serviceCode);
        }
        return null;
    }
    
    // Méthodes utilitaires
    public List<MedicalServiceType> getConsultationServices() {
        return getServiceTypesByCategory("Consultation");
    }
    
    public List<MedicalServiceType> getExamenServices() {
        return getServiceTypesByCategory("Examen");
    }
    
    public boolean serviceExists(String serviceCode) {
        return getServiceTypeByCode(serviceCode) != null;
    }
}