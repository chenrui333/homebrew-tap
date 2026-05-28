class Netwatch < Formula
  desc "Real time network diagnostics in your terminal"
  homepage "https://github.com/matthart1983/netwatch"
  url "https://github.com/matthart1983/netwatch/archive/refs/tags/v0.23.0.tar.gz"
  sha256 "f6279c1121830ae7c22c2b134e632b0edd53ab3c70c205a9614d810a410f9ed6"
  license "MIT"
  head "https://github.com/matthart1983/netwatch.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "7c72310c4550a6808ec1b4507a7a0fe1c7b8b857ec56db7c07b15a188a4ea8c1"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "18ddfe1b8e9c83d19f70fbc0159532c45e30fbb9c5a521dfa6121878efebadbc"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e51658e209cf68d3b546b499d057205d51ed4d3258075d4557d9ee3b8b989bd1"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a98f8f74531e975ef093af43c29861ccb811da48374b101174a29236c9098488"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4c3b8bdd5a1352e289b40322ab11d8af809f7747302ac9c694d2956daba39d9b"
  end

  depends_on "rust" => :build
  uses_from_macos "libpcap"

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match "netwatch", shell_output("#{bin}/netwatch --help 2>&1")
  end
end
