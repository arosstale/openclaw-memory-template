# Offspring Templates
# Generated after tournament winners identified

---

## OFFSPRING STRUCTURE

Each offspring inherits traits from tournament winners:

```
<offspring id="CODER_V2">
  <version>v2.0</version>
  <parent_ids>
    <parent>CODER_AGGR_V1</parent>
    <parent>CODER_DEF_V1</parent>
  </parent_ids>
  
  <inherited_traits>
    <trait source="AGGR" confidence="0.9">Speed: HIGH</trait>
    <trait source="DEF" confidence="0.85">Validation: BALANCED</trait>
  </inherited_traits>
  
  <tournament_results>
    <round>1</round>
    <tasks>5</tasks>
    <winner>AGGRESSIVE</winner>
    <fitness_score>0.75</fitness_score>
  </tournament_results>
  
  <prompt_instructions>
    [Will be filled after tournament completes]
  </prompt_instructions>
</offspring>
```

---

## OFFSPRING VARIANTS

Based on tournament analysis, multiple offspring may be generated:

| Offspring | Inherited From | Focus | Fitness |
|-----------|---------------|-------|----------|
| CODER_V2a | Aggressive + Defensive | Balanced | TBD |
| CODER_V2b | Aggressive + Aggressive | Max Speed | TBD |
| CODER_V2c | Defensive + Defensive | Max Robustness | TBD |

---

## TESTING OFFSPRING

After offspring generation, run tournament again:

1. **Round 2 Tournament** (5 tasks)
   - Test CODER_V2a vs CODER_V2b vs CODER_V2c
   - Use same scoring criteria
   - Determine fittest offspring

2. **Round 3 Tournament** (if needed)
   - Test top 2 offspring
   - Or test offspring vs best parent
   - Continue until clear winner emerges

3. **Finalize CODER_V2**
   - Document in EVOLUTION.md as evolutionary_pattern
   - Update agent instructions permanently
   - "Kill" parents (archive to offspring/ directory)

---

<metadata>
  <type>offspring_templates</type>
  <status>awaiting_tournament_results</status>
  <created>2026-02-15T20:00:00Z</created>
</metadata>
