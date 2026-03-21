class Weathr < Formula
  desc "Terminal weather app with ASCII animation"
  homepage "https://github.com/Veirt/weathr"
  url "https://github.com/Veirt/weathr/archive/refs/tags/v1.4.0.tar.gz"
  sha256 "aa940326f41b23db192165f831567656ea50eb73c971519cbc83adc6d3a21908"
  license "GPL-3.0-or-later"
  head "https://github.com/Veirt/weathr.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "f20469608642ba7bda847a3f92ce29675849943f4b7055315b4c1cb6777d2437"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "6318f053106e8aaf0a49eabef8fd99deeb490d1cb59f2df3b8783d0779b214ab"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "6378d33d974b4fb76fa982cf16319853a892439a08f738d3e3a946aea0e40f8b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "6767cdfb886b4d586c3989bd41c9dc73021c3c97d13a3ac28860e973acd64749"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "38fec570d8febb808b088fafd2563d801918a5db4c64b497b04275e72f6477fc"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
    generate_completions_from_executable(bin/"weathr", "--completions")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/weathr --version")
    assert_match "_weathr()", shell_output("#{bin}/weathr --completions bash")
  end
end
