# מתקין Claude Code בלחיצה אחת

מתקין אחד שמכין לך את כל סביבת הפיתוח של Claude Code, גם על Mac וגם על Windows. מדביקים שורה אחת בטרמינל, מקבלים סביבה מוכנה לעבודה. בלי לחיצות, בלי שאלות, בלי להתעסק.

מתאים למי שלא רוצה להתעסק עם Git, Node, ו-VS Code ידנית, וגם לסטודנטים שזה היום הראשון שלהם עם Claude Code.

## התקנה מהירה

### macOS

פותחים Terminal ומדביקים:

```bash
curl -fsSL https://raw.githubusercontent.com/peleg-jpg/claude-code-installer/main/mac/install.sh | bash
```

### Windows

פותחים **PowerShell as Administrator** (קליק ימני -> Run as administrator) ומדביקים:

```powershell
irm "https://raw.githubusercontent.com/peleg-jpg/claude-code-installer/main/windows/install.bat" -OutFile install.bat; .\install.bat
```

## מה מותקן

| כלי                                     | בשביל מה                                               |
| --------------------------------------- | ------------------------------------------------------ |
| **Xcode Command Line Tools** (Mac בלבד) | תלות של Homebrew, git ושל הקומפיילרים                  |
| **Homebrew** (Mac בלבד)                 | מנהל החבילות של macOS                                  |
| **Git**                                 | ניהול גרסאות                                           |
| **VS Code**                             | עורך הקוד, עם הגדרות שפויות מראש                       |
| **Claude Code VS Code Extension**       | התוסף הרשמי של Anthropic לאינטגרציה ב-VS Code          |
| **nvm** / **nvm-windows**               | מנהל גרסאות Node                                       |
| **Node.js (LTS)** + **npm** עדכני       | סביבת JavaScript                                       |
| **Claude Code**                         | מותקן גלובלית דרך npm                                  |
| **Bun**                                 | runtime מהיר ל-JS, שימושי בזרימות עבודה עם Claude Code |
| **GitHub CLI** (`gh`)                   | עבודה מול GitHub מהטרמינל                              |

המתקין גם כותב הגדרות VS Code עם דעה (auto-save, format-on-save, minimap כבוי, גופן טרמינל גדול יותר) והגדרות Git חכמות (הברנץ הדיפולטיבי הוא `main`, VS Code כעורך הדיפולטיבי, ועוד פרטים שמשתנים בין Mac ל-Windows).

## עקרונות

- **בלי שאלות** - הכל אוטומטי
- **בטוח להריץ שוב** - מזהה מה כבר מותקן ומדלג
- **בדיקות גרסה חכמות** - לא יתקין מחדש אם הגרסה שלך עדכנית
- **מתקדם לאט-לאט עם סימני התקדמות** - מספרים, צבעים, וסימוני `[OK]` / `[SKIP]` / `[FAIL]`
- **מצב דיבאג** - מעבירים `--debug` (Mac) או `-debug` (Windows) ומקבלים פלט מפורט

## אחרי ההתקנה

1. פותחים **חלון טרמינל חדש** כדי שעדכוני ה-PATH ייכנסו לתוקף
2. מקלידים `code` כדי לפתוח VS Code
3. פותחים את הטרמינל המובנה של VS Code (ב-Windows ``Ctrl+` ``, ב-Mac ``Cmd+` ``)
4. מקלידים `claude` כדי להפעיל את Claude Code
5. בריצה הראשונה תתבקש להתחבר

## בדיקה

```bash
code --version
git --version
node --version
npm --version
bun --version
gh --version
claude --version
```

## בעיות נפוצות

- **macOS:** אם קופץ דיאלוג שמבקש להתקין Command Line Tools, לוחצים `Install` ומחכים. Homebrew יבקש סיסמת מערכת (סיסמת ההתחברות למק).
- **Apple Silicon (M1/M2/M3) וגם Intel** נתמכים שניהם.
- **Windows:** אם `winget` לא קיים, המתקין נופל אוטומטית להורדה ישירה. חובה להריץ מ-PowerShell מורם (Administrator).
- **מצב דיבאג:**
  - Mac: `curl -fsSL ...install.sh | bash -s -- --debug`
  - Win: `install.bat -debug`

## הסרה

### macOS

```bash
curl -fsSL https://raw.githubusercontent.com/peleg-jpg/claude-code-installer/main/mac/uninstall.sh | bash
```

### Windows

```powershell
irm "https://raw.githubusercontent.com/peleg-jpg/claude-code-installer/main/windows/uninstall.bat" -OutFile uninstall.bat; .\uninstall.bat
```

> ב-Mac, ה-Uninstaller לא מסיר את Xcode Command Line Tools בכוונה, כי כלים אחרים במערכת תלויים בהם.

## פירוט לפי מערכת

- [README של macOS](mac/README.md)
- [README של Windows](windows/README.md)

## איך זה עובד

לכל מערכת מבנה זהה:

```
mac/
  install.sh           # משגר דק (מזהה לבד אם אתה מקלוןן ריפו או מריץ דרך curl)
  uninstall.sh         # מסיר את הכל
  src/
    installer.sh       # הלוגיקה עצמה
    config.json        # גרסאות, תוספים, הגדרות

windows/
  install.bat          # משגר דק
  uninstall.bat
  src/
    installer.ps1
    uninstaller.ps1
    config.json
```

המשגר בודק אם `src/installer.*` נמצא לידו על הדיסק. אם כן, מריץ מקומית. אם לא (כי המשתמש הריץ `curl ... | bash`), הוא מוריד את `installer.*` ואת `config.json` לתיקייה זמנית ומריץ משם. ככה אותה שורת פקודה עובדת גם אם קלונת את הריפו וגם אם פשוט הדבקת את ה-One Liner.

## בדיקות אוטומטיות

הריפו מריץ GitHub Actions בכל push: מתקין על runner נקי של macos-latest ושל windows-latest, מאמת שכל הכלים נמצאים ב-PATH ועונים על `--version`, ואז מריץ את המתקין שוב כדי לוודא שאפשר להריץ פעמיים בלי בעיות.

## רישיון

MIT - ראה [LICENSE](LICENSE).
