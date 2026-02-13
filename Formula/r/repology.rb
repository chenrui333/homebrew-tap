class Repology < Formula
  desc "Command-line interface for Repology.org"
  homepage "https://github.com/ibara/repology"
  url "https://github.com/ibara/repology/releases/download/v1.9.0/repology-1.9.0.tar.gz"
  sha256 "ed07a54b380522e2c28d70a92ae41dc2a0402bcf46d92a2adf4c19ebb9773f5e"
  license "ISC"
  head "https://github.com/ibara/repology.git", branch: "main"

  depends_on "ldc" => :build

  def install
    system "./configure", "--prefix=#{prefix}", "--mandir=#{man}"
    system "make"

    bin.install "repology"
    man1.install "repology.1"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/repology --version", 1)
  end
end
