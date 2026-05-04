class TddGuard < Formula
  desc "Automated TDD enforcement for Claude Code"
  homepage "https://github.com/nizos/tdd-guard"
  url "https://registry.npmjs.org/tdd-guard/-/tdd-guard-1.6.8.tgz"
  sha256 "66578d92316852408b6c80b545a314d11ce1ee5acec8c068db1bb4b22e3b8031"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any,                 arm64_tahoe:   "e6819975f8e39b0c55e8374d02f464492daa0feedc97f70d23e65a47f0ebc5e3"
    sha256 cellar: :any,                 arm64_sequoia: "ee0e0e55bd08ef48a097875f8155c4bbef36f76b5bb65ecc2252ec8618ccac64"
    sha256 cellar: :any,                 arm64_sonoma:  "ee0e0e55bd08ef48a097875f8155c4bbef36f76b5bb65ecc2252ec8618ccac64"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "8f1934a40ca684bbb527e73814bef355e6e85b404bac6719f9fb2726491f32fa"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4387aced381ebee74c9430eab942c78f696801c20e0a52756b3e9b18f731c5d6"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink libexec.glob("bin/*")

    # Remove incompatible pre-built binaries
    node_modules = libexec/"lib/node_modules/tdd-guard/node_modules"
    os = OS.mac? ? "macOS" : "Linux"
    arch = Hardware::CPU.intel? ? "X64" : "ARM64"
    node_modules.glob("@ast-grep/lang-*/prebuilds/*").each do |dir|
      rm_r(dir) if dir.basename.to_s != "prebuild-#{os}-#{arch}"
    end
    node_modules.glob("**/@img/sharp-*").each(&:rmtree)

    ripgrep_vendor_dir = node_modules/"@anthropic-ai/claude-agent-sdk/vendor/ripgrep"
    rm_r(ripgrep_vendor_dir)

    audio_capture_dir = node_modules/"@anthropic-ai/claude-agent-sdk/vendor/audio-capture"
    rm_r(audio_capture_dir) if audio_capture_dir.directory?
  end

  test do
    input = <<~JSON
      {
        "session_id": "homebrew-test",
        "transcript_path": "#{testpath}/transcript.jsonl",
        "hook_event_name": "UserPromptSubmit",
        "cwd": "#{testpath}",
        "prompt": "tdd-guard off"
      }
    JSON

    assert_match "TDD Guard disabled", pipe_output(bin/"tdd-guard", input, 0)
  end
end
