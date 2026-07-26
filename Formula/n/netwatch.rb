class Netwatch < Formula
  desc "Real time network diagnostics in your terminal"
  homepage "https://github.com/matthart1983/netwatch"
  url "https://github.com/matthart1983/netwatch/archive/refs/tags/v0.27.0.tar.gz"
  sha256 "fd2f094a06e13aea0e79c28da1c5dd9386859a2988e13aa783e2fe4e7a32489f"
  license "MIT"
  head "https://github.com/matthart1983/netwatch.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "2d542ee9a8f2052ce2809fe31dd3bfb2df53c7e0ee006b054ae3f915ffde134c"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e24fcdf75c5de2fc3374ffa6837ebbce0d5c74fd9ddf8602e8bded1f1e52231e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "97159f5f78cdee0091ec4f600c1452606a003d8769d40a4ecf7f69fd4879a9c2"
    sha256 cellar: :any,                 arm64_linux:   "b21430b66066ec18abfead9bdfb6955d14f88a5f7fa5eef374f7ab899a069a77"
    sha256 cellar: :any,                 x86_64_linux:  "1c690f6bdff7c325a626255ba768a49425ec0706e5424768627f3540f43ba383"
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
