class Bufisk < Formula
  desc "User-friendly launcher for Buf"
  homepage "https://github.com/bufbuild/bufisk"
  url "https://github.com/bufbuild/bufisk/archive/refs/tags/v0.1.0.tar.gz"
  sha256 "ad4ee8d36da378fb0ea492d291d50851d4b68dea1f30f9ad54633a7b24564ecf"
  license "Apache-2.0"
  head "https://github.com/bufbuild/bufisk.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "f1e25b3ff56e1eddfde2481dfc75e8e8fb859dbf500a71c2898359ae8204aecc"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f1e25b3ff56e1eddfde2481dfc75e8e8fb859dbf500a71c2898359ae8204aecc"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f1e25b3ff56e1eddfde2481dfc75e8e8fb859dbf500a71c2898359ae8204aecc"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "4fe40d1f34a89561b977a4ab8e535ed6c8b42842d317e78f4d193bc497654f80"
    sha256 cellar: :any,                 x86_64_linux:  "8380f66a80a8457fc54dbc7939074aba88bd1bd46cc57402c76adc99937a2357"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")
  end

  test do
    assert_match "BUF_VERSION not set", shell_output("#{bin}/bufisk 2>&1", 1)
    assert_match "invalid buf version", shell_output("BUF_VERSION=bad #{bin}/bufisk 2>&1", 1)
  end
end
