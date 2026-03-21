class Lazytail < Formula
  desc "Terminal-based log viewer with live filtering"
  homepage "https://github.com/raaymax/lazytail"
  url "https://github.com/raaymax/lazytail/archive/refs/tags/v0.9.0.tar.gz"
  sha256 "750d24bfc59eb0f7caa78a8846b7c68033f12df7feb582b07a90721b4e684bd4"
  license "MIT"
  head "https://github.com/raaymax/lazytail.git", branch: "master"

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
