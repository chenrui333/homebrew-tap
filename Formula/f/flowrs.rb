class Flowrs < Formula
  desc "TUI application for Apache Airflow"
  homepage "https://github.com/jvanbuel/flowrs"
  url "https://github.com/jvanbuel/flowrs/archive/refs/tags/v0.2.0.tar.gz"
  sha256 "3a082a5e63842e3435c410440ad09a411726f2488ad9cc93ab6e85cd53371ccd"
  license "MIT"
  head "https://github.com/jvanbuel/flowrs.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "36b6201338cea00c06ace4125f0789b3b32002ccac47c0613d601d2f0e10dbd1"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d94ceaa7e3b49c5af8603e35a6fe41bc0f895808ddbb68146e67dc3e51f8f5dc"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "fe6353be16913c5accd1b6747a60b379f6581959a088b60da1941cf247f655a3"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "69af01f41d9adc81d211cb0235f7c149de4b934ac0016ac6b71cf1fe3778733e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7844861cbdacaf2b9987e9b2654b404205c680d3a77a04670552147d4100b71c"
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
