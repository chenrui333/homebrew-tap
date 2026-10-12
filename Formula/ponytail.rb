class Ponytail < Formula
  desc "YAGNI and minimal-implementation plugin for AI coding agents"
  homepage "https://github.com/DietrichGebert/ponytail"
  url "https://github.com/DietrichGebert/ponytail/archive/refs/tags/v5.1.1.tar.gz"
  sha256 "6fd5f8f708a1f46d18c65c16645344c027ea779d784c4bfb22bcd82420ed4391"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, all: "68864a5ccd91af90e19110113731be803edafdc818a0cb943a61b1af894b3505"
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
