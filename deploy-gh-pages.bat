@echo off
cd /d "%~dp0"
echo ====================================
echo  رفع المشروع إلى GitHub Pages
echo ====================================
echo.

REM Check if git is available
where git >nul 2>&1
if %errorlevel% neq 0 (
    echo Git غير مثبت على جهازك!
    echo حمل من: https://git-scm.com/downloads/win
    pause
    exit /b
)

REM Initialize repo if needed
if not exist .git (
    git init
    git add .
    git commit -m "النسخة الأولى"
)

REM Build the project
echo جاري بناء المشروع...
call npm run build

REM Create gh-pages branch with dist content
echo جاري إنشاء فرع gh-pages...
git subtree push --prefix dist origin gh-pages 2>nul || (
    git branch -D gh-pages 2>nul
    git checkout --orphan gh-pages
    if exist dist (
        for /f %%i in ('dir /b') do (
            if not "%%i"=="dist" if not "%%i"==".git" (rd /s /q "%%i" 2>nul || del "%%i" 2>nul)
        )
        move dist\* . 2>nul
        rmdir dist 2>nul
    )
    git add .
    git commit -m "deploy"
    git push origin gh-pages --force
    git checkout main
)

echo.
echo ====================================
echo  تم الرفع بنجاح!
echo ====================================
echo.
echo 1- اذهب إلى: https://github.com/new
echo 2- اختار اسم للمشروع وانشئ الـ repo
echo 3- اتبع التعليمات التي تظهر لترفع الكود
echo.
echo بعد الرفع:
echo Settings ^> Pages ^> Source: gh-pages
echo.
pause
