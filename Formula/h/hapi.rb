class Hapi < Formula
  desc "Agentic coding - access coding agent anywhere"
  homepage "https://github.com/tiann/hapi"
  url "https://registry.npmjs.org/@twsxtd/hapi/-/hapi-0.3.0.tgz"
  sha256 "207b45c6cf10372c3e3ac8106c1ed294cdfcffbfbdd61b7ac68c871a9d4fa9e5"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256                               arm64_tahoe:   "468ac54b9bb80f8c400cfd1ce66c97c3a635766abe1207d0634148989ae3fab8"
    sha256                               arm64_sequoia: "468ac54b9bb80f8c400cfd1ce66c97c3a635766abe1207d0634148989ae3fab8"
    sha256                               arm64_sonoma:  "468ac54b9bb80f8c400cfd1ce66c97c3a635766abe1207d0634148989ae3fab8"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d905527aa46f8d2a58228e5b844ca7f11065ed33e58c65860fc6856a27453637"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "28ca04f102d7d7385d2e19e700616829b17ff9cebe87c0aa9473a6383be1faa3"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink libexec.glob("bin/*")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/hapi --version")
    assert_match "📋 Basic Information", shell_output("#{bin}/hapi doctor")
  end
end
