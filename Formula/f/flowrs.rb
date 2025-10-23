class Flowrs < Formula
  desc "TUI application for Apache Airflow"
  homepage "https://github.com/jvanbuel/flowrs"
  url "https://github.com/jvanbuel/flowrs/archive/refs/tags/v0.4.2.tar.gz"
  sha256 "486db5669c5c6d5fc9831f4bb98f0e1e0e277a77ac33a47013bdb8f910596a78"
  license "MIT"
  head "https://github.com/jvanbuel/flowrs.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "ca9f34d48da5f4e61f030f9e9b86474312bc0c0d290cace00f269f1c6026de19"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "16fdb4c1211223aee9ff966e7ca64b3b2eb471d8202a20abdea14f577d746b85"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "3ba3560b1ae3826b018f462c6d20f181caae02a881744dce0f55ac943af46449"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "526fa670ca1cc3dfa2a2e01fab3ab2fa75794e3e34c0dfe77bca9d404955891d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c19f1daa556d0693d891be98a23aaa5b65e5e9f10dc00331a71a0c6058d0f220"
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
