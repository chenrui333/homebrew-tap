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
