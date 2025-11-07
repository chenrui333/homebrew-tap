#!/usr/bin/env python3
"""
Scrape Terminal Trove new tools and save to markdown file weekly.
"""

import urllib.request
import urllib.error
from datetime import datetime
import json
import os
import re
import time

def load_link_cache(cache_file):
    """Load cached project links"""
    if os.path.exists(cache_file):
        try:
            with open(cache_file, 'r') as f:
                return json.load(f)
        except:
            return {}
    return {}

def save_link_cache(cache, cache_file):
    """Save project links to cache"""
    try:
        with open(cache_file, 'w') as f:
            json.dump(cache, f, indent=2)
    except:
        pass

def get_project_link(tool_url, cache):
    """Fetch project link (GitHub, GitLab, etc.) from tool's Terminal Trove page"""
    # Check cache first
    if tool_url in cache:
        return cache[tool_url]

    try:
        headers = {
            'User-Agent': 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36'
        }
        req = urllib.request.Request(tool_url, headers=headers)
        with urllib.request.urlopen(req, timeout=5) as response:
            html = response.read().decode('utf-8')

        # Look for project links: GitHub, GitLab, Codeberg, etc.
        # Priority: GitHub > GitLab > Codeberg > other repos
        patterns = [
            r'href=["\']?(https://github\.com/[^"\'\s<>]+)["\']?',
            r'href=["\']?(https://gitlab\.com/[^"\'\s<>]+)["\']?',
            r'href=["\']?(https://codeberg\.org/[^"\'\s<>]+)["\']?',
            r'href=["\']?(https://[a-zA-Z0-9.-]+\.(com|org|io|dev)/[^"\'\s<>]+)["\']?'
        ]

        for pattern in patterns:
            match = re.search(pattern, html)
            if match:
                link = match.group(1)
                cache[tool_url] = link
                return link

        cache[tool_url] = None
        return None
    except Exception as e:
        cache[tool_url] = None
        return None

def scrape_terminal_trove(cache=None):
    """Scrape Terminal Trove new tools page"""
    if cache is None:
        cache = {}

    url = "https://terminaltrove.com/new/"

    headers = {
        'User-Agent': 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36'
    }

    try:
        req = urllib.request.Request(url, headers=headers)
        with urllib.request.urlopen(req, timeout=10) as response:
            html_content = response.read().decode('utf-8')
    except urllib.error.URLError as e:
        print(f"Error fetching URL: {e}")
        return None

    tools_data = {}

    # Parse date sections and tools using regex patterns
    # Find all h2 headers with dates
    date_pattern = r'<h2[^>]*>([^<]+)</h2>'
    dates = re.findall(date_pattern, html_content)

    # Split content by h2 headers to process each date section
    sections = re.split(r'<h2[^>]*>[^<]+</h2>', html_content)

    for i, date in enumerate(dates):
        if i + 1 >= len(sections):
            break

        section = sections[i + 1]
        tools = []

        # Find all list items in this section (until next h2 or next date)
        # Pattern: <li class="list-item">...<a href="/tool/">toolname</a>...<small>description</small>...</li>
        li_pattern = r'<li[^>]*class="[^"]*list-item[^"]*"[^>]*>(.*?)</li>'
        list_items = re.findall(li_pattern, section, re.DOTALL)

        for li_content in list_items:
            # Extract tool name and URL
            name_pattern = r'<a[^>]*class="[^"]*tt-link[^"]*"[^>]*href="([^"]*)"[^>]*>([^<]+)</a>'
            name_match = re.search(name_pattern, li_content)

            if not name_match:
                continue

            tool_url = name_match.group(1)
            tool_name = name_match.group(2).strip()

            # Extract description
            desc_pattern = r'<small>([^<]+)</small>'
            desc_match = re.search(desc_pattern, li_content)
            description = desc_match.group(1).strip() if desc_match else "No description"

            # Check if tool of the week
            is_totw = 'badge-totw' in li_content
            totw_badge = ' ⭐ (Tool of The Week)' if is_totw else ''

            # Get project link with rate limiting
            full_tool_url = f"https://terminaltrove.com{tool_url}"
            project_link = get_project_link(full_tool_url, cache)
            time.sleep(0.1)  # Be respectful to the server

            tools.append({
                'name': tool_name,
                'url': full_tool_url,
                'description': description,
                'is_totw': is_totw,
                'totw_badge': totw_badge,
                'project_link': project_link
            })

        if tools:
            tools_data[date] = tools

    return tools_data

def generate_markdown(tools_data):
    """Generate markdown content from scraped tools in table format"""
    markdown = "# Terminal Trove - New Tools\n\n"
    markdown += "> ⚠️ **Auto-generated file** - Do not modify manually. This file is automatically generated by `scrape_terminal_trove.py`.\n\n"
    markdown += f"**Last Updated:** {datetime.now().strftime('%Y-%m-%d %H:%M:%S')}\n\n"
    markdown += "Scraped from [Terminal Trove - New Tools](https://terminaltrove.com/new/)\n\n"

    for date, tools in tools_data.items():
        markdown += f"## {date}\n\n"
        markdown += "| Tool | Description | Link |\n"
        markdown += "|------|-------------|------|\n"

        for tool in tools:
            tool_name = tool['name']
            if tool['is_totw']:
                tool_name += ' ⭐'

            description = tool['description']
            # Escape pipes in description
            description = description.replace('|', '\\|')

            link = tool['project_link'] if tool['project_link'] else '-'
            # Strip ref parameter from links
            if link and '?' in link:
                link = link.split('?')[0]

            markdown += f"| {tool_name} | {description} | {link} |\n"

        markdown += "\n"

    return markdown

def save_markdown(content, output_file="terminal_trove_weekly.md"):
    """Save markdown content to file"""
    try:
        with open(output_file, 'w') as f:
            f.write(content)
        print(f"Successfully saved to {output_file}")
        return True
    except IOError as e:
        print(f"Error writing to file: {e}")
        return False

def main():
    print("Scraping Terminal Trove...")

    # Setup cache
    script_dir = os.path.dirname(os.path.abspath(__file__))
    cache_file = os.path.join(script_dir, ".project_links_cache.json")
    cache = load_link_cache(cache_file)

    tools_data = scrape_terminal_trove(cache)

    # Save cache for future runs
    save_link_cache(cache, cache_file)

    if not tools_data:
        print("Failed to scrape tools")
        return False

    print(f"Found {sum(len(v) for v in tools_data.values())} tools across {len(tools_data)} weeks")

    markdown = generate_markdown(tools_data)

    # Default output location - save to awesome folder
    output_file = os.path.join(script_dir, "terminal_trove_weekly.md")

    if save_markdown(markdown, output_file):
        print(f"Markdown file created: {output_file}")
        return True

    return False

if __name__ == "__main__":
    main()
