class Upmd < Formula
  desc "Run tasks and dependency-aware workflows from Markdown"
  homepage "https://github.com/rezigned/upmd"
  url "https://github.com/rezigned/upmd/archive/refs/tags/v0.2.7.tar.gz"
  sha256 "dc662fc5fe25f6a0a4a7fb591d7271dcd67b2728b7acd74c5e2e549e744a6516"
  license "MIT"
  head "https://github.com/rezigned/upmd.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "e0cdf4e713d667da03f9a6cb4b91f9db75e85db7d925a6328ed59d9601357f6a"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "16f6b04bec61164e668592863113de277e177123e36a9db549e6a18bbbdc34cd"
    sha256 cellar: :any,                 arm64_linux:   "3b14afe06f226f352202571b6de73bd969514a8532cdb57e152c78b2355db3cb"
    sha256 cellar: :any,                 x86_64_linux:  "20973d88d66c32fa183748997de4fedc4447a2ffa9e3034f813159b1b19cb04d"
  end

  depends_on "rust" => :build

  deny_network_access!

  def fetch
    system "cargo", "fetch", *std_cargo_fetch_args
  end

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/upmd --version")
    (testpath/"up.md").write <<~MARKDOWN
      # Offline task

      ```bash
      printf 'Homebrew task completed\\n'
      ```
    MARKDOWN
    output = shell_output("#{bin}/upmd --ci --all #{testpath}/up.md")
    assert_match "Homebrew task completed", output
  end
end
