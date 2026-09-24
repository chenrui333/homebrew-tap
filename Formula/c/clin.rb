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
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "899a602e2280330f60d242063a7c8bce9621a63c246d6e4975be6f48af0ffbff"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "733673279df5a54cdbd50aba13dd61461d523b979d7d30d88e09f24aa54a6c51"
    sha256 cellar: :any,                 arm64_linux:   "dcc8ec439dcb60a18f0fe6daad53b89accdb89322e4149db2589f5a4f3280786"
    sha256 cellar: :any,                 x86_64_linux:  "c77a09f80d1086dc24916a7ef7c24310026fb85d679d763bf1333fe2171e1c0f"
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
