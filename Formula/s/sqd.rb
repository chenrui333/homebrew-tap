class Sqd < Formula
  desc "SQL-like document editor"
  homepage "https://github.com/albertoboccolini/sqd"
  url "https://github.com/albertoboccolini/sqd/archive/refs/tags/v0.2.3.tar.gz"
  sha256 "57bf15a862b36e4a33e6407972ecbaa04e6571f156d7db44d8123e40bd69bfea"
  license "MIT"
  head "https://github.com/albertoboccolini/sqd.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "97991323c24da812f4a91a5aa43847327643f94d8fca972c3495aad5f7063854"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "97991323c24da812f4a91a5aa43847327643f94d8fca972c3495aad5f7063854"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ed74e24df2ca7f52fd3a5c6c98036b46bae19c640b5cf318939c36aa06171421"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c2c9bbdba25854a8813ffb1fc8e664ad179f9496d395a3c96c434e3bf9fae151"
  end

  depends_on "go" => :build

  deny_network_access!

  def install
    system "go", "build", *std_go_args, "."
  end

  test do
    (testpath/"sample.txt").write("alpha\nbeta\n")
    output = shell_output("#{bin}/sqd \"SELECT content FROM *.txt WHERE content = 'alpha'\"")
    assert_match "alpha", output
    assert_match version.to_s, shell_output("#{bin}/sqd --version")
  end
end
