class TddGuard < Formula
  desc "Automated TDD enforcement for Claude Code"
  homepage "https://github.com/nizos/tdd-guard"
  url "https://registry.npmjs.org/tdd-guard/-/tdd-guard-1.7.0.tgz"
  sha256 "3bb7bba3220d52fc65d2929d544368de83a2afaa0028086e7f0498a762f0da77"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    rebuild 1
    sha256 cellar: :any, arm64_tahoe:   "9d130aa7c6eb23f2e1d06f8239d417e57a6a7b35341bad441c007cad9e3cc112"
    sha256 cellar: :any, arm64_sequoia: "5c3566e2021dfd11e1c28734ae5fd76092eb85bde08d1c25dc703bc223f3e2ff"
    sha256 cellar: :any, arm64_linux:   "6e50d5be7141e91866ae04d92dda875d91944cad3019ebb0ab114e5685dd87c8"
    sha256 cellar: :any, x86_64_linux:  "0f4401bab1490fe8ac413d2f64ffbe7621e293679f9179873f41bc1d10b9a841"
  end

  depends_on "tree-sitter-cli" => :build
  depends_on "node"

  deny_network_access!

  def fetch
    system "npm", "install", *std_npm_args(prefix: buildpath/"npm-fetch")
    # Cache the PHP grammar that `install` builds @ast-grep/lang-php against.
    cd buildpath/"npm-fetch/lib/node_modules/tdd-guard/node_modules/@ast-grep/lang-php" do
      system "npm", "install", "tree-sitter-php@0.24.2", *std_npm_args(prefix: false), "--no-save"
    end
  end

  def install
    ENV.prepend_path "PATH", formula_opt_bin("tree-sitter-cli")

    rm_r buildpath/"npm-fetch"
    system "npm", "install", "--offline", *std_npm_args
    bin.install_symlink libexec.glob("bin/*")

    # Remove incompatible pre-built binaries
    node_modules = libexec/"lib/node_modules/tdd-guard/node_modules"
    node_modules.glob("@ast-grep/lang-*").each do |lang_dir|
      rm_r(lang_dir/"prebuilds")
      cd lang_dir do
        if lang_dir.basename.to_s == "lang-php"
          system "npm", "install", "--offline", "tree-sitter-php@0.24.2",
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
