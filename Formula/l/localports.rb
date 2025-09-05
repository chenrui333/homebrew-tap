class Localports < Formula
  desc "List network ports with their associated binaries"
  homepage "https://github.com/diegoholiveira/localports"
  url "https://github.com/diegoholiveira/localports/archive/refs/tags/v0.1.0.tar.gz"
  sha256 "3150d5b411db846822074ab0ff87a580e8679752986cf028e8da162d12245be5"
  license "MIT"
  head "https://github.com/diegoholiveira/localports.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "8ef1eb58fd4325733756b6285cdfce8cf5022224a97afabbeb917364aac10ae3"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "9bd99fdf4c544ff6c59f9ad4c492a9be4a1032619ec651afaddeab1856d060a9"
    sha256 cellar: :any_skip_relocation, ventura:       "e5d6f219999e0b342c0cfa8730bce8e9b5ff8d17fbd154db2026a131d9b8edf8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "976f51a110cb8d58183169be8239b1e513c757e8adecc503e73c6421b49d1838"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    system bin/"localports"
  end
end
