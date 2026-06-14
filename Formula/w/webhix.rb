class Webhix < Formula
  desc "Self-hosted webhook inspector with single binary and SQLite"
  homepage "https://github.com/GaIsBax/Webhix"
  url "https://github.com/GaIsBax/Webhix/archive/refs/tags/v0.1.1.tar.gz"
  sha256 "f54e48d03b2ee783b5659766f3b069aad432afa1faa6370a62b13d0ae3299bcc"
  license "AGPL-3.0-only"
  head "https://github.com/GaIsBax/Webhix.git", branch: "main"

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args, "./cmd/webhix"
  end

  test do
    assert_match "webhix", shell_output("#{bin}/webhix --help 2>&1")
  end
end
