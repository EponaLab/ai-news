#!/bin/bash
# Weekly summary template generator
# Usage: ./new-weekly.sh [YYYY-WXX]
# If no week provided, uses current week

set -e

# Use provided week or default to current
if [ -z "$1" ]; then
    YEAR=$(date +%Y)
    WEEK=$(date +%V)
else
    # Parse YYYY-WXX format
    YEAR=$(echo $1 | cut -d'-' -f1)
    WEEK=$(echo $1 | cut -d'-' -f2 | sed 's/W//')
fi

WEEK_ID="${YEAR}-W${WEEK}"
FILENAME="weekly/${WEEK_ID}.md"

# Calculate week dates (Monday to Sunday)
# Get the Monday of this week
WEEK_START=$(date -d "${YEAR}-01-01 +$(($(date -d "${YEAR}-01-01" +%u)-1)) days +$((${WEEK}-1)) weeks -$(($(date -d "${YEAR}-01-01" +%u)-1)) days" +%B\ %d)
WEEK_END=$(date -d "${YEAR}-01-01 +$(($(date -d "${YEAR}-01-01" +%u)-1)) days +$((${WEEK}-1)) weeks +6 days -$(($(date -d "${YEAR}-01-01" +%u)-1)) days" +%B\ %d)

# Check if file already exists
if [ -f "$FILENAME" ]; then
    echo "❌ File already exists: $FILENAME"
    echo "   Edit it directly or use 'git rm $FILENAME' to delete it first."
    exit 1
fi

# Create the weekly template
cat > "$FILENAME" << EOF
# Week ${WEEK}, ${YEAR} (${WEEK_START}-${WEEK_END})

**Week of:** ${WEEK_START}-${WEEK_END}, ${YEAR}  
**Status:** In progress  
**Last Updated:** $(date +%Y-%m-%d) ($(date +%A))

## 📰 Week Overview

*(High-level summary of the week's main themes and developments)*

---

## 🔥 Key Developments

### [Main Topic or Trend]

*(Description of major development, trend, or announcement)*

**Impact:** *(What this means for the industry)*

### [Second Topic]

*(Description)*

### [Third Topic]

*(Description)*

---

## 📚 Research Highlights

### Notable Papers This Week

**[Category]:**
- **[Paper Title]**: Brief description and significance
- **[Paper Title]**: Brief description and significance

### Conference Activity

*(Notable conference papers, workshops, or presentations)*

---

## 🛠️ Tools & Framework Updates

### [Tool or Framework Name]

*(What was released, updated, or announced)*

**Why it matters:** *(Significance for developers/enterprises)*

---

## 💼 Enterprise Adoption Patterns

### [Industry Sector]

*(Notable deployments, case studies, or adoption trends)*

**ROI/Performance Data:** *(If available)*

---

## 📊 Key Statistics This Week

- **[Metric]**: [Value] ([Source])
- **[Metric]**: [Value] ([Source])
- **[Metric]**: [Value] ([Source])

---

## 🎯 What to Watch

### Next Week
- *(Expected announcements, releases, or events)*

### Rest of Quarter
- *(Longer-term trends to monitor)*

---

## 📖 Recommended Reading

### This Week's Must-Reads
1. **[Title](URL)** - Brief description
2. **[Title](URL)** - Brief description
3. **[Title](URL)** - Brief description

### Industry Reports
- **[Report Name](URL)** - Brief description

---

## 🗓️ Daily Summaries

- **Monday (${WEEK_START})**: [See daily/${YEAR}-MM-DD.md](../daily/${YEAR}-MM-DD.md) - *(Brief note)*
- **Tuesday**: *(Brief note)*
- **Wednesday**: *(Brief note)*
- **Thursday**: *(Brief note)*
- **Friday**: *(Brief note)*

---

## 📝 Notes

*(Meta-commentary, observations, or context about the week)*

---

**Next:** Week $((${WEEK}+1)) Summary  
**Previous:** Week $((${WEEK}-1)) Summary  
**This Year:** [${YEAR} Annual Overview](../yearly/${YEAR}.md)
EOF

echo "✅ Created weekly template: $FILENAME"
echo ""
echo "Next steps:"
echo "  1. Edit the file: ${FILENAME}"
echo "  2. Fill in the week's content as it develops"
echo "  3. Update throughout the week"
echo "  4. Finalize on Sunday"
echo "  5. Commit: git add ${FILENAME} && git commit -m 'Weekly summary: Week ${WEEK}, ${YEAR}'"
echo "  6. Push: git push"
