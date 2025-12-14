class Flowrs < Formula
  desc "TUI application for Apache Airflow"
  homepage "https://github.com/jvanbuel/flowrs"
  url "https://github.com/jvanbuel/flowrs/archive/refs/tags/v0.7.1.tar.gz"
  sha256 "24684ba7d81aedbc4d8b4928ce17db92b6fcb86c6f9d47397147aa3620b53f7b"
  license "MIT"
  head "https://github.com/jvanbuel/flowrs.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "22608efce5a79fb5d7ac1498f0fc2ae3370d02ab3171dc570f2a4108bd643f21"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "2f5bb4f888b739805416fa0160db699d66f95285d487581df0f50d7219a5300c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "32cca56a7d58d390bfbc6e5d098a89fb15e50b2648a9b0f68e465a32314288e2"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "4b38bc5aeac9be4546211d1abba5e89637742c2f724860eb3acb44dbee14d4f2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e1be7980b8650fcf102ca0a656647537b8b8218c2731da36f0f879ea2d464231"
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
