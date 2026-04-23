class OhMyClaude < Formula
  desc "Teams-first multi-agent orchestration for Claude Code"
  homepage "https://github.com/Yeachan-Heo/oh-my-claudecode"
  url "https://registry.npmjs.org/oh-my-claude-sisyphus/-/oh-my-claude-sisyphus-4.13.2.tgz"
  sha256 "68857a2e0d0aa7bef6243f2553ab84b153a82e2ab800444e11550e990b0ce012"
  license "MIT"
  head "https://github.com/Yeachan-Heo/oh-my-claudecode.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any,                 arm64_tahoe:   "84052e3e181432246797e299945f79ac5f120cb0212b023a5ee18248d16faf69"
    sha256 cellar: :any,                 arm64_sequoia: "6b34b6f09d89885b9624be28371f0b8f1d35159cd6c7f0c663e41b232860ed6c"
    sha256 cellar: :any,                 arm64_sonoma:  "6b34b6f09d89885b9624be28371f0b8f1d35159cd6c7f0c663e41b232860ed6c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "de9017a84898f0720dff5ac31a376e8a92da0ea3a279a345610520f256db77b2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7496a1f170c568e867e49d88eba1bcc60f2eafa75e68e04f12883f7bdfadc361"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink libexec.glob("bin/*")

    # Remove vendored prebuilt ripgrep binaries that cause Mach-O relocation failures
    vendor_dir = libexec/"lib/node_modules/oh-my-claude-sisyphus/node_modules" \
                         "/@anthropic-ai/claude-agent-sdk/vendor"
    rm_r(vendor_dir) if vendor_dir.exist?
  end

  test do
    pkg = libexec/"lib/node_modules/oh-my-claude-sisyphus/package.json"
    assert_match version.to_s, shell_output("node -p \"require('#{pkg}').version\"").strip

    output = shell_output("#{bin}/omc --help 2>&1")
    assert_match "omc", output
  end
end
