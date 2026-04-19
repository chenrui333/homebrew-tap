class OhMyCodex < Formula
  desc "Multi-agent orchestration layer for OpenAI Codex CLI"
  homepage "https://github.com/Yeachan-Heo/oh-my-codex"
  url "https://registry.npmjs.org/oh-my-codex/-/oh-my-codex-0.13.2.tgz"
  sha256 "b0b52caa00c1acad44431b7ac4fed8a66555b282ba9a6dec26bc791732d7dbb4"
  license "MIT"
  head "https://github.com/Yeachan-Heo/oh-my-codex.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "38b20a59654ee5a44a24eee0ce74d7d788f3600ae891356efafcf3707a5f12f4"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "38b20a59654ee5a44a24eee0ce74d7d788f3600ae891356efafcf3707a5f12f4"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "38b20a59654ee5a44a24eee0ce74d7d788f3600ae891356efafcf3707a5f12f4"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f0f8f304ad15930154cce81ad84d2444ccc295e6622cb6e82994bde2874ecc6e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f0f8f304ad15930154cce81ad84d2444ccc295e6622cb6e82994bde2874ecc6e"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink libexec.glob("bin/*")
  end

  test do
    pkg = libexec/"lib/node_modules/oh-my-codex/package.json"
    assert_match version.to_s, shell_output("node -p \"require('#{pkg}').version\"").strip

    assert_match "oh-my-codex", shell_output("#{bin}/omx --help")
  end
end
