class Splitrail < Formula
  desc "Real-time token usage tracker and cost monitor for CLI coding agents"
  homepage "https://splitrail.dev/"
  url "https://github.com/Piebald-AI/splitrail/archive/refs/tags/v3.7.1.tar.gz"
  sha256 "e0cd15d78e38f7813edab999ce7cfc7f7dcc3c89c582dd3d39c387e273c542f9"
  license "MIT"
  head "https://github.com/Piebald-AI/splitrail.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "06ba2b1b04b3191d34cf51311ab9d9e2c5493b92c5282de7964cafbbf9b1ef59"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a36dba3e84d48c820dfe7c00faf16c63952e29a30baa60118c7bb3f79c599399"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "9135e30a7f2907356b6550101e7eb46a359db0e9928b9852978e0d13b10fce60"
    sha256 cellar: :any,                 arm64_linux:   "1b63e171a6bb89b4f7259905611b0920b327caeef5f73239042941a88db95294"
    sha256 cellar: :any,                 x86_64_linux:  "abb6764f87c896c290c1f25079e784e061348b44a730765018ac89b32d306bff"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/splitrail --version")

    output = shell_output("#{bin}/splitrail config init")
    assert_match "Created default configuration file", output
    assert_match "[server]", (testpath/".splitrail.toml").read
  end
end
