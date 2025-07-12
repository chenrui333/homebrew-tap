class Termsvg < Formula
  desc "Record, share and export your terminal as a animated SVG image"
  homepage "https://github.com/MrMarble/termsvg"
  url "https://github.com/MrMarble/termsvg/archive/refs/tags/v0.9.3.tar.gz"
  sha256 "a8352a3b2f12de97a5b2935885a1938633f46b02a4965efa6f1117de4b9cce83"
  license "GPL-3.0-only"
  head "https://github.com/MrMarble/termsvg.git", branch: "master"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "dd201ab00b12deca51a81f223aba28c3e57b144a3026e1b8bc24b863ab2185be"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "7b6ca7f7d7145a5ec0fe0416a14c9b534891c776ab9f20aa83f7ba6f07aa32b9"
    sha256 cellar: :any_skip_relocation, ventura:       "33ab6541a2af90c7e2ae38a1644a301bbd8f00928283c0bd3f56f04bcb0b1d7d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9d1c39a28440144510d0d4568cec69307dad6c1cbe408140db405a4df28c0f1d"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X main.version=#{version} -X main.commit=#{tap.user} -X main.date=#{time.iso8601}"
    system "go", "build", *std_go_args(ldflags:), "./cmd/termsvg"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/termsvg --version")

    output = shell_output("#{bin}/termsvg play nonexist 2>&1", 1)
    assert_match "no such file or directory", output
  end
end
