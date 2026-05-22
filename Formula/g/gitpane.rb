class Gitpane < Formula
  desc "Multi repo Git workspace dashboard for the terminal"
  homepage "https://github.com/affromero/gitpane"
  url "https://github.com/affromero/gitpane/archive/refs/tags/v0.7.2.tar.gz"
  sha256 "a2aa5b2f2c6af958c9505122ba05abe372eff73f74296c3a33b39a2f98edfa65"
  license "MIT"
  head "https://github.com/affromero/gitpane.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256                               arm64_tahoe:   "51afb07a907313625cad12c579ece8182ad495dca7501dce9174c50b7003d94d"
    sha256                               arm64_sequoia: "4ad886888073fa09c55482cd0a038e709438fdc9c87bf66483b9ec28d0e0a1fc"
    sha256                               arm64_sonoma:  "c9e6449d3680870598aa14aafd5b5ed3884b5c6d5c24e9f8afd9bf7eafec3b99"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "845a2c2786e02eb6212b9beb405993e199954be105e7ffa82ba57871ba75e6cb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ba7c3f79e46082ab07192553dcc62b85befdd0eb420b88b53cc89c56c2d6782e"
  end

  depends_on "rust" => :build
  depends_on "openssl@3"

  on_linux do
    depends_on "zlib-ng-compat"
  end

  def install
    ENV["OPENSSL_DIR"] = Formula["openssl@3"].opt_prefix
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match "gitpane", shell_output("#{bin}/gitpane --help 2>&1")
  end
end
