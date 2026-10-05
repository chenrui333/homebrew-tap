class Ingero < Formula
  desc "GPU causal observability agent using eBPF"
  homepage "https://pkg.go.dev/github.com/ingero-io/ingero"
  # The GitHub repository was removed; the Go module proxy still serves the v0.19.0 source
  url "https://proxy.golang.org/github.com/ingero-io/ingero/@v/v0.19.0.zip"
  sha256 "54c4c81dde4a2a26b7f128821af0e6ce6fe01409386187945440b6f2ede3875d"
  license "Apache-2.0"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_linux:  "500c2c893dd78446af2b15fb843c4a5ff8429e28fc97b22bb7aa8d4cc50ad251"
    sha256 cellar: :any,                 x86_64_linux: "068b62c52160a148de690c7694f4c336a197f93f0a684a2313de13f4a8c6d464"
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
