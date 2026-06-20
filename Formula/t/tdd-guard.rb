class TddGuard < Formula
  desc "Automated TDD enforcement for Claude Code"
  homepage "https://github.com/nizos/tdd-guard"
  url "https://registry.npmjs.org/tdd-guard/-/tdd-guard-1.6.9.tgz"
  sha256 "25c5ccb2814deb5d0e46d52170508e008b4e28c8939055f510d0674cdf032991"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any, arm64_tahoe:   "e1c0cad96a4c2a0f3275bae89d249d188eb6995ded23351b3efdf74b95aab0c8"
    sha256 cellar: :any, arm64_sequoia: "b025c930d06ce673247280d087c94966bff90928a6407a882f73a446e0d8b7ac"
    sha256 cellar: :any, arm64_sonoma:  "c1588e328a64260b0ab613095f0e636d6145e124c1e551378cd38e128d1a06de"
    sha256 cellar: :any, arm64_linux:   "e0bda4405ea34ac669e0e479990eeff3fa3f1f5d9ba3af19c12ebe4ef8066985"
    sha256 cellar: :any, x86_64_linux:  "8de660718d7194529cfcaab01d3c537e2a61ab1aba5e6629ba9777f2bf4c1e7b"
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
