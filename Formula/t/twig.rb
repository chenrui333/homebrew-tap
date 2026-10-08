class Twig < Formula
  desc "Terminal-based JSON and YAML viewer for exploring large files"
  homepage "https://github.com/workdone0/twig"
  url "https://github.com/workdone0/twig/archive/refs/tags/v3.2.0.tar.gz"
  sha256 "91284428e805ed14e8fedc80adadd258c5641cb6d0aa97e63855891cb80f9a63"
  license "MIT"
  head "https://github.com/workdone0/twig.git", branch: "master"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "b7559b8cc9fed570ed22d13e5c04bd9b21d3bf72f99307ef881a05d5f4c66aae"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "dfc46c3d341527ea460ff737a6b74991234167cbb6095304fbaad85d33e1af01"
    sha256 cellar: :any,                 arm64_linux:   "a59a1bc92be495cb54fe91404ff9305ff59d328132cdca6839246de6ccbaf5f2"
    sha256 cellar: :any,                 x86_64_linux:  "79dd1556c0d4d3f346b9e132e31f7e6f8e532813bad7cb2c3fc35a29ad56fd8a"
  end

  depends_on "rust" => :build

  deny_network_access!

  def fetch
    system "cargo", "fetch", *std_cargo_fetch_args
  end

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    (testpath/"sample.json").write <<~JSON
      {"a":1}
    JSON

    assert_match version.to_s, shell_output("#{bin}/twig --version")
    output = shell_output("#{bin}/twig --print #{testpath}/sample.json")
    assert_match '"a": 1', output
  end
end
