#!/bin/bash
# Daily news template generator
# Usage: ./new-daily.sh [YYYY-MM-DD]
# If no date provided, uses today

set -e

# Use provided date or default to today
if [ -z "$1" ]; then
    DATE=$(date +%Y-%m-%d)
    DAY_NAME=$(date +%A)
    MONTH_NAME=$(date +%B)
    DAY=$(date +%d)
    YEAR=$(date +%Y)
    WEEK=$(date +%V)
    DAY_OF_YEAR=$(date +%j)
    DAYS_IN_YEAR=366  # 2026 is not a leap year, but template uses 366
else
    DATE=$1
    DAY_NAME=$(date -d "$DATE" +%A)
    MONTH_NAME=$(date -d "$DATE" +%B)
    DAY=$(date -d "$DATE" +%d)
    YEAR=$(date -d "$DATE" +%Y)
    WEEK=$(date -d "$DATE" +%V)
    DAY_OF_YEAR=$(date -d "$DATE" +%j)
    DAYS_IN_YEAR=366
fi

FILENAME="daily/${DATE}.md"

# Check if file already exists
if [ -f "$FILENAME" ]; then
    echo "❌ File already exists: $FILENAME"
    echo "   Use 'git rm $FILENAME' to delete it first, or edit it directly."
    exit 1
fi

# Calculate next day
NEXT_DATE=$(date -d "$DATE + 1 day" +%Y-%m-%d)

# Create the daily template
cat > "$FILENAME" << EOF
# Daily Summary: ${MONTH_NAME} ${DAY}, ${YEAR} (${DAY_NAME})

**Date:** ${DAY_NAME}, ${MONTH_NAME} ${DAY}, ${YEAR}  
**Week:** ${WEEK} of ${YEAR}  
**Day:** ${DAY_OF_YEAR} of ${DAYS_IN_YEAR}

---

## 🎯 Today's Focus

*(Brief overview of the day's main theme or focus area)*

---

## 🔥 Key Highlights

### 1. **[Main Headline]**

*(Description and details)*

**Sources:**
- [Source Name](URL)

### 2. **[Second Headline]**

*(Description and details)*

### 3. **[Third Headline]**

*(Description and details)*

---

## 📚 Research Papers

### New Papers Released Today

**[Paper Category]:**
- **[Paper Title]**: Brief description
- **[Paper Title]**: Brief description

---

## 🛠️ Tools & Frameworks

### Updates and Releases

- **[Tool Name]**: What changed or was announced

---

## 💼 Industry News

### Enterprise Adoption

*(Notable enterprise deployments, case studies, or adoption announcements)*

### Market Developments

*(Funding, acquisitions, partnerships, market analysis)*

---

## 📊 Key Statistics

- **[Metric]**: [Value] ([Source])
- **[Metric]**: [Value] ([Source])

---

## 💡 Insights & Analysis

### [Topic or Theme]

*(Your analysis or commentary on the day's developments)*

---

## 🔗 Important Links

### Today's Must-Reads
1. **[Title](URL)** - Brief description
2. **[Title](URL)** - Brief description

### Reports & Analysis
- [Report Name](URL)

---

## 📝 Tomorrow's Watch List

- Item to watch for tomorrow
- Expected announcement or release
- Ongoing development to monitor

---

## 🗒️ Notes

*(Any additional context, observations, or meta-commentary)*

---

**Next:** [Daily Summary for ${NEXT_DATE}](./${NEXT_DATE}.md)  
**This Week:** [Week ${WEEK} Summary](../weekly/${YEAR}-W${WEEK}.md)  
**This Year:** [${YEAR} Annual Overview](../yearly/${YEAR}.md)
EOF

echo "✅ Created daily template: $FILENAME"
echo ""
echo "Next steps:"
echo "  1. Edit the file: ${FILENAME}"
echo "  2. Fill in the day's content"
echo "  3. Commit: git add ${FILENAME} && git commit -m 'Daily update: ${DATE}'"
echo "  4. Push: git push"
