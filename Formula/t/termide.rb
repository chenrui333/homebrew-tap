class Termide < Formula
  desc "Cross-platform terminal-based IDE, file manager, and virtual terminal"
  homepage "https://termide.github.io"
  url "https://github.com/termide/termide.git",
      tag:      "0.29.6",
      revision: "f2f17915b61ba0474a3825a290ba9cb82e008396"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "8957bab56fcb09798185401b34eff866f4383532d3513b74d6b11053172537cb"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "9f847aef59ea0590382bbde8f7e575d83bae5f911d4a92c44e706b63e6b2e6f9"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "515e8faa454a7e6471220c399d245640e84bdd2c06a41f36fc0951bb0f146860"
    sha256 cellar: :any,                 arm64_linux:   "1ae8ad4f8c4d8dba5b02da945a9e38c7f474d0e00a08e7d842fea28713fc3ecf"
    sha256 cellar: :any,                 x86_64_linux:  "fc4a49e81540cb980d660b22121363e55dca042b8b1447350e765f8b30360363"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build
  depends_on "openssl@3"

  on_linux do
    depends_on "zlib-ng-compat"
  end

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/termide --version")

    output = shell_output("#{bin}/termide --config #{testpath}/missing.toml --diagnostics 2>&1", 1)
    assert_match "load: No such file or directory", output
    assert_match "One or more checks failed", output
  end
end
