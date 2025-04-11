class Tuono < Formula
  desc "Superfast fullstack React framework"
  homepage "https://tuono.dev/"
  url "https://github.com/tuono-labs/tuono/archive/refs/tags/v0.19.3.tar.gz"
  sha256 "cf369462263aa5ab0eb09befc1f048785993fa5b14783a4549a530c4e82cecfd"
  license "MIT"
  head "https://github.com/tuono-labs/tuono.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "98e2abc15c40bf368b8f21e1fa7bca92b89f79f9173c6797b5a402358ddca026"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "2fc396a6538386b73a38a2f63831027d65211bd1ba97abcc8cebb8f3c7e9e4ab"
    sha256 cellar: :any_skip_relocation, ventura:       "881293742a12ec54466aec8c453eab18fcd63ecfa8ac3e94d204c9ebdaf6cf77"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e0e58e35df6b06bcda4211621798907ab162e443ad514f269c26a8613edc1814"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build

  on_linux do
    depends_on "openssl@3"
  end

  def install
    system "cargo", "install", *std_cargo_args(path: "crates/tuono")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/tuono --version")

    system bin/"tuono", "new", "my-app"
    assert_path_exists testpath/"my-app/package.json"
  end
end
