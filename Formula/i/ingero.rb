class Ingero < Formula
  desc "GPU causal observability agent using eBPF"
  homepage "https://pkg.go.dev/github.com/ingero-io/ingero"
  # The GitHub repository was removed; the Go module proxy still serves the v0.19.0 source
  url "https://proxy.golang.org/github.com/ingero-io/ingero/@v/v0.19.0.zip"
  sha256 "54c4c81dde4a2a26b7f128821af0e6ce6fe01409386187945440b6f2ede3875d"
  license "Apache-2.0"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_linux:  "1fb37bb2db06c15c3efd62b71e6ee596b72d93b09de37bdbf90e202f3d5d653e"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "2c3d9ef1f4ab34b36c9edc20eeabccb51f290b02fabfdc2a201479aa119553de"
  end

  deprecate! date: "2026-10-04", because: :repo_removed

  depends_on "go" => :build
  depends_on :linux

  deny_network_access!

  def fetch
    cd "ingero-io/ingero@v#{version}" do
      system "go", "mod", "download"
    end
  end

  def install
    cd "ingero-io/ingero@v#{version}" do
      system "go", "build", *std_go_args(ldflags: "-s -w"), "./cmd/ingero"
    end
  end

  test do
    assert_match "ingero", shell_output("#{bin}/ingero --help 2>&1").downcase
  end
end
