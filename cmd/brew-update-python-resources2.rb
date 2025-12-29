#!/usr/bin/env ruby
# frozen_string_literal: true

# Wrapper around `brew update-python-resources` that handles packages lacking
# suitable source distributions by creating skeleton resource stanzas.
#
# Usage:
#   brew update-python-resources2 FORMULA [options]
#
# When a package lacks a source distribution on PyPI, this command will:
# 1. Exclude it from dependency resolution (to allow the update to proceed)
# 2. Insert a skeleton resource block in the formula for manual backfill

require "open3"

# Show help if requested or no arguments
if ARGV.include?("--help") || ARGV.include?("-h") || ARGV.empty?
  puts <<~HELP
    Usage: brew update-python-resources2 FORMULA [options]

    Wrapper around 'brew update-python-resources' that handles PyPI packages
    lacking suitable source distributions by creating skeleton resource stanzas
    for manual backfill.

    Options:
      --exclude PKG1,PKG2,...  Comma-separated list of packages to exclude
                               (can be specified multiple times)
      --max-retries N          Maximum retry attempts (default: 25)
      --quiet                  Reduce output verbosity
      --dry-run                Preview changes without modifying formula
      --print-missing          Print only the missing-sdist package list
      -h, --help               Show this help message

    All other flags are passed through to 'brew update-python-resources'.

    Behavior:
      - Verbose by default (use --quiet to reduce output)
      - When a package lacks source distribution, excludes it for dependency
        resolution but adds a skeleton resource block to the formula
      - Skeletons include TODO comments for manual URL/sha256 backfill

    Example:
      brew update-python-resources2 paperai
      brew update-python-resources2 paperai --dry-run --print-missing
      brew update-python-resources2 paperai --quiet --exclude some-package
  HELP
  exit 0
end

def odie(message)
  warn "Error: #{message}"
  exit 1
end

def find_formula_path(formula_name)
  # Try to find formula using brew --repository
  tap_root = `brew --repository chenrui333/tap`.strip

  # Check standard Homebrew structure: Formula/first_letter/name.rb
  first_letter = formula_name[0].downcase
  formula_path = File.join(tap_root, "Formula", first_letter, "#{formula_name}.rb")

  return formula_path if File.exist?(formula_path)

  # Fallback: also check Formula/ directly
  formula_path = File.join(tap_root, "Formula", "#{formula_name}.rb")
  return formula_path if File.exist?(formula_path)

  nil
end

