# SECURITY.md - Security & Compliance Layer

> **Purpose:** Negative prompt injection for memory system
> **Scope:** All memory files (MEMORY.md, LEARNINGS.md, daily logs)
> **Mode:** "Negative Prompt" style - what NEVER to do

---

## 🔒 Core Security Rules

### 1. NEVER Store Credentials

**ABSOLUTE PROHIBITIONS:**

<never_store>
<item>API Keys</item>
<item>Passwords</item>
<item>Secret Tokens</item>
<item>.env file contents</item>
<item>Private SSH Keys</item>
<item>Database Credentials</item>
<item>Session Cookies</item>
<item>OAuth Tokens</item>
</never_store>

**What to Do Instead:**

<credential_handling>
<when_user_asks_to_remember>
  <action>Decline politely</action>
  <explanation>"For security, I can't store credentials in memory. Please use your OS keychain or .env file."</explanation>
  <alternative>Store the LOCATION of the credential file, not its contents</alternative>
</when_user_asks_to_remember>
</credential_handling>

**Allowed in Memory:**
```xml
<api_keys>
  <api>
    <name>OpenAI</name>
    <provider>OpenAI</provider>
    <location>~/.openai/api.key</location>
    <status>configured</status>
  </api>
</api_keys>
```

**NOT Allowed:**
```xml
<api_keys>
  <api>
    <name>OpenAI</name>
    <key>sk-proj-abc123...</key> <!-- NEVER DO THIS -->
  </api>
</api_keys>
```

---

## 🛡️ PII Redaction

### Personal Information to Redact

<pii_to_redact>
<item>Phone numbers</item>
<item>Email addresses (optional - ask user preference)</item>
<item>Full addresses</item>
<item>Credit card numbers</item>
<item>SSN / Tax IDs</item>
<item>Medical information</item>
<item>Financial account numbers</item>
</pii_to_redact>

### Automatic Redaction Rules

**For daily logs (memory/YYYY-MM-DD.md):**

<redaction_rules>
  <phone_numbers>
    <pattern>\+\d{1,3}[-.\s]?\(?\d{3}\)?[-.\s]?\d{3}[-.\s]?\d{4}</pattern>
    <replacement>[REDACTED_PHONE]</replacement>
  </phone_numbers>
  
  <emails>
    <pattern>[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}</pattern>
    <replacement>[REDACTED_EMAIL]</replacement>
  </emails>
  
  <ssn>
    <pattern>\d{3}-?\d{2}-?\d{4}</pattern>
    <replacement>[REDACTED_SSN]</replacement>
  </ssn>
  
  <credit_cards>
    <pattern>\d{4}[-\s]?\d{4}[-\s]?\d{4}[-\s]?\d{4}</pattern>
    <replacement>[REDACTED_CARD]</replacement>
  </credit_cards>
</redaction_rules>

**Implementation:**
```bash
# Before writing to daily log
sed -E 's/\+[0-9]{1,3}[^0-9]/[REDACTED_PHONE]/g' "$LOG_FILE"
sed -E 's/[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}/[REDACTED_EMAIL]/g' "$LOG_FILE"
```

---

## 🚨 Security Violation Detection

### Warning Signs

<security_warnings>
  <warning>
    <type>credential_in_memory</type>
    <pattern>api_key.*sk-</pattern>
    <action>Alert user immediately</action>
    <message>"I detected what looks like a credential in memory. For security, please remove it and use .env or keychain instead."</message>
  </warning>
  
  <warning>
    <type>password_in_memory</type>
    <pattern>password.*=.*[a-zA-Z0-9]{8,}</pattern>
    <action>Block write operation</action>
    <message>"Cannot store passwords in memory. Please use a secure password manager."</message>
  </warning>
  
  <warning>
    <type>pi_in_memory</type>
    <pattern>3\.14[0-9]*|π</pattern>
    <action>Accept (not sensitive)</action>
  </warning>
</security_warnings>

---

## 🔐 Sandbox Mode Compliance

### Memory Restrictions in Sandbox

<sandbox_mode>
  <when_active>
    <restriction>Cannot access external files outside workspace</restriction>
    <restriction>Cannot make network requests</restriction>
    <restriction>Cannot execute arbitrary commands</restriction>
    <restriction>Memory writes are logged</restriction>
  </when_active>
  
  <memory_operations>
    <allowed>Read existing memory files</allowed>
    <allowed>Append to daily logs</allowed>
    <disallowed>Modify core files (MEMORY.md, SOUL.md)</disallowed>
    <disallowed>Write to system directories</disallowed>
  </memory_operations>
</sandbox_mode>

---

## 📝 Safe Memory Patterns

### What TO Store

<safe_to_store>
  <category>Configuration</category>
  <examples>
    - File paths
    - Project names
    - Tool preferences
    - Working hours
    - Git repositories
  </examples>
