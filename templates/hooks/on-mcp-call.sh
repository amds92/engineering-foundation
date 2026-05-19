#!/bin/bash
# .claude/hooks/on-mcp-call.sh
#
# Fires every time Claude Code triggers an MCP tool.
# Use this to log, audit, or gate MCP calls.
#
# Environment variables available:
#   $MCP_TOOL_NAME   — name of the tool being called
#   $MCP_SERVER_NAME — name of the MCP server

set -e

# ── Example: log all MCP calls to a local file ───────────────────────────────
LOG_FILE=".claude/mcp-calls.log"
echo "[$(date -u +"%Y-%m-%dT%H:%M:%SZ")] $MCP_SERVER_NAME → $MCP_TOOL_NAME" >> "$LOG_FILE"

# ── Example: block specific tools ────────────────────────────────────────────
# Uncomment to prevent Claude from calling destructive tools without confirmation.
#
# if [ "$MCP_TOOL_NAME" = "delete_record" ]; then
#   echo "❌ Blocked: $MCP_TOOL_NAME requires manual confirmation."
#   exit 1
# fi

exit 0