def find_resource_insertion_point(formula_content)
  # Find the last resource block's end position
  # We'll insert new skeletons after the last "end" that closes a resource block

  last_resource_end = nil
  lines = formula_content.lines

  in_resource = false
  indent_level = 0

  lines.each_with_index do |line, idx|
    if line =~ /^\s+resource\s+["']/
      in_resource = true
      indent_level = line[/^\s*/].length
    elsif in_resource && line =~ /^\s{#{indent_level}}end\s*$/
      last_resource_end = idx
      in_resource = false
    end
  end

  # If we found resources, return the line after the last resource's end
  # Otherwise, try to find the install method and insert before it
  if last_resource_end
    return last_resource_end + 1
  end

  # Fallback: find "def install" and insert before it
  lines.each_with_index do |line, idx|
    if line =~ /^\s+def install/
      return idx
    end
  end

  # Last resort: insert before the final "end" of the class
  lines.rindex { |line| line =~ /^end\s*$/ } || lines.length
end

def generate_skeleton_resource(pkg_name, base_indent = "  ")
  <<~RUBY.split("\n").map { |line| line.empty? ? "" : "#{base_indent}#{line}" }.join("\n")
    # TODO: #{pkg_name} has no sdist on PyPI; fill in a source URL + sha256 manually.
    resource "#{pkg_name}" do
      url ""
      sha256 ""
    end
  RUBY
end

def resource_exists?(formula_content, pkg_name)
  # Check if a resource for this package already exists
  formula_content =~ /resource\s+["']#{Regexp.escape(pkg_name)}["']/
end

def insert_skeleton_resources(formula_path, missing_packages, dry_run: false, quiet: false)
  return if missing_packages.empty?

  content = File.read(formula_path)
  lines = content.lines

  # Filter out packages that already have resources
  to_add = missing_packages.reject { |pkg| resource_exists?(content, pkg) }

  if to_add.empty?
    puts "All missing-sdist packages already have resource blocks." unless quiet
    return
  end

  insertion_point = find_resource_insertion_point(content)

  # Determine base indentation (use same as existing resources or default to 2 spaces)
  base_indent = "  "
  if content =~ /^(\s+)resource\s+["']/
    base_indent = Regexp.last_match(1)
  end

  # Generate skeleton blocks
  skeletons = to_add.map do |pkg|
    generate_skeleton_resource(pkg, base_indent)
  end

  # Insert skeletons
  new_lines = lines.dup
  skeletons.reverse.each do |skeleton|
    new_lines.insert(insertion_point, skeleton + "\n\n")
  end

  new_content = new_lines.join

  if dry_run
    puts "\n--- DRY RUN: Would insert at line #{insertion_point + 1} ---"
    puts skeletons.join("\n\n")
    puts "--- END DRY RUN ---\n"
  else
    File.write(formula_path, new_content)
    puts "✓ Inserted #{to_add.length} skeleton resource(s) into #{formula_path}" unless quiet
  end

  to_add
end

# Parse arguments
formula = ARGV.first
odie "No formula specified" if formula.nil? || formula.start_with?("--")

max_retries = 25
quiet = false
dry_run = false
print_missing_flag = false
user_excludes = []
pass_through_args = []

i = 1
while i < ARGV.length
  arg = ARGV[i]

  case arg
  when /^--max-retries(?:=(.+))?$/
    max_retries = Regexp.last_match(1)&.to_i || ARGV[i + 1].to_i
    i += 1 unless Regexp.last_match(1)
  when /^--exclude(?:=(.+))?$/
    exclude_val = Regexp.last_match(1) || ARGV[i + 1]
    user_excludes.concat(exclude_val.split(",").map(&:strip))
    i += 1 unless Regexp.last_match(1)
  when "--quiet"
    quiet = true
  when "--dry-run"
    dry_run = true
  when "--print-missing"
    print_missing_flag = true
  else
    pass_through_args << arg
  end

  i += 1
end

# Track packages with missing sdist
missing_sdist_packages = []
all_excludes = user_excludes.dup

attempt = 0
last_output = ""

loop do
  attempt += 1

  if attempt > max_retries
    odie "Maximum retry attempts (#{max_retries}) reached. " \
         "Missing sdist packages: #{missing_sdist_packages.join(', ')}"
  end

  # Build the command
  cmd = ["brew", "update-python-resources"]
  cmd << formula

  # Add all excludes (user + missing sdist)
  unless all_excludes.empty?
    cmd << "--exclude"
    cmd << all_excludes.join(",")
  end

  # Add pass-through arguments
  cmd.concat(pass_through_args)

  # Verbose by default
  puts "Attempt #{attempt}: Running: #{cmd.join(' ')}" unless quiet

  # Run the command and capture output
  env = { "HOMEBREW_NO_AUTO_UPDATE" => "1" }
  stdout, stderr, status = Open3.capture3(env, *cmd)
  output = stdout + stderr
  last_output = output

  if status.success?
    # Success! Now insert skeleton resources for missing packages
    puts output unless output.empty? || quiet

    if missing_sdist_packages.any?
      formula_path = find_formula_path(formula)

      if formula_path.nil?
        warn "Warning: Could not locate formula file for '#{formula}'"
        warn "Skipping skeleton resource insertion."
      else
        inserted = insert_skeleton_resources(
          formula_path,
          missing_sdist_packages,
          dry_run: dry_run,
          quiet: quiet
        )

        if print_missing_flag && !quiet
          puts "\nMissing sdist packages: #{missing_sdist_packages.join(', ')}"
        end
      end
    end

    # Print summary
    summary_parts = []
    summary_parts << "✓ Completed successfully"
    if missing_sdist_packages.any?
      summary_parts << "Missing sdist (skeletons #{dry_run ? 'would be' : ''} added): #{missing_sdist_packages.join(', ')}"
    end
    puts summary_parts.join(". ") unless quiet

    break
  end

  # Check if it's the specific "no suitable source distribution" error
  if output =~ /Error: (\S+) exists on PyPI but lacks a suitable source distribution/
    missing_pkg = Regexp.last_match(1)

    if missing_sdist_packages.include?(missing_pkg)
      # Already processed this package - shouldn't happen but handle gracefully
      puts output
      odie "Package '#{missing_pkg}' was already processed but the error persists. " \
           "This may indicate a different issue."
    end

    # Add to tracking lists
    missing_sdist_packages << missing_pkg
    all_excludes << missing_pkg

    puts "⚠  Found missing sdist: '#{missing_pkg}' - excluding for dependency resolution..." unless quiet
    next
  end

  # Some other error occurred - don't retry
  puts output unless quiet
  odie "Command failed with a different error (not missing sdist). Stopping."
end
