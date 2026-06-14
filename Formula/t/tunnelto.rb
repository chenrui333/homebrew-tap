class Tunnelto < Formula
  desc "Expose your local web server to the internet with a public URL"
  homepage "https://github.com/agrinman/tunnelto"
  url "https://github.com/agrinman/tunnelto/archive/refs/tags/0.1.18.tar.gz"
  sha256 "100a8364d8fa4ac66e20f34b781c7b3fcee852eaa1e2ee29a05d40e4178269d2"
  license "MIT"
  head "https://github.com/agrinman/tunnelto.git", branch: "master"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "4a4265faa920380f656660d0419df796d2e2f0e430da195bf2b4d109f4b93a6e"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "0357db179c264c4bd202e29c75ad99ae942110a3cbebdb49a08c23fef3d28ecb"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c92a0912df2fdf7a643c3d031afdc9de3ec5f31d903e0bfd4d06fa78a2924b8e"
    sha256 cellar: :any,                 arm64_linux:   "5bf2def15babf76884d52fdf415159ad6e6284d216f0fda4c28b778b946b4906"
    sha256 cellar: :any,                 x86_64_linux:  "18e54241f09a59a29eec061d2c687f7380c69c48d66b6d792c97fd8835ca018e"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build
  depends_on "openssl@3"

  def install
    system "cargo", "update", "-p", "openssl", "--precise", "0.10.68"
    system "cargo", "update", "-p", "openssl-sys", "--precise", "0.9.116"
    system "cargo", "install", *std_cargo_args(path: "tunnelto")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/tunnelto --version")

    output = shell_output("#{bin}/tunnelto --not-a-real-option 2>&1", 1)
    assert_match "not-a-real-option", output
  end
end
