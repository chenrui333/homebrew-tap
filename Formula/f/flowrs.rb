class Flowrs < Formula
  desc "TUI application for Apache Airflow"
  homepage "https://github.com/jvanbuel/flowrs"
  url "https://github.com/jvanbuel/flowrs/archive/refs/tags/v0.8.4.tar.gz"
  sha256 "74211a556e7fa97a2d83acd6edf1d5ca32a1b247b35536dcac8552515dd8e270"
  license "MIT"
  head "https://github.com/jvanbuel/flowrs.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "189baa94da18a00843e06caafb378cec1c0eb2a607346d7ec4b509410f5114e6"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "23d5fb02a91f982161fa66d2923cb6d16ba8a59b8a8b213ad5f823d1930d8c55"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "2c33d5935435a38fe40d4ee009a386a5f165541e2572db3e3fbefde44fe2f8c4"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c6564e642a5fcec2e4dd1543c980c94208fbfeb40e3da97e5479fef9bfd6f09e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "30e010624b23ee8058821766a20a80b06356488a942169b2fa354cde46fc1da3"
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
