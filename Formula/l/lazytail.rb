class Lazytail < Formula
  desc "Terminal-based log viewer with live filtering"
  homepage "https://github.com/raaymax/lazytail"
  url "https://github.com/raaymax/lazytail/archive/refs/tags/v0.10.0.tar.gz"
  sha256 "1bf691141abf77942c9a2d5347a865195f7080485fd48396c22de5564e75bc9d"
  license "MIT"
  head "https://github.com/raaymax/lazytail.git", branch: "master"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "ea0e1c70eaac3c5bdb3aaa6600012e19f2ea7d76a1bf4ce99bc749aaf359b639"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "1e0c082b52a8356695a10dc94a6f770df78ac4d16faeba377de92ac39eaf954c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "042115ffe993cc91bd465b904f80b003a17a19bbc1793ac3007506f4d31d63e5"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "0ef1411685a42287994bfc26e0b06a4fa470db79c683c96efe1883a0f9504ad6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "87bbec61974ee31a675a6c00eff8891e287a9c0681f4274766ad3bb0dd9d3f1b"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/lazytail --version")
    assert system("sh", "-c", "printf 'hello\\nwarn\\n' | #{bin}/lazytail -n test-source --raw >/dev/null")

    log_path = testpath/".config/lazytail/data/test-source.log"
    assert_path_exists log_path
    assert_equal "hello\nwarn\n", log_path.read
  end
end
