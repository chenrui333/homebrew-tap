class Iozone < Formula
  desc "File system benchmark tool"
  homepage "https://www.iozone.org/"
  url "https://www.iozone.org/src/current/iozone3_511.tgz"
  sha256 "1aa00bc3cd627ec46ca17aa78c8fabd143d32025155c741f49392b1bdd776298"
  license :cannot_represent

  livecheck do
    url "https://www.iozone.org/src/current/"
    regex(/href=.*?iozone[._-]?v?(\d+(?:[._]\d+)+)\.t/i)
    strategy :page_match do |page, regex|
      page.scan(regex).map { |match| match&.first&.tr("_", ".") }
    end
  end

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "7576cfc3ce7b5fe5431e30230c4437e6ad72aee947a28f64c099d6af84ee18e7"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "150d1651fdcd44e66db3bcce78bc9349a6967b5c697b7505e2d7b300b9f626ce"
    sha256 cellar: :any,                 arm64_linux:   "d102bb1e64337b62611e497a3788e793ae7af710a93f241694f55ecdb7555852"
    sha256 cellar: :any,                 x86_64_linux:  "3e25a9c059b39f6c42cdf395e4fd90508511f174f02e86bd66723c7912c5ae50"
  end

  deny_network_access!

  def install
    cd "src/current" do
      # GCC 15 no longer permits an implicit int declaration for pointer-returning functions.
      inreplace "libasync.c", "extern long long page_size;", <<~C
        struct cache;
        struct cache_ent;
        struct cache_ent *incache(struct cache *, long long, off64_t, long long);

        extern long long page_size;
      C

      target = OS.mac? ? "macosx" : OS.kernel_name.downcase
      system "make", "clean"
      system "make", target, "CC=#{ENV.cc}"
      bin.install "iozone"
      pkgshare.install %w[Generate_Graphs client_list gengnuplot.sh gnu3d.dem
                          gnuplot.dem gnuplotps.dem iozone_visualizer.pl
                          report.pl]
    end
    man1.install "docs/iozone.1"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/iozone -v")

    assert_match "File size set to 16384 kB",
      shell_output("#{bin}/iozone -I -s 16M")
  end
end
