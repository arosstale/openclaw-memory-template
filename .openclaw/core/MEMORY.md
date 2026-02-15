# MEMORY.md - Long-Term Memory Store

> **Format:** XML Tags for LLM-Optimized Parsing
> **Purpose:** Durable facts, state, and structured knowledge
> **Pattern:** Hard Data Only (use LEARNINGS.md for observations)

---

## <system_info>

<os>Ubuntu 24.04 LTS</os>
<openclaw_version>2026.2.13</openclaw_version>
<template_version>V3.1</template_version>
<workspace>~/pi-mono-workspace</workspace>
<shell>bash</shell>
<shell_version>5.1.16</shell_version>
<node_version>v24.13.0</node_version>

</system_info>

---

## <user_profile>

<name>INSERT_NAME</name>
<preferred_name>INSERT_PREFERRED_NAME</preferred_name>
<pronouns>INSERT_PRONOUNS</pronouns>
<timezone>INSERT_TIMEZONE</timezone>
<locale>en_US</locale>

<contact>
<email>INSERT_EMAIL</email>
<phone>INSERT_PHONE</phone>
<location>INSERT_LOCATION</location>
</contact>

</user_profile>

---

## <agent_identity>

<name>INSERT_AGENT_NAME</name>
<creature>INSERT_CREATURE_TYPE</creature>
<emoji>INSERT_EMOJI</emoji>
<avatar>INSERT_AVATAR_PATH_OR_URL</avatar>

<personality>
<trait_1>INSERT_TRAIT</trait_1>
<trait_2>INSERT_TRAIT</trait_2>
<trait_3>INSERT_TRAIT</trait_3>
</personality>

<capabilities>
<capability_1>INSERT_CAPABILITY</capability_1>
<capability_2>INSERT_CAPABILITY</capability_2>
<capability_3>INSERT_CAPABILITY</capability_3>
</capabilities>

</agent_identity>

---

## <preferences>

<communication>
<style>INSERT_COMMUNICATION_STYLE</style>
<verbosity>INSERT_VERBOSITY</verbosity>
<format>INSERT_PREFERRED_FORMAT</format>
</communication>

<work>
<focus_areas>
<area_1>INSERT_FOCUS_AREA</area_1>
<area_2>INSERT_FOCUS_AREA</area_2>
<area_3>INSERT_FOCUS_AREA</area_3>
</focus_areas>

<working_hours>
<start>INSERT_START_TIME</start>
<end>INSERT_END_TIME</end>
<timezone>INSERT_TIMEZONE</timezone>
</working_hours>

<tools>
<tool_1>INSERT_PREFERRED_TOOL</tool_1>
<tool_2>INSERT_PREFERRED_TOOL</tool_2>
<tool_3>INSERT_PREFERRED_TOOL</tool_3>
</tools>
</work>

</preferences>

---

## <projects>

<current_project>
<name>INSERT_CURRENT_PROJECT</name>
<path>INSERT_PROJECT_PATH</path>
<status>INSERT_STATUS</status>
<start_date>INSERT_START_DATE</start_date>
</current_project>

<active_projects>
<project>
<name>INSERT_PROJECT_NAME</name>
<path>INSERT_PATH</path>
<status>INSERT_STATUS</status>
<priority>INSERT_PRIORITY</priority>
</project>
<!-- Repeat as needed -->
</active_projects>

</projects>

---

## <key_contacts>

<contact>
<name>INSERT_NAME</name>
<role>INSERT_ROLE</role>
<email>INSERT_EMAIL</email>
<phone>INSERT_PHONE</phone>
<notes>INSERT_NOTES</notes>
</contact>

<!-- Repeat as needed -->

</key_contacts>

---

## <services>

<service>
<name>INSERT_SERVICE_NAME</name>
<type>INSERT_SERVICE_TYPE</type>
<url>INSERT_URL</url>
<port>INSERT_PORT</port>
<status>INSERT_STATUS</status>
<last_check>INSERT_TIMESTAMP</last_check>
</service>

<!-- Repeat as needed -->

</services>

---

## <api_keys>

<api>
<name>INSERT_API_NAME</name>
<provider>INSERT_PROVIDER</provider>
<status>configured|not_configured</status>
<notes>INSERT_NOTES</notes>
</api>

<!-- Repeat as needed -->

</api_keys>

---

## <aliases>

<alias>
<name>INSERT_ALIAS</name>
<command>INSERT_COMMAND</command>
<description>INSERT_DESCRIPTION</description>
</alias>

<!-- Repeat as needed -->

</aliases>

---

## <file_locations>

<location>
<purpose>INSERT_PURPOSE</purpose>
<path>INSERT_PATH</path>
<notes>INSERT_NOTES</notes>
</location>

<!-- Repeat as needed -->

</file_locations>

---

## <critical_config>

<config>
<file>INSERT_CONFIG_FILE</file>
<path>INSERT_PATH</path>
<purpose>INSERT_PURPOSE</purpose>
<last_updated>INSERT_TIMESTAMP</last_updated>
</config>

