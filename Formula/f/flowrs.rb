class Flowrs < Formula
  desc "TUI application for Apache Airflow"
  homepage "https://github.com/jvanbuel/flowrs"
  url "https://github.com/jvanbuel/flowrs/archive/refs/tags/v0.1.17.tar.gz"
  sha256 "1eaa8b211562f1d7e2194fecb5c10f153e083c1fcee9048a9701918c9c7851cc"
  license "MIT"
  head "https://github.com/jvanbuel/flowrs.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "bafea6a755a962fca460ee9946034f5ca9392b7e0607adba1496e17f1af04f23"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "aab5fbddd2b5da9d9b4ab087d9db44757c8fab6659affa8b5bfb712520594cb9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "37e5651bb2ab629ecf723b2794951b5ffaf4afdec83deaa2afd985e696a8fed4"
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
