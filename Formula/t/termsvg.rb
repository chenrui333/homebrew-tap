class Termsvg < Formula
  desc "Record, share and export your terminal as a animated SVG image"
  homepage "https://github.com/MrMarble/termsvg"
  url "https://github.com/MrMarble/termsvg/archive/refs/tags/v0.9.3.tar.gz"
  sha256 "a8352a3b2f12de97a5b2935885a1938633f46b02a4965efa6f1117de4b9cce83"
  license "GPL-3.0-only"
  head "https://github.com/MrMarble/termsvg.git", branch: "master"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "961025094120959d5d3926dffc91580f893242d5527db3f2ddba24874fd3291c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "addd6c0b1d459b158cac6ba0ed6291e8dea5bdd36308021cd904cd87c84f518d"
    sha256 cellar: :any_skip_relocation, ventura:       "cf68351f18a63e4774a61976556180b03670729b6bf73c4aeecb4592d3112bbe"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a4b603f08539855c69225961bfc9e3a98e63ce0d69063a3e90422cda742d4e5a"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X main.version=#{version} -X main.commit=#{tap.user} -X main.date=#{time.iso8601}"
    system "go", "build", *std_go_args(ldflags:), "./cmd/termsvg"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/termsvg --version")

    output = shell_output("#{bin}/termsvg play nonexist 2>&1", 80)
    assert_match "no such file or directory", output
  end
end
