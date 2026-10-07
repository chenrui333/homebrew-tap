class Tunnelto < Formula
  desc "Expose your local web server to the internet with a public URL"
  homepage "https://github.com/agrinman/tunnelto"
  url "https://github.com/agrinman/tunnelto/archive/refs/tags/0.1.18.tar.gz"
  sha256 "100a8364d8fa4ac66e20f34b781c7b3fcee852eaa1e2ee29a05d40e4178269d2"
  license "MIT"
  head "https://github.com/agrinman/tunnelto.git", branch: "master"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    rebuild 2
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "9a01859f688dc51c6f01dcb782c54164c2de26765ad860ed7d9637d4280842e8"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "15ac13136d580b12fca01ed0494b4ca32c37b2cab255036ef506ba3b72374dde"
    sha256 cellar: :any,                 arm64_linux:   "7fc12dd35fba83deb08bc9d8462e7f62d4971a98813f63f6c942f945558bc8bf"
    sha256 cellar: :any,                 x86_64_linux:  "db16f38e804b535d9039021ce2782589d8166c40963e1f2da912e6991d841b84"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build
  depends_on "openssl@3"

  deny_network_access!

  def fetch
    system "cargo", "update", "-p", "openssl", "--precise", "0.10.68"
    system "cargo", "update", "-p", "openssl-sys", "--precise", "0.9.116"
    system "cargo", "fetch", *std_cargo_fetch_args
  end

  def install
    system "cargo", "install", *std_cargo_args(path: "tunnelto")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/tunnelto --version")

    output = shell_output("#{bin}/tunnelto --not-a-real-option 2>&1", 1)
    assert_match "not-a-real-option", output
  end
end
