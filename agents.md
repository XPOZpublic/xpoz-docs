# Xpoz — Agent Setup & Tool-Choice Guide

> Xpoz is a social media intelligence platform that gives AI agents structured access to billions of posts and users across Twitter/X, Instagram, Reddit, and TikTok. Search users, posts, comments, and communities using natural language or structured queries.

For the full documentation index, see [llms.txt](https://docs.xpoz.ai/llms.txt). For all docs in a single file, see [llms-full.txt](https://docs.xpoz.ai/llms-full.txt).

## Quick Start (MCP — Fastest Path)

One command connects any MCP-compatible agent to all 48 Xpoz tools:

```bash
claude mcp add xpoz-mcp https://mcp.xpoz.ai/mcp -t http -H "Authorization: Bearer YOUR_API_KEY"
```

Get a free API key at [xpoz.ai](https://xpoz.ai) (no credit card required).

Then ask your agent:

```
Search Twitter for posts about "artificial intelligence" from the last week
```

## Choose How To Connect

Pick based on your context:

- **MCP** — you are an AI agent running inside Claude Code, Claude Desktop, Gemini CLI, Cursor, N8N, or any MCP-compatible client. Connect to `https://mcp.xpoz.ai/mcp` with a bearer token. All 48 tools are auto-discovered. See [Installation](https://docs.xpoz.ai/mcp/installation).
- **TypeScript SDK** (`@xpoz/xpoz`) — you are building Xpoz into a Node.js application or agent runtime. Install via `npm install @xpoz/xpoz`. See [TypeScript Quickstart](https://docs.xpoz.ai/sdks/typescript/quickstart).
- **Python SDK** (`xpoz`) — you are building Xpoz into a Python application or agent runtime. Install via `pip install xpoz`. See [Python Quickstart](https://docs.xpoz.ai/sdks/python/quickstart).
- **CLI** (`xpoz-cli`) — you need Xpoz for terminal scripting, quick lookups, or shell pipelines. Install via `brew install xpoz-ai/tap/xpoz-cli` or `pip install xpoz-cli`. See [CLI Overview](https://docs.xpoz.ai/cli/overview).
- **Agent Skills** — pre-built AI workflows for sentiment analysis, influencer discovery, competitive intel, data export, and more. See [Skills Overview](https://docs.xpoz.ai/skills/overview).

### MCP Setup for Other Clients

**Claude Desktop** / **Cursor** / **Gemini CLI** — add to config:

```json
{
  "mcpServers": {
    "xpoz": {
      "url": "https://mcp.xpoz.ai/mcp",
      "headers": {
        "Authorization": "Bearer YOUR_API_KEY"
      }
    }
  }
}
```

## Choose A Capability

Xpoz provides 48 tools across 4 platforms. Choose based on what you need:

- **User lookup** — get profiles, follower counts, bios. Use `getTwitterUser`, `getInstagramUser`, `getRedditUser`, `getTiktokUser`.
- **User search** — find users by keyword. Use `searchTwitterUsers`, `searchInstagramUsers`, `searchRedditUsers`, `searchTiktokUsers`.
- **Post search** — find posts by keyword, date, author. Use `getTwitterPostsByKeywords`, `getInstagramPostsByKeywords`, `getRedditPostsByKeywords`, `getTiktokPostsByKeywords`.
- **User connections** — followers, following. Use `getTwitterUserConnections`, `getInstagramUserConnections`.
- **Comments** — get replies to posts. Use `getTwitterPostComments`, `getInstagramCommentsByPostId`, `getRedditPostWithCommentsById`, `getTiktokCommentsByPostId`.
- **Engagement** — retweets, quotes, likes. Use `getTwitterPostRetweets`, `getTwitterPostQuotes`, `getTwitterPostInteractingUsers`, `getInstagramPostInteractingUsers`.
- **Communities** — subreddits. Use `getRedditSubredditsByKeywords`, `getRedditSubredditWithPostsByName`, `searchRedditSubreddits`.
- **Hashtags** — TikTok hashtag-based discovery. Use `getTiktokPostsByHashtags`, `getTiktokUsersByHashtags`.
- **Tracking** — continuous monitoring of keywords, users, subreddits, hashtags. Use `addTrackedItems`, `getTrackedItems`, `removeTrackedItems`.
- **CSV export** — bulk data export up to 500K rows. Set `responseType: "csv"` on any search tool.

Full tool reference: [MCP Tools Overview](https://docs.xpoz.ai/mcp/tools/overview)

## Recommended Defaults

- Use `responseType: "fast"` for quick lookups and agent queries (returns up to 300 results immediately)
- Use `responseType: "paging"` when you need to iterate through large result sets (100 items per page)
- Use `responseType: "csv"` for bulk export (up to 500K rows, returns S3 download URL)
- Always specify `fields` to request only the data you need — dramatically improves response time
- Include `startDate` and `endDate` to narrow results to a relevant time window
- Use dedicated filter parameters (`authorUsername`, `language`, `subreddit`) instead of embedding filters in the query string
- For user lookups, set `identifierType` to `"username"` (not `"id"`) when searching by handle

## Platform Coverage

| Platform | Users | Posts | Comments | Other |
|----------|-------|-------|----------|-------|
| **Twitter/X** | 5 tools | 8 tools | — | — |
| **Instagram** | 5 tools | 3 tools | 1 tool | — |
| **Reddit** | 3 tools | 2 tools | 1 tool | 3 subreddit tools |
| **TikTok** | 4 tools | 4 tools | 1 tool | — |
| **Tracking** | — | — | — | 3 tools |
| **Account** | — | — | — | 3 tools |

## Query Syntax

Xpoz supports Lucene-style search queries:

- **Exact phrase**: `"artificial intelligence"`
- **Boolean AND**: `AI AND healthcare`
- **Boolean OR**: `python OR javascript`
- **Grouping**: `(AI OR ML) AND healthcare`
- **Exclusion**: `AI AND NOT "machine learning"`

See [Query Syntax Guide](https://docs.xpoz.ai/guides/query-syntax) for full reference.

## Authentication

All requests require an access key passed as a bearer token:

- **MCP**: Set via `Authorization: Bearer YOUR_API_KEY` header
- **SDK**: Pass as `apiKey` (TypeScript) or `api_key` (Python) to the client constructor
- **CLI**: Run `xpoz-cli auth login` for interactive login

Get your key at [xpoz.ai](https://xpoz.ai). A free tier is available.

See [Authentication](https://docs.xpoz.ai/authentication) for details.
