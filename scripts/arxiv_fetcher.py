#!/usr/bin/env python3
"""
arxiv_fetcher.py - Real arXiv API integration for paper discovery

Fetches papers from arXiv API, extracts metadata, downloads PDFs.
"""

import arxiv
import os
import json
import re
from datetime import datetime
from pathlib import Path
from typing import List, Dict, Optional

# Paths
RESEARCH_DIR = Path(__file__).parent.parent / "research"
PAPERS_DIR = RESEARCH_DIR / "papers"
STATUS_FILE = RESEARCH_DIR / "status.json"
DOMAINS_FILE = Path(__file__).parent.parent / "research" / "domains.json"


def load_domains() -> List[Dict]:
    """Load domain configuration from domains.json."""
    try:
        with open(DOMAINS_FILE, 'r') as f:
            data = json.load(f)
            # Handle format where domains are key-value pairs
            if isinstance(data, dict):
                # Convert to list of dicts with 'key' field
                domains = []
                for key, value in data.items():
                    domain = value.copy()
                    domain['key'] = key
                    domains.append(domain)
                return domains
            else:
                return data.get('domains', [])
    except Exception as e:
        print(f"⚠️  Error loading domains: {e}")
        return []


def sanitize_filename(title: str) -> str:
    """Sanitize title for filesystem."""
    # Remove invalid characters, limit length
    clean = re.sub(r'[<>:"/\\|?*]', '', title)
    clean = re.sub(r'\s+', '_', clean.strip())
    return clean[:100]  # Limit to 100 chars


def fetch_papers_for_domain(domain: Dict, max_results: int = 5) -> List[Dict]:
    """Fetch papers for a specific domain from arXiv."""
    print(f"\n🔍 Fetching papers for domain: {domain['name']}")

    # Build query from keywords
    keywords = domain.get('keywords', [])
    query = ' OR '.join([f'all:"{kw}"' for kw in keywords[:3]])  # Use first 3 keywords
    print(f"   Query: {query}")
    print(f"   Categories: {domain.get('arxiv_categories', [])}")

    papers = []

    try:
        client = arxiv.Client()

        # Build search query with categories
        categories = domain.get('arxiv_categories', [])
        if categories:
            # Add category filters
            cat_query = ' OR '.join([f'cat:{cat}' for cat in categories[:2]])
            query = f'({query}) AND ({cat_query})'

        search = arxiv.Search(
            query=query,
            max_results=max_results,
            sort_by=arxiv.SortCriterion.SubmittedDate,
            sort_order=arxiv.SortOrder.Descending
        )

        results = client.results(search)

        for i, result in enumerate(results, 1):
            paper = {
                'id': result.entry_id.split('/')[-1],  # Extract arXiv ID
                'title': result.title,
                'authors': [author.name for author in result.authors],
                'summary': result.summary,
                'published': result.published.isoformat(),
                'updated': result.updated.isoformat(),
                'primary_category': result.primary_category,
                'categories': result.categories,
                'pdf_url': result.pdf_url,
                'domain': domain['name']
            }

            papers.append(paper)
            print(f"   ✅ [{i}] {paper['id']}: {paper['title'][:60]}...")

        print(f"   📊 Found {len(papers)} papers")

    except Exception as e:
        print(f"   ❌ Error fetching papers: {e}")

    return papers


def save_paper_as_markdown(paper: Dict, domain_dir: Path) -> Path:
    """Save paper as markdown file."""
    filename = f"{paper['id']}_{sanitize_filename(paper['title'])}.md"
    filepath = domain_dir / filename

    # Extract arXiv categories for tag
    category_tags = paper.get('categories', [])[:3]

    # Create markdown content
    content = f"""# {paper['title']}

**arXiv ID:** {paper['id']}
**Domain:** {paper['domain']}
**Published:** {paper['published'][:10]}
**Updated:** {paper['updated'][:10]}
**Primary Category:** {paper['primary_category']}

## Authors
{', '.join(paper['authors'])}

## Categories
{', '.join(category_tags)}

## Abstract
{paper['summary']}

## PDF
[Download PDF]({paper['pdf_url']})

## Source
[arXiv Page]({paper['id']})

---
*Fetched: {datetime.now().isoformat()}*
*Tags: {' '.join([f'#{cat.replace("cs.", "").replace("stat.", "").replace("math.", "")}' for cat in category_tags])}*
"""

    with open(filepath, 'w', encoding='utf-8') as f:
        f.write(content)

    print(f"   💾 Saved: {filename}")

    return filepath


def update_status(new_papers_count: int):
    """Update status.json with paper count."""
    try:
        with open(STATUS_FILE, 'r') as f:
            status = json.load(f)

        status['last_run'] = datetime.now().isoformat()
        status['papers_total'] = status.get('papers_total', 0) + new_papers_count

        with open(STATUS_FILE, 'w') as f:
            json.dump(status, f, indent=2)

        print(f"\n📊 Updated status: {status['papers_total']} total papers")

    except Exception as e:
        print(f"⚠️  Error updating status: {e}")


def main():
    """Main fetcher function."""
    print("=" * 60)
    print("📚 arXiv Paper Fetcher")
    print("=" * 60)
    print(f"📅 Started: {datetime.now().isoformat()}")
    print(f"📁 Research dir: {RESEARCH_DIR}")

    # Load domains
    domains = load_domains()
    if not domains:
        print("❌ No domains found in domains.json")
        return

    print(f"📋 Found {len(domains)} domains")

    # Create papers directories
    for domain in domains:
        domain_name = domain['name']
        domain_dir = PAPERS_DIR / domain_name
        domain_dir.mkdir(parents=True, exist_ok=True)
        print(f"📁 Ensured directory: {domain_dir}")

    total_new_papers = 0

    # Fetch papers for each domain
    for domain in domains:
        domain_name = domain['name']
        domain_dir = PAPERS_DIR / domain_name

        papers = fetch_papers_for_domain(domain, max_results=3)

        for paper in papers:
            # Check if paper already exists
            existing_files = list(domain_dir.glob(f"{paper['id']}_*.md"))
            if existing_files:
                print(f"   ⏭️  Skipping {paper['id']} (already exists)")
                continue

            # Save paper
            save_paper_as_markdown(paper, domain_dir)
            total_new_papers += 1

    # Update status
    update_status(total_new_papers)

    print("\n" + "=" * 60)
    print(f"✅ Complete! Fetched {total_new_papers} new papers")
    print(f"📅 Finished: {datetime.now().isoformat()}")
    print("=" * 60)


if __name__ == "__main__":
    main()
