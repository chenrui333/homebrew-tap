class Ingero < Formula
  desc "GPU causal observability agent using eBPF"
  homepage "https://github.com/ingero-io/ingero"
  url "https://github.com/ingero-io/ingero/archive/refs/tags/v0.19.0.tar.gz"
  sha256 "ae14cd73e8728b1c821973ff763655e5a8800933d484a4ea2fdba136996398f0"
  license "Apache-2.0"
  head "https://github.com/ingero-io/ingero.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_linux:  "1fb37bb2db06c15c3efd62b71e6ee596b72d93b09de37bdbf90e202f3d5d653e"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "2c3d9ef1f4ab34b36c9edc20eeabccb51f290b02fabfdc2a201479aa119553de"
  end

  depends_on "go" => :build
  depends_on :linux

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w"), "./cmd/ingero"
  end

  test do
    assert_match "ingero", shell_output("#{bin}/ingero --help 2>&1").downcase
  end
end
