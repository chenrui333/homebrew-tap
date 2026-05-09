class Hcom < Formula
  desc "Let AI agents message, watch, and spawn each other across terminals"
  homepage "https://github.com/aannoo/hcom"
  url "https://github.com/aannoo/hcom/archive/refs/tags/v0.7.16.tar.gz"
  sha256 "4b359ffa94e844881d46c722d3f0bbcdb95c462998a9576e01d6d81b99e2bb78"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "e9dd94db05d9dec3869e4678f127ca2221fa73848b02f1df735e7f326815a29f"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "0edc67eec2dd87df0d4098eae87d20e3951aa768b616ebbd10bb3aaa324bfb42"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ef6871b363106472445c40d7116b9d4366c78c6a5a6b40ee674a0582357d144d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "15f2c0a201cab501350e762f03f89bf3cf6f6f731fb479777942c82c36fb5193"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "331f645829d409a33244ef6493bd7d3333bf820368c16ee2b7007d4710c558ed"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/hcom --version")
  end
end
