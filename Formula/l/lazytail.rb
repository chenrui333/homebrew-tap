class Lazytail < Formula
  desc "Terminal-based log viewer with live filtering"
  homepage "https://github.com/raaymax/lazytail"
  url "https://github.com/raaymax/lazytail/archive/refs/tags/v0.10.0.tar.gz"
  sha256 "1bf691141abf77942c9a2d5347a865195f7080485fd48396c22de5564e75bc9d"
  license "MIT"
  head "https://github.com/raaymax/lazytail.git", branch: "master"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "c8220f00c22f1918743624b9de95bffc30629b8f1af29457bc22079c0df58ceb"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "2b64fc016671ae135c034ac232c7aa7ed587816531ed40b017a05aa10434d122"
    sha256 cellar: :any,                 arm64_linux:   "54e4bd72eeaa2157f5a523a70c52c49db0192ccc2c845a9e65f7b4d5c1855eee"
    sha256 cellar: :any,                 x86_64_linux:  "1ff19de349eca05dfbe5d4cfedeea6e360c18f3be19e13d296a4ddde2a25dc45"
  end

  depends_on "rust" => :build

  deny_network_access!

  def fetch
    system "cargo", "fetch", *std_cargo_fetch_args
  end

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