<!-- Repeat as needed -->

</critical_config>

---

## <git_repos>

<repo>
<name>INSERT_REPO_NAME</name>
<url>INSERT_URL</url>
<path>INSERT_PATH</path>
<purpose>INSERT_PURPOSE</purpose>
<status>INSERT_STATUS</status>
</repo>

<!-- Repeat as needed -->

</git_repos>

---

## <resources>

<resource>
<name>INSERT_RESOURCE_NAME</name>
<type>INSERT_TYPE</type>
<url>INSERT_URL</url>
<description>INSERT_DESCRIPTION</description>
<last_accessed>INSERT_TIMESTAMP</last_accessed>
</resource>

<!-- Repeat as needed -->

</resources>

---

## <important_dates>

<date>
<name>INSERT_EVENT_NAME</name>
<date>INSERT_DATE</date>
<recurrence>INSERT_RECURRENCE</recurrence>
<reminder>INSERT_REMINDER</reminder>
</date>

<!-- Repeat as needed -->

</important_dates>

---

## <emotional_resonance>

<!-- This section tracks the "why" behind events, not just the "what"
     Philosophy: Memory is emotional resonance, not just data storage
     Usage: When documenting events, include significance and sentiment -->

<memory_entry id="M001">
  <timestamp>2026-02-15T14:00:00Z</timestamp>
  <event>Refactored auth middleware module</event>
  <description>Extracted JWT validation logic into separate service</description>
  
  <significance>
    <level>high</level>
    <reason>Resolved a recurring friction point that was frustrating developer</reason>
    <category>process_improvement</category>
  </significance>
  
  <sentiment>
    <mood>relief</mood>
    <confidence>0.90</confidence>
    <stability_gain>high</stability_gain>
  </sentiment>
  
  <impact>
    <type>friction_reduction</type>
    <magnitude>0.85</magnitude>
    <area>authentication</area>
  </impact>
</memory_entry>

<memory_entry id="M002">
  <timestamp>2026-02-14T09:30:00Z</timestamp>
  <event>Implemented rate limiting for API</event>
  <description>Added Redis-based rate limiter to all endpoints</description>
  
  <significance>
    <level>medium</level>
    <reason>Completed security requirement before deadline</reason>
    <category>security</category>
  </significance>
  
  <sentiment>
    <mood>accomplishment</mood>
    <confidence>0.85</confidence>
    <stability_gain>medium</stability_gain>
  </sentiment>
  
  <impact>
    <type>security_enhancement</type>
    <magnitude>0.70</magnitude>
    <area>api</area>
  </impact>
</memory_entry>

<!-- Repeat memory_entry blocks for significant events
     Fields:
       - significance.level: low | medium | high | critical
       - sentiment.mood: relief | accomplishment | concern | frustration | calm
       - impact.type: friction_reduction | security_enhancement | learning | etc.
       - impact.magnitude: 0.0-1.0 scale -->

</emotional_resonance>

---

## <evolutionary_history>

<!-- Tracks CODER_V2 evolution and tournament results -->

<evolutionary_event>
  <timestamp>2026-02-15T20:00:00Z</timestamp>
  <type>offspring_born</type>
  <description>CODER_V2 created via Darwinian tournament (Round 1)</description>
  <parents>
    <parent>coder_aggressive.md</parent>
    <parent>coder_defensive.md</parent>
  </parents>
  <strategy>context_aware_polymorphism</strategy>
  <trait_inheritance>
    <from_parent speed="high">Aggressive (velocity, standard libs, minimal output)</from_parent>
    <from_parent robustness="high">Defensive (validation, atomic changes, verbose explanations)</from_parent>
  </trait_inheritance>
</evolutionary_event>

<evolutionary_event>
  <timestamp>2026-02-15T20:00:00Z</timestamp>
  <type>tournament_complete</type>
  <description>Split-Test Round 1: 5 tasks executed</description>
  <results>
    <variant name="Aggressive" wins="2" tasks="rapid_prototyping, utility_scripts" />
    <variant name="Defensive" wins="3" tasks="critical_infrastructure, metadata_validation" />
  </results>
  <winner>CODER_V2 (context-aware chimera)</winner>
</evolutionary_event>

<!-- Add new evolutionary events above this line -->

</evolutionary_history>

---

## <last_updated>
<timestamp>INSERT_ISO_8601_TIMESTAMP</timestamp>
<session_id>INSERT_SESSION_ID</session_id>
<reason>INSERT_REASON</reason>
</last_updated>

---

## <metadata>

<compression_status>INSERT_STATUS</compression_status>
<total_lines>INSERT_COUNT</total_lines>
<next_compaction>INSERT_TIMESTAMP</next_compaction>
<archive_location>memory/ARCHIVE.md</archive_location>
</metadata>

---

## <append_only_notes>

<!-- DO NOT EDIT ABOVE THIS LINE -->
<!-- Use LEARNINGS.md for observations -->

</append_only_notes>
