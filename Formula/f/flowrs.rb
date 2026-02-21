class Flowrs < Formula
  desc "TUI application for Apache Airflow"
  homepage "https://github.com/jvanbuel/flowrs"
  url "https://github.com/jvanbuel/flowrs/archive/refs/tags/v0.9.2.tar.gz"
  sha256 "ec7a1bc580d3e647e054b59e6c2b8356114fdc30c7d407813f98432735940f52"
  license "MIT"
  head "https://github.com/jvanbuel/flowrs.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "c820a5a8215aaa1dae15c429d6a2a82d505b07cc8d8a4378951721bd920b82fc"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ff09ab3fa5f43fd26090c02e6050232dd3f3b114f4d485fc9d402b35d08f3b8e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "750f8c100277322b4adf5cb3e308d23cc6b45c2d2e6ea87fb4c00969403f7d44"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "878189a02af48173ef4c7e4b9e9eb2e6926f2f55dac10acb62158754998d2ab4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b309d41b24c0d902f8547c07546da9614f0b1c011d033420c671a0a235439636"
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
