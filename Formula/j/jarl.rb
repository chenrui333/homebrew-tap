class Jarl < Formula
  desc "Just Another R Linter"
  homepage "https://jarl.etiennebacher.com/"
  url "https://github.com/etiennebacher/jarl/archive/refs/tags/0.4.0.tar.gz"
  sha256 "a7f88a222ad47356ac29059e39faa8f1b24cc46f311c0e759b03dff1aeb31b4a"
  license "MIT"
  head "https://github.com/etiennebacher/jarl.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "026eb60054e0be46a732d4133ea81cc1444b473536e422b36b90a8eacf368d30"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ea241b1e81779a058232081223b427cb30ca62ea91dacfd144f4f5cdfb54dccc"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "9c1adba14dd4d0a10e6c8185979c315e000da0ede59df4538452b9ad31be5e04"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a135b3e25ab508d59dc656401665a829a3eb8c8b20b7c091f579e487e6ff6305"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3647c25023934c8a11c4adaf7020af136feede2bbc4516b558f26c76775a993d"
  end

  depends_on "rust" => :build

  uses_from_macos "zlib"

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
