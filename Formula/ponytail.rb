class Ponytail < Formula
  desc "YAGNI and minimal-implementation plugin for AI coding agents"
  homepage "https://github.com/DietrichGebert/ponytail"
  url "https://github.com/DietrichGebert/ponytail/archive/refs/tags/v4.12.0.tar.gz"
  sha256 "b85f6049059b819a68a551a60e529bc64f704f3935aec460a34a6dc77a1c14e5"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, all: "67017057c34d4775812323e15a66a42ebc0b519ec7b3837146df7338946d721b"
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
