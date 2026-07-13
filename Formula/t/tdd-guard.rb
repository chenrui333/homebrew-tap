class TddGuard < Formula
  desc "Automated TDD enforcement for Claude Code"
  homepage "https://github.com/nizos/tdd-guard"
  url "https://registry.npmjs.org/tdd-guard/-/tdd-guard-1.7.0.tgz"
  sha256 "3bb7bba3220d52fc65d2929d544368de83a2afaa0028086e7f0498a762f0da77"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any, arm64_tahoe:   "35ed9ccfea121cd1959cff01f8d4aba883958a34fc322a7f88c977d9ff7348d8"
    sha256 cellar: :any, arm64_sequoia: "7ff2f12be5fe3f0bd9d5d677912c107a879c478971e820e6f6e52a0c45aa54e5"
    sha256 cellar: :any, arm64_sonoma:  "6ce336723562ce84890f91d3329b30b1419ff0748bd014dd0c37025d9fc09dd5"
    sha256 cellar: :any, arm64_linux:   "88b5f43932e3359d347b9faa4d14f33fcab6e635d0d68c2d2c0548b461532d92"
    sha256 cellar: :any, x86_64_linux:  "8d75a7c09fd2f05e36cfd2d6efa4c6961eea9da604d97f1c51b7a9222d3a59f2"
  end

  depends_on "tree-sitter-cli" => :build
  depends_on "node"

  def install
    ENV.prepend_path "PATH", formula_opt_bin("tree-sitter-cli")

    system "npm", "install", *std_npm_args
    bin.install_symlink libexec.glob("bin/*")

    # Remove incompatible pre-built binaries
    node_modules = libexec/"lib/node_modules/tdd-guard/node_modules"
    node_modules.glob("@ast-grep/lang-*").each do |lang_dir|
      rm_r(lang_dir/"prebuilds")
      cd lang_dir do
        if lang_dir.basename.to_s == "lang-php"
          system "npm", "install", "tree-sitter-php@0.24.2",
                 *std_npm_args(prefix: false), "--no-save"
          rm_r("node_modules/tree-sitter-cli")
          rm("node_modules/.bin/tree-sitter")
        end
        system "npm", "run", "build"
        rm_r("node_modules") if lang_dir.basename.to_s == "lang-php"
      end
    end
    node_modules.glob("**/@img/sharp-*").each(&:rmtree)

    ripgrep_vendor_dir = node_modules/"@anthropic-ai/claude-agent-sdk/vendor/ripgrep"
    rm_r(ripgrep_vendor_dir)

    audio_capture_dir = node_modules/"@anthropic-ai/claude-agent-sdk/vendor/audio-capture"
    rm_r(audio_capture_dir) if audio_capture_dir.directory?
  end

  test do
    # FIXME: Upstream does not expose a version command; replace this with a version assertion when available.

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
