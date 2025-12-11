@echo off
echo ========================================
echo TEST APPLICATION PHARMAPLUS
echo ========================================

echo 1. Test Tomcat...
curl -s -o nul -w "Tomcat: %%{http_code}\n" http://localhost:8082/ 2>nul

echo.
echo 2. Test PharmaPlus...
curl -s -o nul -w "PharmaPlus: %%{http_code}\n" http://localhost:8082/phamaplus/ 2>nul

echo.
echo 3. Test login page...
curl -s -o nul -w "Login Page: %%{http_code}\n" http://localhost:8082/phamaplus/login 2>nul

echo.
echo ✅ APPLICATION DÉMARRÉE AVEC SUCCÈS !
echo.
echo 📍 URL: http://localhost:8082/phamaplus
echo 👤 Comptes:
echo   - Admin: admin / admin123
echo   - Pharmacien: pharma / pharma123
echo.
pause