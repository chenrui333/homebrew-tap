class Resinator < Formula
  desc "Windows resource-definition script (.rc) to resource file (.res) compiler"
  homepage "https://github.com/squeek502/resinator"
  url "https://github.com/squeek502/resinator/archive/2b0a8449bbafb3f1bc18f290dc605b2100301b2e.tar.gz"
  version "0.1.0" # 2b0a844 is prior to v0.1.0 tag, f933361
  sha256 "676d20dc2ae9f706e332e6b243390ca920a77c82803f3515c872806489aef9e1"
  license "0BSD"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "64c3c4f52fdedc47b649da2bef6e6bebe177bb97d1b44c46c2174c29d7f39af8"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "8a396be297b964fe189f1453add63bc7676d94692cd540c6cbe9287b0ec0e7a2"
    sha256 cellar: :any_skip_relocation, ventura:       "619ac31e36e4e4a5dbe788e46eb4848dd761b487f5e3fcdd23522fd3bec4265b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9e56b093ae3feebe468667f12e7ceaf293b05efb646c0dbd1b8b6cae81c26c7c"
  end

  depends_on "zig" => :build

  def install
    # Fix illegal instruction errors when using bottles on older CPUs.
    # https://github.com/Homebrew/homebrew-core/issues/92282
    cpu = case Hardware.oldest_cpu
    when :arm_vortex_tempest then "apple_m1" # See `zig targets`.
    else Hardware.oldest_cpu
    end

    args = %W[
      --prefix #{prefix}
      -Doptimize=ReleaseSafe
    ]

    args << "-Dcpu=#{cpu}" if build.bottle?

    system "zig", "build", *args
  end

  test do
    (testpath/"test.rc").write <<~EOS
      #include <winver.h>

      // The numeric portion here is a "Version resource" with
      // typical fields like FileVersion, ProductVersion, etc.
      1 VERSIONINFO
      FILEVERSION 1,0,0,0
      PRODUCTVERSION 1,0,0,0
      FILEFLAGSMASK 0x3fL
      #ifdef _DEBUG
      FILEFLAGS 0x1L
      #else
      FILEFLAGS 0x0L
      #endif
      FILEOS 0x40004L
      FILETYPE 0x1L
      {
          BLOCK "StringFileInfo"
          {
              BLOCK "040904b0"
              {
                  VALUE "FileDescription", "Test Program\\0"
                  VALUE "FileVersion", "1.0.0.0\\0"
              }
          }
          BLOCK "VarFileInfo"
          {
              VALUE "Translation", 0x409, 1200
          }
      }

      // A simple string resource in string table block 1
      // Each block has up to 16 strings, so ID 1 is string #1 in block 1
      STRINGTABLE
      BEGIN
          1, "Hello from resource string 1"
          2, "Another test string"
      END
    EOS

    system bin/"resinator", "/fo", "test.res", "test.rc"
    assert_path_exists testpath/"test.res"
  end
end
