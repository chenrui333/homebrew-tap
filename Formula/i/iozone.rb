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
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "b1f53e906a4b7b9efaeb7142e2a73bb0538c39b0ee149dc6c357f710bef7aaec"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "5b35096c90ea8ba077d22f354fc20f6e829550b482cf75c3e33853eb01c0766c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c982536f335c8e21f8c37208704c9318b8c1d742ed0da957a2d449b897aff651"
    sha256 cellar: :any_skip_relocation, sequoia:       "6f1c4570c2f7645b423b1a41f1d386fa68ed0b037c732165c644137d458219fc"
    sha256 cellar: :any,                 arm64_linux:   "381533bfe1153a2bcee569df1d86b17bfdfef863ae861268fc2956cec4985bc1"
    sha256 cellar: :any,                 x86_64_linux:  "63ae4c32408a3e83f95f02491b97aa890b33b5c24adeb8112e09d533a4fe236c"
  end

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
