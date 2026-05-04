class Iozone < Formula
  desc "File system benchmark tool"
  homepage "https://www.iozone.org/"
  url "https://www.iozone.org/src/current/iozone3_494.tgz"
  sha256 "a36d43831e2829dbc9dc3d5a5a7eb1ca733c9ecc8cbb634022a52928e9b78662"
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
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "e513e62e909eb53493e3a083245acc33e438d33fc6f555a5ec51e34bbb997abe"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "7b88d6c6ffc786e36008eba18ebb8079d1e5da940fe809b60c9a9aa9e0149fa1"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "5672c0656860d804a4505c200d93f1ba237727a8249e9c1ce56f463a56bfa7a9"
    sha256 cellar: :any_skip_relocation, sequoia:       "b1264a3ecb9a3d0e1277c571947868709a5f28a4c4da921974e7371bdfadc2c2"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "5a9631d16476814aa01fad26179372862da693118855787587334448f825a2ca"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e117e0a2430e6577fbf41843707e79b7aa470efe8a4a5054438ccffbdad859cd"
  end

  def install
    cd "src/current" do
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
    assert_match "File size set to 16384 kB",
      shell_output("#{bin}/iozone -I -s 16M")
  end
end
