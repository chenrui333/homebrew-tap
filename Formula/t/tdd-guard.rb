class TddGuard < Formula
  desc "Automated TDD enforcement for Claude Code"
  homepage "https://github.com/nizos/tdd-guard"
  url "https://registry.npmjs.org/tdd-guard/-/tdd-guard-1.6.8.tgz"
  sha256 "66578d92316852408b6c80b545a314d11ce1ee5acec8c068db1bb4b22e3b8031"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any,                 arm64_tahoe:   "caa8c6b56c89fa022b34aa171ef9ee2c33a1beddc6700a4391537c594dd00d54"
    sha256 cellar: :any,                 arm64_sequoia: "e59ad4c9dfce75153cff697dc0ced818ad1c771caedb47c5b40b77a9718a5ff1"
    sha256 cellar: :any,                 arm64_sonoma:  "0e380b60e3a308724e5a9bea7b955118ee216b56143a681834e197af93185a24"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "36e8a32cffea3cf8c2c68e489ffafbc5172ee2f8e2e6457ed4dd38b3a0df1e2a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5f9e6c54309862b06d5bc0af771c941cf9cfe1155b87ff118094807939260a8b"
  end

  depends_on "tree-sitter-cli" => :build
  depends_on "node"

  def install
    ENV.prepend_path "PATH", Formula["tree-sitter-cli"].opt_bin

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
