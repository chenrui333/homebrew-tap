class Darya < Formula
  desc "Disk usage explorer with a TUI and live treemap"
  homepage "https://github.com/mrkatebzadeh/darya"
  url "https://github.com/mrkatebzadeh/darya/archive/refs/tags/v0.1.5.tar.gz"
  sha256 "dea36d2b7cc41e7ae7b9c9bff19e34d3043f540832f8b2e61950cb4c6e17f9dc"
  license "GPL-3.0-only"
  head "https://github.com/mrkatebzadeh/darya.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "8d9d0ba58336dac72870dfe0f126b2972f0b08a85e79e448d34204002f3851b2"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f60238714bc6d1eab43bf7e6ef96856402a22565a40b0c2ca798835685e0a051"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a3c110460eb9e3fbdc393d26ea5f092556b7e0f37e125dab778e6742314cd9e1"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ad9f9ea64158d3c41ea1e88ecefa2ea562f5bec3adfe0d4566cadd1ca7786a66"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e95664a6400796a88ccd038a50e4df394b7ee01891279ddc1b641d95afbab7f0"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/darya --version")
  end
end
