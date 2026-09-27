class Kudu < Formula
  desc "Manage QEMU virtual machines in the terminal"
  homepage "https://github.com/pythops/kudu"
  url "https://github.com/pythops/kudu/archive/refs/tags/v0.4.0.tar.gz"
  sha256 "fa5e808018cbec10e3bfabd6f4dcac86276641bacb79c8c51868cd703b9619e7"
  license "GPL-3.0-or-later"
  head "https://github.com/pythops/kudu.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any, arm64_linux:  "689e851cf8b5ed295392da23fea507358cd25fca98920e9b93e3d3ef1fc70abd"
    sha256 cellar: :any, x86_64_linux: "737b166f1258a10a28f029e68aad86ecfd63b9a0ad22af0b6f2aa0813927da05"
  end

  depends_on "rust" => :build
  depends_on :linux
  depends_on "qemu"

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/kudu --version")
    output = shell_output("#{bin}/kudu --invalid-option 2>&1", 2)
    assert_match "unexpected argument '--invalid-option'", output
  end
end
