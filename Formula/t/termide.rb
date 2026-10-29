class Termide < Formula
  desc "Cross-platform terminal-based IDE, file manager, and virtual terminal"
  homepage "https://termide.github.io"
  url "https://github.com/termide/termide.git",
      tag:      "0.47.1",
      revision: "fc9a0a1d4910649d16710b481b762f0f4150ea58"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "50d352ef1e424911684d9fd5a538763426502342655b6c6ef6023aaab29af170"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "1257f203dc62242ee0bcea974264f7f3f512ee79bb12371747964b19d8348e75"
    sha256 cellar: :any,                 arm64_linux:   "988a8e8f850b20a12eacce4a779b81e94af9d0ce717abbc6adad8a66ec089d5a"
    sha256 cellar: :any,                 x86_64_linux:  "65777d7514e61f284446faadaaff430d5eed32e044dcade9b4782834c52e0786"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build
  depends_on "openssl@3"

  on_linux do
    depends_on "zlib-ng-compat"
  end

  deny_network_access!

  def fetch
    system "cargo", "fetch", *std_cargo_fetch_args
  end

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/termide --version")

    output = shell_output("#{bin}/termide --config #{testpath}/missing.toml --diagnostics 2>&1", 1)
    assert_match "load: config file not found", output
    assert_match "One or more checks failed", output
  end
end
