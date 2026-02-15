class B4n < Formula
  desc "Terminal user interface (TUI) for Kubernetes API"
  homepage "https://github.com/fioletoven/b4n"
  url "https://github.com/fioletoven/b4n/archive/refs/tags/v0.4.2.tar.gz"
  sha256 "649075031dcae069ad962214360a6a59738dfb057fe122bfb79860be4d3bf272"
  license "MIT"
  head "https://github.com/fioletoven/b4n.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "79a600bee769e546968d1164a5bc49c769c994d01b055dfcc27c21a187bca280"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "456f9d8c5f801b473cf53637a03eb7190131daff4c5ab55cb076763716ce0bca"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a00d24df7346111827611d04766139e0b510e7e597fd79128a1f2ffb23e20f09"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "877689d3b2dc9b9d55e49b4048a8062c99394374955cbc83747773f7d116bf32"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8f6934de01cc5095dbd8cdfb1798b02877447af619698a05b982918e25dfe15c"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/b4n --version")
    assert_match "Error: kube config file not found", shell_output("#{bin}/b4n 2>&1", 1)
  end
end
