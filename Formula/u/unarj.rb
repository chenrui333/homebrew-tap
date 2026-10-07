class Unarj < Formula
  desc "ARJ file archiver"
  homepage "https://www.arjsoftware.com/files.htm"
  url "https://src.fedoraproject.org/repo/pkgs/unarj/unarj-2.65.tar.gz/c6fe45db1741f97155c7def322aa74aa/unarj-2.65.tar.gz"
  sha256 "d7dcc325160af6eb2956f5cb53a002edb2d833e4bb17846669f92ba0ce3f0264"
  license :cannot_represent

  livecheck do
    url "https://src.fedoraproject.org/repo/pkgs/unarj/"
    regex(/href=.*?unarj[._-]v?(\d+(?:\.\d+)+[a-z]?)\.t/i)
  end

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "5770d2315944b894ab7f2576251d9156d203d0db757dc81bac377d20c047227b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "52c3ac4e539cf7e3495b03abe3a8ae253a6712f747630a4cc46b4e939bf1e0ac"
    sha256 cellar: :any,                 arm64_linux:   "bb673349a745e452c20359162b6531055154e7feef66c4a459a094d42c6a28b6"
    sha256 cellar: :any,                 x86_64_linux:  "f05b012df01b649cd2e07c08df79f3764071efd7078a597bc1ef29f930470768"
  end

  deny_network_access!

  def install
    system "make"
    bin.mkdir
    system "make", "install", "INSTALLDIR=#{bin}"
  end

  test do
    # Extract a stored file from a small ARJ archive (main header + one file header).
    arj = %w[
      YOooAB4LAQIAAAIAAGwrWgAAAAAAAAAAAAAAAAAApAEAAHRlc3QuYXJqAADX+szjAABg6ikAHgsBAgAAAAAAbCtaCQAAAAkAAAC0
      96PUAACkAQAAaGVsbG8udHh0AAAp6W4fAABIb21lYnJldwpg6gAA
    ].join
    (testpath/"test.arj").binwrite arj.unpack1("m")
    assert_match "CRC OK", shell_output("#{bin}/unarj e test.arj")
    assert_equal "Homebrew\n", (testpath/"hello.txt").read
  end
end
