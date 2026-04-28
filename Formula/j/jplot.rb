class Jplot < Formula
  desc "ITerm2 expvar/JSON monitoring tool"
  homepage "https://github.com/rs/jplot"
  url "https://github.com/rs/jplot/archive/refs/tags/v1.1.6.tar.gz"
  sha256 "e24e9af3952271ad38fc870082695577af494d93f69cb60a360c87c964996325"
  license "MIT"
  head "https://github.com/rs/jplot.git", branch: "master"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "338d99a80997f9862c673f201caea8665b08a265903a4deeaf0a97118d624364"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ab103d5a315a72407272b6f2a90551b9ce1d7726278a6cec43fa25ba85f5ab37"
    sha256 cellar: :any_skip_relocation, ventura:       "21ed22e5cceca680e31ca8171a299f4a9ba804eff5b64a68ed1bfdbe9f8c1aaa"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ec58db4294b0f762e4692d69e27e131d4c16eb0606d836f9c569c2b7e7464b7d"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")
  end

  test do
    output = shell_output("#{bin}/jplot --help 2>&1")
    assert_match "Usage: jplot [OPTIONS] FIELD_SPEC [FIELD_SPEC...]", output
  end
end
