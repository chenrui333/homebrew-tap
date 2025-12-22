class Ergo < Formula
  desc "Modern IRC server (daemon/ircd) written in Go"
  homepage "https://github.com/ergochat/ergo"
  url "https://github.com/ergochat/ergo/archive/refs/tags/v2.17.0.tar.gz"
  sha256 "bfda2be82aa133ddd7a03c2121d6807c8a1b9f5c055f0bbb90451baa2a249ce4"
  license "MIT"
  head "https://github.com/ergochat/ergo.git", branch: "master"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "12761dfc0b7b5cd82f7199d9735d1a3b8007c03da9867adf4dca9da751fc7aac"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "12761dfc0b7b5cd82f7199d9735d1a3b8007c03da9867adf4dca9da751fc7aac"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "12761dfc0b7b5cd82f7199d9735d1a3b8007c03da9867adf4dca9da751fc7aac"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "147f9980039958297ce0e6cb75bea46230895a64a5b59fc7707660e5f1bef981"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "fbdf0d7b72b7f65187430cd34e875c397c2bb500bdd0a74c27b2b32de959ed73"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/ergo --version")

    output = shell_output("#{bin}/ergo defaultconfig")
    assert_match "# This is the default config file for Ergo", output
  end
end
