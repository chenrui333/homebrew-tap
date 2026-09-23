class Clin < Formula
  desc "Terminal note management application"
  homepage "https://github.com/reekta92/clin-rs"
  url "https://github.com/reekta92/clin-rs/archive/refs/tags/v0.13.0-testing.2.tar.gz"
  version "0.13.0-testing.2"
  sha256 "1130d0f753faf2f21a57bda578f4686fffce5694484b790398c46a4c0981ca25"
  license "GPL-3.0-only"
  head "https://github.com/reekta92/clin-rs.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "9524486199bd341cda04cf8934773a3cad04035ab1a9ecbf3cf1da422f4711bc"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b71999bcad9a9b2fd34e9d8a4e6e32d77e5671c6bba0ea0ed4210c2e8a6bb96c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c94c3f41444f269118a5aabb20181fecd5f90cdfa42375330988327dfcec64d3"
    sha256 cellar: :any,                 arm64_linux:   "5e0a179b5400bf1053fdf9b33ca2da86a60ddd1eab074f3514d80c1107afff4c"
    sha256 cellar: :any,                 x86_64_linux:  "b77d7681ab9980657bbcfc8c4dce1f95e5723894a6ab51989b72cc9236e7efa4"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build
  depends_on "libgit2"
  depends_on "libssh2"
  depends_on "openssl@3"

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/clin --version")
    output = shell_output("#{bin}/clin --config #{testpath}/config.toml config show")
    assert_match (testpath/"config.toml").to_s, output
  end
end
