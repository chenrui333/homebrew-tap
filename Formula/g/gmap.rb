class Gmap < Formula
  desc "CLI for visualizing Git activity"
  homepage "https://github.com/seeyebe/gmap"
  url "https://github.com/seeyebe/gmap/archive/refs/tags/v0.4.0.tar.gz"
  sha256 "d602fb26a72188b58446b9f4612ed723c4d6d4dd7a633f6c19ff37a21149c032"
  license "MIT"
  head "https://github.com/seeyebe/gmap.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "e22ef58fd2c54c9e68d236d7b9f6dde41dffda14d03a08865b8f53cbaf3ab829"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e40d1c56a8c07b5b5aca2616f3ddbc56c37e968b79efcca0beaeb938e47109e3"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b90d8f5470267dcca33c7c558099a34d26b7b9727c28d32ee0aa3214102b0cda"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e88154497c83e7104941f59056969eb8b07dbe6244a98f26749818e851e2377c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "716eddd0e5998e953a19af270de114e0d1ef02f9f2d1b61d4ae98ec926a42869"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/gmap --version")

    system "git", "init", "--initial-branch=main"
    system "git", "commit", "--allow-empty", "-m", "initial commit", "--quiet"
    assert_match "Commit Activity Heatmap", shell_output("#{bin}/gmap heat")
  end
end
