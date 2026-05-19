# מתקין Claude Code בלחיצה אחת - macOS

מתקין אוטומטי שמרים לך VS Code, Git, Node.js ו-Claude Code על Mac בלי לחיצה אחת ידנית.

## התקנה מהירה

**התקנה בשורה אחת** (פותחים Terminal):

```bash
curl -fsSL https://raw.githubusercontent.com/peleg-jpg/claude-code-installer/main/mac/install.sh | bash
```

**או, אם אתה מעדיף לקלון את הריפו:**

```bash
git clone https://github.com/peleg-jpg/claude-code-installer.git
cd claude-code-installer/mac
bash install.sh
```

## מה הוא עושה

1. **Xcode CLI Tools** - מתקין אם אין (חובה ל-Homebrew ול-Git)
2. **Homebrew** - מתקין את מנהל החבילות של Mac
3. **Git** - מתקין דרך Homebrew
4. **הגדרות Git** - ברנץ דיפולטיבי `main`, VS Code כעורך, credential helper של Mac
5. **VS Code** - מתקין דרך Homebrew cask ומוסיף את `code` ל-PATH
6. **nvm** - מתקין את מנהל גרסאות Node
7. **Node.js** - מתקין גרסת LTS דרך nvm
8. **npm** - מעדכן לגרסה האחרונה
9. **Claude Code** - מתקין גלובלית דרך npm
10. **Bun** - מתקין runtime מהיר נוסף ל-JS
11. **GitHub CLI** - מתקין את `gh`
12. **תוסף Claude Code ל-VS Code** - מתקין אוטומטית
13. **הגדרות VS Code** - auto-save, גודל פונט, format-on-save, וכו'

## דרישות

- macOS 12 (Monterey) ומעלה
- חיבור לאינטרנט
- Apple Silicon (M1/M2/M3/M4) או Intel - שניהם נתמכים

## מצב דיבאג

מקבלים פלט מפורט לפתרון בעיות:

```bash
bash install.sh --debug
```

או בשורה אחת:

```bash
curl -fsSL https://raw.githubusercontent.com/peleg-jpg/claude-code-installer/main/mac/install.sh | bash -s -- --debug
```

## הגדרות

עורכים את `src/config.json` כדי לשנות:

- הגדרות VS Code ואת רשימת התוספים
- ההגדרות הגלובליות של Git
- דרישות גרסה מינימליות

## איך זה עובד

- `install.sh` הוא נקודת הכניסה. הוא מזהה לבד אם הוא רץ מתוך קלון מקומי או מתוך curl
- אם רץ מתוך ריפו מקלוןן, הוא משתמש בקבצים המקומיים
- אם רץ דרך pipe מ-curl, הוא מוריד את `src/installer.sh` ואת `src/config.json` מ-GitHub
- `src/installer.sh` עושה את כל העבודה האמיתית
- משתמש ב-Homebrew בתור מנהל חבילות (ל-Git ול-VS Code)
- משתמש ב-nvm לניהול גרסאות Node.js
- כל שלב בודק אם הכלי כבר מותקן ומדלג אם כן
- אפס שאלות, הכל אוטומטי

## הסרה

להסרת כל מה שהותקן:

```bash
curl -fsSL https://raw.githubusercontent.com/peleg-jpg/claude-code-installer/main/mac/uninstall.sh | bash
```

יוסר VS Code, Git (גרסת Homebrew), Node.js (nvm), Homebrew, Bun, GitHub CLI ו-Claude Code, וגם כל ההגדרות שלהם. תתבקש לאשר לפני שזה רץ.

> **שים לב:** Xcode Command Line Tools לא יוסרו בכוונה, כי כלים אחרים במערכת תלויים בהם.

## הערות

- Homebrew מתקין ב-`/opt/homebrew` ב-Apple Silicon וב-`/usr/local` ב-Intel
- המתקין מוסיף את Homebrew ואת VS Code ל-PATH של ה-shell שלך אוטומטית
- nvm נטען מ-`~/.nvm/nvm.sh` - השורה הזו נוספת לפרופיל ה-shell אוטומטית
- אחרי ההתקנה כדאי לפתוח חלון טרמינל חדש כדי שכל עדכוני ה-PATH ייכנסו לתוקף
