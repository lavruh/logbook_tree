#!/usr/bin/env python3
import yaml
import re
import sys
import os

def load_tags(tags_file):
    """Load tags from tags.yaml file."""
    with open(tags_file, 'r') as f:
        content = f.read()
    
    # Extract tags from lines starting with #
    tags = []
    for line in content.split('\n'):
        line = line.strip()
        if line.startswith('#'):
            tags.append(line.lstrip('#'))
    
    return tags

def load_keywords(keywords_file):
    """Load keyword mapping from keywords.yaml file."""
    with open(keywords_file, 'r') as f:
        keywords_data = yaml.safe_load(f)
    
    # Flatten the nested structure into a single mapping
    tag_mapping = {}
    for category, mappings in keywords_data.items():
        if isinstance(mappings, dict):
            tag_mapping.update(mappings)
    
    return tag_mapping

# Load available tags and keywords from YAML files in the same directory
script_dir = os.path.dirname(os.path.abspath(__file__))
tags_file = os.path.join(script_dir, 'tags.yaml')
keywords_file = os.path.join(script_dir, 'keywords.yaml')
tags = load_tags(tags_file)
tag_mapping = load_keywords(keywords_file)

def extract_tags(text, tag_mapping):
    """Extract tags from text based on keywords and abbreviations."""
    found_tags = set()
    text_lower = text.lower()
    
    for pattern, tag_list in tag_mapping.items():
        if re.search(pattern, text, re.IGNORECASE):
            for tag in tag_list:
                found_tags.add(tag)
    
    return sorted(found_tags)

def process_logbook(file_path):
    """Process logbook and add tags to each line."""
    with open(file_path, 'r') as f:
        logbook = yaml.safe_load(f)
    
    result = {}
    
    for entry_num, entry in logbook.items():
        text = entry['text']
        lines = text.split('\n•\t')
        
        tagged_lines = []
        for i, line in enumerate(lines):
            if i == 0:
                # First line doesn't have the bullet separator
                line = line.lstrip('•\t')
            
            if line.strip():
                line_tags = extract_tags(line, tag_mapping)
                tag_string = ' '.join(['#' + tag for tag in line_tags])
                if tag_string:
                    tagged_line = f"•\t{line.strip()} {tag_string}"
                else:
                    tagged_line = f"•\t{line.strip()}"
                tagged_lines.append(tagged_line)
        
        result[entry_num] = {
            'text': '\n'.join(tagged_lines)
        }
    
    # Write to output file
    output_path = file_path.replace('.txt', '_tagged.txt')
    with open(output_path, 'w') as f:
        yaml.dump(result, f, default_flow_style=False, allow_unicode=True, width=float('inf'))
    
    print(f"Tagged logbook saved to: {output_path}")
    return result

if __name__ == "__main__":
    if len(sys.argv) < 2:
        print("Usage: python3 tag_logbook.py <input_file_path>")
        print("Example: python3 tag_logbook.py /home/lavruh/Documents/projects/log_ai/2026-01.txt")
        sys.exit(1)
    
    input_file = sys.argv[1]
    process_logbook(input_file)
