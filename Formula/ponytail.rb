class Ponytail < Formula
  desc "YAGNI and minimal-implementation plugin for AI coding agents"
  homepage "https://github.com/DietrichGebert/ponytail"
  url "https://github.com/DietrichGebert/ponytail/archive/refs/tags/v4.10.1.tar.gz"
  sha256 "bff9c3c7bddde135654dded75a396473ed74cd578025bf94320c0ecbad17e82a"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, all: "3a590a8db4a749d3060cc38855d7ba75fce7a2b9458714690aa83e63a9cb3c90"
  end

  depends_on "node"

  def install
    libexec.install ".agents", ".claude-plugin", ".codex-plugin",
                    "hooks", "skills", "commands", "assets",
                    "AGENTS.md", "README.md", "LICENSE", "after-install.md",
                    "package.json", "plugin.yaml"
  end

  test do
    require "json"

    codex_manifest = JSON.parse((libexec/".codex-plugin/plugin.json").read)
    claude_manifest = JSON.parse((libexec/".claude-plugin/plugin.json").read)

    assert_equal "ponytail", codex_manifest.fetch("name")
    assert_equal version.to_s, codex_manifest.fetch("version")
    assert_equal codex_manifest.fetch("version"), claude_manifest.fetch("version")
    assert_path_exists libexec/".claude-plugin/marketplace.json"
    assert_path_exists libexec/"hooks/claude-codex-hooks.json"
    assert_path_exists libexec/"skills/ponytail/SKILL.md"
  end
end
