class FairygladeLy < Formula
  desc "TUI (ncurses-like) display manager for Linux and BSD"
  homepage "https://codeberg.org/fairyglade/ly"
  url "https://github.com/fairyglade/ly/archive/refs/tags/v1.5.0.tar.gz"
  sha256 "b1f8f631ab5e9f44006e5f1ead1e971ad27a296e59fc0d7a79bcfe5718a8af72"
  license "WTFPL"
  head "https://codeberg.org/fairyglade/ly.git", branch: "master"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any, arm64_linux:  "59f37d187a5268a50d469e6a9a505f0a2232ee9573ab0ad25b535196371fda73"
    sha256 cellar: :any, x86_64_linux: "6d0545ca0d0983bca78f7c7c54ec23f46a7b84ecfeda5e685d72f27fe7cf1abd"
  end

  depends_on "pkgconf" => :build
  depends_on "zig" => :build
  depends_on "libxcb"
  depends_on :linux
  depends_on "linux-pam"

  deny_network_access!

  def fetch
    system "zig", "build", "--fetch=all"
  end

  def install
    # The C translator does not inherit the executable's Homebrew search prefixes.
    inreplace "ly-core/build.zig", "mod.addImport(name, pam.mod);", <<~ZIG
      pam.addSystemIncludePath(.{ .cwd_relative = "#{formula_opt_prefix("linux-pam")}/include" });
      pam.addSystemIncludePath(.{ .cwd_relative = "#{formula_opt_prefix("libxcb")}/include" });
      mod.addImport(name, pam.mod);
    ZIG

    args = %W[
      --search-prefix #{formula_opt_prefix("libxcb")}
      --search-prefix #{formula_opt_prefix("linux-pam")}
    ]

    system "zig", "build", *std_zig_args, *args
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/ly --version 2>&1")
    (testpath/"config.ini").write "animation = none\n"
    output = shell_output("#{bin}/ly --validate-config #{testpath}/config.ini 2>&1")
    assert_match "no errors detected!", output
  end
end
