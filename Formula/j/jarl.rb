class Jarl < Formula
  desc "Just Another R Linter"
  homepage "https://jarl.etiennebacher.com/"
  url "https://github.com/etiennebacher/jarl/archive/refs/tags/0.4.0.tar.gz"
  sha256 "a7f88a222ad47356ac29059e39faa8f1b24cc46f311c0e759b03dff1aeb31b4a"
  license "MIT"
  head "https://github.com/etiennebacher/jarl.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "923d8f158510f528a359acc13a72f19ee361f1b7555dc9d02209d09f933f3bde"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "aeb955d30766cae889d708dedd6452ef9344d0def8dbb85a67c447f80be13ef7"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "eb72931d1996d5cdf0ff11a85d5f0a697a8a522377003d12843025f522d0e31c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "3369a0b3a0c1e665b053c18e40572d8f420479b97b6e01f0480e64f6b0f72f27"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "98a4cfcd3fdd010118bafcc43b27af8bf24c61bf80caca7f03b449ef1714d954"
  end

  depends_on "rust" => :build

  on_linux do
    depends_on "zlib-ng-compat"
  end

  def install
    system "cargo", "install", *std_cargo_args(path: "crates/jarl")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/jarl --version")

    (testpath/"test.R").write <<~R
      x = 1
      y <-2
      print( x +y )
    R

    output = shell_output("#{bin}/jarl check --select assignment #{testpath}/test.R 2>&1", 1)
    assert_match "Found 1 error", output

    output = shell_output("#{bin}/jarl check --select assignment --fix --allow-no-vcs #{testpath}/test.R")
    assert_match "All checks passed!", output
  end
end
