class Flowrs < Formula
  desc "TUI application for Apache Airflow"
  homepage "https://github.com/jvanbuel/flowrs"
  url "https://github.com/jvanbuel/flowrs/archive/refs/tags/v0.7.1.tar.gz"
  sha256 "24684ba7d81aedbc4d8b4928ce17db92b6fcb86c6f9d47397147aa3620b53f7b"
  license "MIT"
  head "https://github.com/jvanbuel/flowrs.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "ab05d1cf4ae9f4664c416f3f99546d4e89b52eb56b5094c160aba2963d3968e5"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "fb7c0140b0cc258fe9d4f64ced81421ce7194ec437daff0e441604dc70fe6013"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "62dddb6fc7deb9328881b91808481510df059036ed3f39a80a9ca7e494cf6281"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "771838da7884f6bf0182301f5bf5143afbf2e2f3a631e39dd6dfca7eda6574d0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0d11160905c70236286e0a2331a2a6a9c48ecf8c342b4b931977e6ce136d35d1"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build

  on_linux do
    depends_on "openssl@3"
  end

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/flowrs --version")
    assert_match "No servers found in the config file", shell_output("#{bin}/flowrs config list")
  end
end
