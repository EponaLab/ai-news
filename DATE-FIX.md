# Fix for Day-of-Week Error in Daily AI News Summaries

## Issue
The automated daily summary job incorrectly calculates the day of the week. 
Example: July 6, 2026 was labeled as "Sunday" when it was actually "Monday".

## Root Cause
The cron job task description doesn't specify how to calculate the day of the week correctly.
The isolated agent session is inferring the day name incorrectly.

## Solution

Update the daily job's task description in `/home/node/.openclaw/cron/jobs.json` to include explicit date calculation instructions.

### Find this section:
```
5. **File Creation:**
   - Create: /home/node/.openclaw/workspace/ai-news/daily/YYYY-MM-DD.md (use today's date)
   - Follow template format from new-daily.sh
   - Include metadata: date, week, day of year
   - Link to next day, this week, this year
```

### Replace with:
```
5. **File Creation:**
   - Create: /home/node/.openclaw/workspace/ai-news/daily/YYYY-MM-DD.md (use today's date)
   - Follow template format from new-daily.sh
   - **Date metadata (calculate correctly):**
     - Use these shell commands to get accurate dates:
       - Day of week: `date +"%A"` (e.g., "Monday")
       - Full date: `date +"%A, %B %d, %Y"` (e.g., "Monday, July 06, 2026")
       - Week number: `date +"%V"` (ISO week number)
       - Day of year: `date +"%j"`
     - **VERIFY:** Double-check the day of week matches the date!
     - Format: "Date: DayOfWeek, Month DD, YYYY"
   - Link to next day, this week, this year
```

## How to Apply

### Option 1: Manual Edit (Recommended)
```bash
# Open the cron jobs file in an editor
nano /home/node/.openclaw/cron/jobs.json

# Find the "ai-news-daily-summary" job
# Update the message content in step 5
# Save and exit

# Gateway will auto-reload the file
```

### Option 2: Automated Script (Advanced)
```bash
cd /home/node/.openclaw/workspace/ai-news
# Create a script to update jobs.json with proper escaping
# Be careful with JSON formatting
```

## Verification

After the fix, tomorrow's summary (2026-07-07) should show:
- **Correct:** "Date: Tuesday, July 07, 2026"
- **Not:** "Date: Sunday, July 07, 2026" or other wrong day

Check the file after it runs:
```bash
cat /home/node/.openclaw/workspace/ai-news/daily/2026-07-07.md | head -10
```

## Alternative: Post-Processing

If editing the cron job is difficult, you could add a post-processing step that fixes the date after generation, but it's better to fix it at the source.

---

**Status:** Known issue  
**Severity:** Low (cosmetic - doesn't affect content quality)  
**Impact:** Day-of-week labels incorrect in daily summaries  
**Fix required:** Update cron job task description  
**Workaround:** None needed (summaries still useful)
