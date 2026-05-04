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
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "3feceaef70cef3d3f54df2941c2b183ccf614cdf0015090d817486b352715b8c"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "cbf4dbb61c79b57ef9fd60755a62b2e6ed009ae4691bdeffed293e1b05f463fa"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "50661363548d642668fcbd471fcffc7f4c53f908af74a29392df0254a9e70a9b"
    sha256 cellar: :any_skip_relocation, sequoia:       "ca2fabb243c6c48585774d9d030571ba278fce7fd5a6f77e58fd9aa73933b37d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e1f31155b12dba8ee64007976cf71343a59e4cbca6fa621316180bfd5110434f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "350540b306667b67891a2b9a783b5c4fd5fb269edf7671be75c4eedd994733bc"
  end

  resource "testfile" do
    url "https://s3.amazonaws.com/ARJ/ARJ286.EXE"
    sha256 "e7823fe46fd971fe57e34eef3105fa365ded1cc4cc8295ca3240500f95841c1f"
  end

  def install
    system "make"
    bin.mkdir
    system "make", "install", "INSTALLDIR=#{bin}"
  end

  test do
    # Ensure that you can extract arj.exe from a sample self-extracting file
    resource("testfile").stage do
      system bin/"unarj", "e", "ARJ286.EXE"
      assert_path_exists Pathname.pwd/"arj.exe"
    end
  end
end
