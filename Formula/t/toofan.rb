class Toofan < Formula
  desc "Minimal, lightning-fast typing tester TUI"
  homepage "https://github.com/vyrx-dev/toofan"
  url "https://github.com/vyrx-dev/toofan/archive/refs/tags/v2.4.0.tar.gz"
  sha256 "4a860f12dae57f79e19a96797580d24a7f90d99734ee5bef9b2bfb1ac48e54b5"
  license "MIT"
  head "https://github.com/vyrx-dev/toofan.git", branch: "master"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "af4f7e2b758a2073d4b8d189d9667d0ec5357b0c1c4bab0b3d3db2144086f9ba"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "af4f7e2b758a2073d4b8d189d9667d0ec5357b0c1c4bab0b3d3db2144086f9ba"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "af4f7e2b758a2073d4b8d189d9667d0ec5357b0c1c4bab0b3d3db2144086f9ba"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "9d0acfcb0e918bf4915b45d2fc446c68744fc563e69e77bde97327ca2e5cf8ee"
    sha256 cellar: :any,                 x86_64_linux:  "f382fc5df75c60553b5f0eb85e13072a2dab83f0e44c000480635720299d126e"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w -X main.version=#{version}"), "."
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/toofan --version 2>&1")
  end
end