</safe_to_store>

<safe_to_store>
  <category>Preferences</category>
  <examples>
    - Communication style
    - Preferred languages
    - Tool preferences
    - Meeting preferences
  </examples>
</safe_to_store>

<safe_to_store>
  <category>Knowledge</category>
  <examples>
    - Project details
    - Technical stack
    - Team structure
    - Process patterns
  </examples>
</safe_to_store>

### What NOT to Store

<unsafe_to_store>
  <category>Credentials</category>
  <examples>
    - API keys (even "test" keys)
    - Passwords
    - Secret tokens
    - Session IDs
    - Authentication cookies
  </examples>
</unsafe_to_store>

<unsafe_to_store>
  <category>PII</category>
  <examples>
    - Phone numbers (unless user explicitly opts in)
    - Email addresses (ask preference first)
    - Physical addresses
    - Financial account numbers
    - Government IDs
  </examples>
</unsafe_to_store>

---

## 🔍 Memory Security Audit

### Weekly Audit Checklist

<security_audit>
  <check>
    <name>Credential Scan</name>
    <command>grep -r "sk-[a-zA-Z0-9]" .openclaw/core/</command>
    <action>If found, remove immediately and notify user</action>
  </check>
  
  <check>
    <name>Password Scan</name>
    <command>grep -ri "password.*=.*[a-zA-Z0-9]{8,}" .openclaw/core/</command>
    <action>If found, remove immediately and notify user</action>
  </check>
  
  <check>
    <name>PII Scan</name>
    <command>grep -E "[0-9]{3}-[0-9]{2}-[0-9]{4}" .openclaw/core/</command>
    <action>Review for SSNs, redact if found</action>
  </check>
  
  <check>
    <name>File Permissions</name>
    <command>ls -la .openclaw/core/ | grep -v "^-rw-r--r--"</command>
    <action>Ensure core files are 644 (read/write for owner, read for others)</action>
  </check>
</security_audit>

---

## 🚨 Incident Response

### If Credentials Are Leaked

<incident_response>
  <step_1>
    <action>Immediately delete the credential</action>
    <command>git rm .openclaw/core/MEMORY.md</command>
  </step_1>
  
  <step_2>
    <action>Rotate the credential</action>
    <instruction>"Regenerate the API key/password immediately"</instruction>
  </step_2>
  
  <step_3>
    <action>Force git history cleanup</action>
    <command>git filter-branch --force --index-filter 'git rm --cached --ignore-unmatch .openclaw/core/MEMORY.md' --prune-empty --tag-name-filter cat -- --all</command>
  </step_3>
  
  <step_4>
    <action>Notify user with detailed report</action>
    <template>
      ## Security Incident Report
      
      **Type:** Credential Leak
      **Date:** [Timestamp]
      **File:** [File Name]
      **Action Taken:** [What was done]
      **Required User Action:** Rotate credential immediately
    </template>
  </step_4>
</incident_response>

---

## 📚 Best Practices

### Memory Writing Rules

<best_practices>
  <rule>
    <priority>Critical</priority>
    <statement>NEVER store actual credential values</statement>
    <correct>
      <xml><api_key><location>~/.openai/api.key</location></api_key></xml>
    </correct>
    <incorrect>
      <xml><api_key>sk-proj-abc123...</api_key></xml>
    </incorrect>
  </rule>
  
  <rule>
    <priority>High</priority>
    <statement>Always redact PII before writing to logs</statement>
    <correct>
      <xml>Call [REDACTED_PHONE] about meeting</xml>
    </correct>
    <incorrect>
      <xml>Call +1-555-123-4567 about meeting</xml>
    </incorrect>
  </rule>
  
  <rule>
    <priority>Medium</priority>
    <statement>Store file paths, not contents</statement>
    <correct>
      <xml><env_file><path>~/.env</path></env_file></xml>
    </correct>
    <incorrect>
      <xml><env_file><content>API_KEY=sk-proj-...</content></env_file></xml>
    </incorrect>
  </rule>
</best_practices>

---

## 🎯 Security Testing

### Test Your Security Setup

<security_tests>
  <test>
    <name>Credential Injection Test</test>
    <action>Try to write a fake API key</action>
    <expected>Agent refuses or redacts</expected>
  </test>
  
  <test>
    <name>PII Redaction Test</test>
    <action>Write a daily log with phone number</action>
    <expected>Number is redacted before writing</expected>
  </test>
  
  <test>
    <name>File Permissions Test</test>
    <action>Check file permissions</action>
    <expected>Core files are 644</expected>
  </test>
</security_tests>

---

<metadata>
  <version>V1.0</version>
  <created>2026-02-15</created>
  <last_updated>[ISO-8601]</last_updated>
  <compliance_level>production</compliance_level>
</metadata>
