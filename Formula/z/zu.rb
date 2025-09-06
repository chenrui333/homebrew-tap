class Zu < Formula
  desc "Minimalist key-value DB with disk persistence and in-memory cache"
  homepage "https://github.com/539hex/zu"
  url "https://github.com/539hex/zu/archive/refs/tags/v0.5.0-alpha.tar.gz"
  sha256 "103d820a6ede88b39e442dc3ce57302953a3c7ad9e37d3fd723a756cbe995249"
  license "BSD-2-Clause"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "3c3336806f810982472bab484d478ecf9bf3be7f85b33aa319d9ff08b664dfc1"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "4dae952787da335395e53e48f1ff75c274239ef004fe75f84ae138a213a6759b"
    sha256 cellar: :any_skip_relocation, ventura:       "c3fd093c51b518dd859439cdd2a169f8c62e601f1884b3f7cf063cbcb543d921"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2b296954c36d52bdd1d2a0e34a1b01f5bd377616c1e4117a7899dd9e7c85ea5f"
  end

  on_linux do
    depends_on "pkgconf" => :build
    depends_on "readline"
  end

  def install
    system "make", "CC=#{ENV.cc}", "CFLAGS=#{ENV.cflags}"
    bin.install "zu"
  end

  test do
    output = pipe_output("#{bin}/zu", "help\nexit\n", 0)
    assert_match "Starting in-house REST server on port 1337", output
  end
end
