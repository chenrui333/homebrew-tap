class Lazytail < Formula
  desc "Terminal-based log viewer with live filtering"
  homepage "https://github.com/raaymax/lazytail"
  url "https://github.com/raaymax/lazytail/archive/refs/tags/v0.9.0.tar.gz"
  sha256 "750d24bfc59eb0f7caa78a8846b7c68033f12df7feb582b07a90721b4e684bd4"
  license "MIT"
  head "https://github.com/raaymax/lazytail.git", branch: "master"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "dfb73fb0af7eb7b751660dfbeae1c99640243829b7e91194fd476ae959461440"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "0ff57b3692ba6430bafd1101c52d73330bd111372f593f36869a0ac95990f5ea"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "4a4f452f878b599d24767bdaa971f48799d966af139a50b12823c3e2a9b793b0"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "8f829362a416303e71a966b6a234feb63c93ad65db5f47d1f5ca5e2f8297545f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7961da9b219f55ae854f8f5d2a3a29008e702f386b985b5e74837d29aa69eab7"
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
