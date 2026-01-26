class Flowrs < Formula
  desc "TUI application for Apache Airflow"
  homepage "https://github.com/jvanbuel/flowrs"
  url "https://github.com/jvanbuel/flowrs/archive/refs/tags/v0.8.3.tar.gz"
  sha256 "c57226c17b48cc6c3aa2024e5f9fe032660a84bec851a89b4280e01ba1842263"
  license "MIT"
  head "https://github.com/jvanbuel/flowrs.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "ce8153d8ac68d7cf19c18b1ed2a92a0128168c7d114ec7222dd98eba7930c7be"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "62d239a74165167e7993c7369b68b7d916395503f8d79a6b48dc4e5010f9d76f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e5576ab8459d1672a25e137e9854687e5c427776a13512fe63f5d180df021c13"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "2fe114b302db0f43eff707243fd00985c458f29b89a0a8a27796e85716cc7103"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "dbe38c6f833257be7263e81d2c127080081bcdd93dfbdaccc47106aa7e6322ed"
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
