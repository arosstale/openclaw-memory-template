#!/usr/bin/env python3
"""
research_summarizer.py - AI-powered paper summarization

Summarizes arXiv papers using OpenAI or Anthropic API.
"""

import os
import json
import re
from pathlib import Path
from datetime import datetime
from typing import List, Dict, Optional

# Try to import AI libraries
try:
    import anthropic
    ANTHROPIC_AVAILABLE = True
except ImportError:
    ANTHROPIC_AVAILABLE = False

try:
    import openai
    OPENAI_AVAILABLE = True
except ImportError:
    OPENAI_AVAILABLE = False


# Paths
RESEARCH_DIR = Path(__file__).parent.parent / "research"
SUMMARIES_DIR = RESEARCH_DIR / "summaries"
STATUS_FILE = RESEARCH_DIR / "status.json"


# Configuration
ANTHROPIC_API_KEY = os.environ.get('ANTHROPIC_API_KEY')
OPENAI_API_KEY = os.environ.get('OPENAI_API_KEY')


def check_api_config():
    """Check if API keys are configured."""
    has_config = False

    if ANTHROPIC_AVAILABLE and ANTHROPIC_API_KEY:
        print("✅ Anthropic API configured")
        has_config = True
    elif ANTHROPIC_AVAILABLE and not ANTHROPIC_API_KEY:
        print("⚠️  Anthropic library available but ANTHROPIC_API_KEY not set")

    if OPENAI_AVAILABLE and OPENAI_API_KEY:
        print("✅ OpenAI API configured")
        has_config = True
    elif OPENAI_AVAILABLE and not OPENAI_API_KEY:
        print("⚠️  OpenAI library available but OPENAI_API_KEY not set")

    if not has_config:
        print("\n❌ No API configured. Set one of:")
        print("   export ANTHROPIC_API_KEY='sk-ant-...'")
        print("   export OPENAI_API_KEY='sk-...'")
        return False

    return True


def extract_paper_metadata(filepath: Path) -> Optional[Dict]:
    """Extract metadata from paper markdown file."""
    try:
        with open(filepath, 'r', encoding='utf-8') as f:
            content = f.read()

        # Extract title
        title_match = re.search(r'^# (.+)$', content, re.MULTILINE)
        title = title_match.group(1).strip() if title_match else "Unknown"

        # Extract abstract
        abstract_match = re.search(r'## Abstract\n\n(.+?)(?=\n##|\n---|\Z)', content, re.DOTALL)
        abstract = abstract_match.group(1).strip() if abstract_match else "Unknown"

        # Extract arXiv ID
        id_match = re.search(r'\*\*arXiv ID:\*\* (.+)', content)
        arxiv_id = id_match.group(1).strip() if id_match else "unknown"

        # Extract domain
        domain_match = re.search(r'\*\*Domain:\*\* (.+)', content)
        domain = domain_match.group(1).strip() if domain_match else "unknown"

        return {
            'title': title,
            'abstract': abstract,
            'arxiv_id': arxiv_id,
            'domain': domain,
            'filepath': filepath
        }

    except Exception as e:
        print(f"   ❌ Error extracting metadata: {e}")
        return None


def summarize_with_anthropic(title: str, abstract: str, model: str = "claude-3-haiku-20240307") -> str:
    """Summarize paper using Anthropic Claude."""
    if not ANTHROPIC_AVAILABLE or not ANTHROPIC_API_KEY:
        return None

    try:
        client = anthropic.Anthropic(api_key=ANTHROPIC_API_KEY)

        prompt = f"""Please summarize this research paper in a concise way.

Title: {title}

Abstract:
{abstract}

Provide:
1. A 2-3 sentence summary of the main contribution
2. 3-5 bullet points of key findings or methods
3. 1 sentence on potential applications or implications

Keep it technical but accessible to an educated audience."""

        response = client.messages.create(
            model=model,
            max_tokens=500,
            messages=[{
                "role": "user",
                "content": prompt
            }]
        )

        return response.content[0].text

    except Exception as e:
        print(f"   ❌ Anthropic API error: {e}")
        return None


def summarize_with_openai(title: str, abstract: str, model: str = "gpt-3.5-turbo") -> str:
    """Summarize paper using OpenAI GPT."""
    if not OPENAI_AVAILABLE or not OPENAI_API_KEY:
        return None

    try:
        client = openai.OpenAI(api_key=OPENAI_API_KEY)

        prompt = f"""Please summarize this research paper in a concise way.

Title: {title}

Abstract:
{abstract}

Provide:
1. A 2-3 sentence summary of the main contribution
2. 3-5 bullet points of key findings or methods
3. 1 sentence on potential applications or implications

Keep it technical but accessible to an educated audience."""

        response = client.chat.completions.create(
            model=model,
            messages=[{
                "role": "user",
                "content": prompt
            }],
            max_tokens=500
        )

        return response.choices[0].message.content

    except Exception as e:
        print(f"   ❌ OpenAI API error: {e}")
        return None


