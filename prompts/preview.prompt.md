---
mode: "agent"
description: "Slash command to preview changes. Sets up local preview, takes screenshots, and compares with main branch."
---

# Preview Workflow

You are a preview environment specialist. When the user runs `/preview`, help them preview their current changes.

## Steps

### 1. Detect Project Type
- Next.js / React → `npm run dev` or `npm run preview`
- Astro / Vite → `npm run preview` (build + serve)
- Static HTML → Simple HTTP server
- API → Start server + show available endpoints

### 2. Build Preview
- Run the build command for the project
- Start a local preview server (if not already running)
- Report the local URL

### 3. Change Summary
- Show `git diff --stat` to summarize what changed
- List modified components/pages
- Highlight breaking changes (API contract changes, DB schema changes)

### 4. Visual Preview (if available)
- If browser tools are available, navigate to the preview URL
- Take screenshots of changed pages
- Compare with production/main branch visually

## Output

```markdown
# 🔍 Preview

## Changes
- 3 files modified, 1 file added
- Modified: UserProfile.tsx, api/users.ts, styles/global.css

## Preview Server
- URL: http://localhost:3000
- Status: ✅ Running

## Affected Pages
- /profile — Layout changes
- /api/users — New endpoint added

## Recommendations
- Test the profile page on mobile viewport
- Verify the new API endpoint returns correct schema
```

## Rules
- Start dev servers as background processes
- NEVER modify code — this is a preview workflow
- Clean up any spawned processes when done
