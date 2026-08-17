# מתקין Claude Code בלחיצה אחת - Windows

מתקין אוטומטי שמרים לך VS Code, Git, Node.js ו-Claude Code על Windows בלי לחיצה אחת ידנית.

## התקנה מהירה

**התקנה בשורה אחת** (פותחים PowerShell as Administrator):

```powershell
iex ($(try { irm https://raw.githubusercontent.com/peleg-jpg/claude-code-installer/main/windows/install.ps1 } catch { irm https://cdn.jsdelivr.net/gh/peleg-jpg/claude-code-installer@9f99db6703b8b17a74451ca602e67f813656c05e/windows/install.ps1 }))
```

**או, אם אתה מעדיף לקלון את הריפו:**

```
git clone https://github.com/peleg-jpg/claude-code-installer.git
cd claude-code-installer\windows
install.bat
```

## מה הוא עושה

1. **VS Code** - מתקין דרך winget (fallback: הורדה ישירה), מוסיף ל-PATH
2. **Git** - מתקין דרך winget (fallback: הורדה ישירה), מוסיף ל-PATH
3. **הגדרות Git** - ברנץ דיפולטיבי `main`, VS Code כעורך, credential helper של Windows
4. **Node.js** - מתקין nvm-windows ואחר כך Node.js LTS דרך nvm
5. **npm** - מעדכן לגרסה האחרונה
6. **Claude Code** - מתקין גלובלית דרך npm
7. **Bun** - מתקין runtime מהיר נוסף ל-JS
8. **GitHub CLI** - מתקין את `gh`
9. **תוסף Claude Code ל-VS Code** - מתקין אוטומטית
10. **הגדרות VS Code** - auto-save, גודל פונט, format-on-save, וכו'

## דרישות

- Windows 10 או Windows 11
- חיבור לאינטרנט
- הרשאות מנהל (הסקריפט יבקש הרשאה אוטומטית אם צריך)

## מצב דיבאג

מקבלים פלט מפורט לפתרון בעיות:

```
install.bat -debug
```

## הגדרות

עורכים את `src/config.json` כדי לשנות:

- הגדרות VS Code ואת רשימת התוספים
- ההגדרות הגלובליות של Git
- דרישות גרסה מינימליות
- כתובות הורדה

## איך זה עובד

- `install.bat` הוא נקודת הכניסה. הוא מזהה לבד אם הוא רץ מתוך קלון מקומי או מתוך התקנה מרוחקת
- אם רץ מתוך ריפו מקלוןן, הוא משתמש בקבצים המקומיים
- אם הורד כקובץ עצמאי, הוא מביא את `src/installer.ps1` ואת `src/config.json` מ-GitHub
- `src/installer.ps1` עושה את כל העבודה האמיתית
- כל שלב בודק אם הכלי כבר מותקן ומדלג אם כן
- אפס שאלות, הכל אוטומטי

## הסרה

להסרת כל מה שהותקן (פותחים PowerShell as Administrator):

```powershell
irm https://github.com/peleg-jpg/claude-code-installer/archive/main.zip -OutFile "$env:TEMP\cci.zip"; Expand-Archive "$env:TEMP\cci.zip" "$env:TEMP\cci" -Force; & "$env:TEMP\cci\claude-code-installer-main\windows\uninstall.bat"
```

יוסר VS Code, Git, Node.js (nvm-windows), Bun, GitHub CLI ו-Claude Code, וגם כל ההגדרות שלהם. תתבקש לאשר לפני שזה רץ.

## מבנה תיקיות

```
windows/
├── install.bat            # נקודת כניסה (משגר)
├── uninstall.bat          # משגר הסרה
├── src/
│   ├── installer.ps1      # המתקין הראשי ב-PowerShell
│   ├── uninstaller.ps1    # מסיר ראשי ב-PowerShell
│   └── config.json        # הגדרות
└── README.md              # הקובץ הזה
```
