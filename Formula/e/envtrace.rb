class Envtrace < Formula
  desc "Trace where environment variables are defined and modified"
  homepage "https://github.com/FlerAlex/envtrace"
  url "https://github.com/FlerAlex/envtrace/archive/refs/tags/v0.1.2.tar.gz"
  sha256 "7da761c64d8b2504687f0c67a0387dff6b39aba463dbf1f517510a38fb8686ac"
  license "MIT"
  head "https://github.com/FlerAlex/envtrace.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "58b8c77674b3fbc97953a87676476e7dbd7d816d4dd3b5509732b65f44c2d7d3"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a6a594bdf0b2967fc7976670d033c821a3d766252788387d455ff1a48c39da46"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "3053d185f659dd5e0f32d0620618694fbe0ba1f9434216b2a260c7e06096a01e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "0cc1834fe72f2294ce3a0556f5d16e80fb527e482660c0ee289fed7e3a431db4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "abc7f33047112d3160dffc4b457c620580d6a446f7cebf423e4cf9c14401357d"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/envtrace --version")
    assert_match "Environment Health Check", shell_output("#{bin}/envtrace --check")
  end
end