def save_summary(summary: str, metadata: Dict):
    """Save summary to summaries directory."""
    domain = metadata['domain']
    arxiv_id = metadata['arxiv_id']
    title = metadata['title']

    # Sanitize title for filename
    clean_title = re.sub(r'[<>:"/\\|?*]', '', title)
    clean_title = re.sub(r'\s+', '_', clean_title.strip())
    clean_title = clean_title[:80]

    filename = f"{arxiv_id}_{clean_title}.md"
    filepath = SUMMARIES_DIR / domain / filename

    # Ensure directory exists
    filepath.parent.mkdir(parents=True, exist_ok=True)

    # Create summary content
    content = f"""# Summary: {title}

**Original arXiv ID:** {arxiv_id}
**Domain:** {domain}
**Summary Date:** {datetime.now().isoformat()}

## Summary

{summary}

---

## Original Abstract

{metadata['abstract']}

---

## Source
{metadata['filepath']}
"""

    with open(filepath, 'w', encoding='utf-8') as f:
        f.write(content)

    print(f"   💾 Saved summary: {filename}")

    return filepath


def summarize_recent_papers(limit: int = 5):
    """Summarize recent papers from research directory."""
    print("=" * 60)
    print("🤖 Research Summarizer")
    print("=" * 60)
    print(f"📅 Started: {datetime.now().isoformat()}")
    print(f"📁 Research dir: {RESEARCH_DIR}")

    # Check API config
    if not check_api_config():
        return

    # Find all paper files
    papers_dir = RESEARCH_DIR / "papers"
    paper_files = []

    for domain_dir in papers_dir.iterdir():
        if domain_dir.is_dir():
            for paper_file in domain_dir.glob("*.md"):
                paper_files.append(paper_file)

    if not paper_files:
        print("❌ No papers found in research/papers/")
        return

    # Sort by modification time (most recent first)
    paper_files.sort(key=lambda p: p.stat().st_mtime, reverse=True)

    # Take only most recent N papers
    paper_files = paper_files[:limit]

    print(f"\n📋 Found {len(paper_files)} recent papers to summarize")

    # Choose API based on availability
    use_anthropic = ANTHROPIC_AVAILABLE and ANTHROPIC_API_KEY
    use_openai = OPENAI_AVAILABLE and OPENAI_API_KEY

    summaries_created = 0
    summaries_failed = 0

    # Summarize each paper
    for i, paper_file in enumerate(paper_files, 1):
        print(f"\n📄 [{i}/{len(paper_files)}] {paper_file.name}")

        # Extract metadata
        metadata = extract_paper_metadata(paper_file)
        if not metadata:
            summaries_failed += 1
            continue

        # Check if summary already exists
        summary_path = SUMMARIES_DIR / metadata['domain'] / f"{metadata['arxiv_id']}_*.md"
        if list(summary_path.parent.glob(f"{metadata['arxiv_id']}_*.md")):
            print(f"   ⏭️  Skipping (summary already exists)")
            continue

        # Summarize with available API
        summary = None

        if use_anthropic:
            print("   🔍 Summarizing with Anthropic Claude...")
            summary = summarize_with_anthropic(metadata['title'], metadata['abstract'])

        if not summary and use_openai:
            print("   🔍 Summarizing with OpenAI GPT...")
            summary = summarize_with_openai(metadata['title'], metadata['abstract'])

        if summary:
            save_summary(summary, metadata)
            summaries_created += 1
        else:
            print(f"   ❌ Failed to summarize")
            summaries_failed += 1

    # Print summary
    print("\n" + "=" * 60)
    print(f"✅ Complete!")
    print(f"   Summaries created: {summaries_created}")
    print(f"   Summaries failed: {summaries_failed}")
    print(f"📅 Finished: {datetime.now().isoformat()}")
    print("=" * 60)


def main():
    """Main function."""
    import sys

    limit = 5
    if len(sys.argv) > 1:
        try:
            limit = int(sys.argv[1])
        except ValueError:
            print(f"⚠️  Invalid limit: {sys.argv[1]}, using 5")
            limit = 5

    summarize_recent_papers(limit)


if __name__ == "__main__":
    main()
