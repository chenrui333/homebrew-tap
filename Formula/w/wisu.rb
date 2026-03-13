class Wisu < Formula
  desc "Blazingly fast, minimalist directory tree viewer"
  homepage "https://github.com/sh1zen/wisu"
  url "https://github.com/sh1zen/wisu/archive/refs/tags/v0.1.6.tar.gz"
  sha256 "0331ebc1663c3fcc4c58992692b6dc952d8733d1d77efac71250bb2689925edd"
  license "Apache-2.0"
  head "https://github.com/sh1zen/wisu.git", branch: "master"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "00c84969576ce09b8b065c99e8509f1e39a732bb0c18abf871649b609a414f57"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "8ba6ac066b50f8dc710631ca0c81b84a3aa2bc399c77a54a1ef763a48af4d46f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "bb73a7d2fb35a196e69a96ea06d720223705ad8dff69c5a7772724c15912a2d0"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "951c12ad8ef4017963afd099ac47defe60f36f0d37008ad7c29aace310bf5bac"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f2316357db90384173dbfd8a73dc5d072fcede0a7174e75e92c8c6e6c7ff5f97"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match(/^wisu \d+\.\d+\.\d+$/, shell_output("#{bin}/wisu --version"))

    (testpath/"a.txt").write("a\n")
    output = shell_output("#{bin}/wisu #{testpath}")
    assert_match "a.txt", output
  end
end
