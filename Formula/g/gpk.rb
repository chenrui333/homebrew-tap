class Gpk < Formula
  desc "TUI dashboard that consolidates 36+ package managers into one interface"
  homepage "https://github.com/neur0map/glazepkg"
  url "https://github.com/neur0map/glazepkg/archive/refs/tags/v0.5.8.tar.gz"
  sha256 "698a251b207147744ca62766b55221da43852efdee1ce1ae1089835d5303a37e"
  license "GPL-3.0-only"
  head "https://github.com/neur0map/glazepkg.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "b0fceb31492a25ad28e9c40edb63028474dddf4939ddf28f060c24ddd28949e0"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b0fceb31492a25ad28e9c40edb63028474dddf4939ddf28f060c24ddd28949e0"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b0fceb31492a25ad28e9c40edb63028474dddf4939ddf28f060c24ddd28949e0"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "918aaa096140ab69eaa58aa4d7b78132b76a131b3ecd8a6afcade61c514c9a28"
    sha256 cellar: :any,                 x86_64_linux:  "8e794fec2dbbe962c05f101f11154c9ac3f4fa265108bf1524944d6ea84a188e"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X main.version=#{version}"
    ENV["GOFLAGS"] = "-buildvcs=false"
    system "go", "build", *std_go_args(ldflags:), "./cmd/gpk"
  end

  test do
    assert_match "gpk #{version}", shell_output("#{bin}/gpk --version")
  end
end
