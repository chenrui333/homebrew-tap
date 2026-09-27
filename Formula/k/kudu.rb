class Kudu < Formula
  desc "Manage QEMU virtual machines in the terminal"
  homepage "https://github.com/pythops/kudu"
  url "https://github.com/pythops/kudu/archive/refs/tags/v0.4.0.tar.gz"
  sha256 "fa5e808018cbec10e3bfabd6f4dcac86276641bacb79c8c51868cd703b9619e7"
  license "GPL-3.0-or-later"
  head "https://github.com/pythops/kudu.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any, arm64_linux:  "6823428db46f3e9519bac5a42a8e92c50018d9301e5c6a83004666f8a4730c52"
    sha256 cellar: :any, x86_64_linux: "e4a2923d73db42e3d77fdecfce90c222aae98f4d57910843528d05755d22a05e"
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
