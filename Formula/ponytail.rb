class Ponytail < Formula
  desc "YAGNI and minimal-implementation plugin for AI coding agents"
  homepage "https://github.com/DietrichGebert/ponytail"
  url "https://github.com/DietrichGebert/ponytail/archive/refs/tags/v5.0.0.tar.gz"
  sha256 "f1ca943cac3b7a9b269fce69e4b1edea04913312814eb1ddc4876efb1feaecb8"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, all: "a109ef53a5c76fc2d72d43e90eda96002371e2751183ca5994060e907284f800"
  end

  depends_on "node"

  deny_network_access!

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
