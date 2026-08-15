class Netwatch < Formula
  desc "Real time network diagnostics in your terminal"
  homepage "https://github.com/matthart1983/netwatch"
  url "https://github.com/matthart1983/netwatch/archive/refs/tags/v0.29.1.tar.gz"
  sha256 "0490e129af6820b5b7be24e662efc660a1d5aab9f7d00c383b8ab1ff26b032a5"
  license "MIT"
  head "https://github.com/matthart1983/netwatch.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "b520da37dbf3ee19a00b4e7b95ecef52a58dd4dd1ed73b32a37310a55eae1e9b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e8d339535543343eaab109ccd17f7eff2add6854a8340acd2e73e61618dc6ff3"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "77dd590c6309d934943fa246c8d942dbc12aeb9b0d7b3210f211d56eb7d528d3"
    sha256 cellar: :any,                 arm64_linux:   "cbf92e5ece40d2097b28cbacf8610fdfd38cc99d7de879b621edc91b8ccb1d2e"
    sha256 cellar: :any,                 x86_64_linux:  "d3b970f793c3ecb70ad5bb9c16ff0f32944cc506f531f141a11ed4a8dfdc7a00"
  end

  depends_on "rust" => :build
  uses_from_macos "libpcap"

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/netwatch --version")

    output = shell_output("#{bin}/netwatch --generate-config")
    assert_match "Config written to", output
  end
end
