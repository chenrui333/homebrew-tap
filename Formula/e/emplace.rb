class Emplace < Formula
  desc "Synchronize installed packages on multiple machines"
  homepage "https://codeberg.org/fosk/emplace"
  url "https://codeberg.org/fosk/emplace/archive/v1.6.0.tar.gz"
  sha256 "cf40269689b5b683fdad2dafb401ebf3eff43e4f6dab113849a3d28563c39d00"
  license "AGPL-3.0-or-later"
  head "https://codeberg.org/fosk/emplace.git", branch: "master"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "802929028d37d8523a97f1849b7da36bc546d2d10ef7633801c81b3ab2ef90e5"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "820ac3211dce211f7e64c931338caa4f9d430cdcb247e95add2fe449b55158c0"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ea8d6f53c28fdb3a81d08de9725af01727db1eecf96f07126b9488ad83ada678"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "01c2cfcc4a7683c88a5741ae1a6931869a342a2bdf955c28eef9250bdc4e0684"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "638cbef047e91e47735fdde183695d7874ca6895fb2a3ba0498f9e8602a1160e"
  end

  depends_on "rust" => :build

  # time crate patch for rust 1.80+, upstream pr ref, https://codeberg.org/fosk/emplace/pull/397
  patch do
    url "https://codeberg.org/fosk/emplace/commit/ea39f5826f6d0501aa3073f620b8a764900d3dc5.patch?full_index=1"
    sha256 "2b040ef1b5cfb96aefa8c17def110562dc4fa280c1e7fa764162c7d3568c6d30"
  end

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/emplace --version")

    output = shell_output("#{bin}/emplace config --path")
    assert_match "Your config path", output
  end
end
