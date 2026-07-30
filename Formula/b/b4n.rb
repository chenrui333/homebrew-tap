class B4n < Formula
  desc "Terminal user interface (TUI) for Kubernetes API"
  homepage "https://github.com/fioletoven/b4n"
  url "https://github.com/fioletoven/b4n/archive/refs/tags/v0.5.4.tar.gz"
  sha256 "111b807b2c7cd5fef9ec355b129fc251b3dd000b284dc4d315244a59d46c29fb"
  license "MIT"
  head "https://github.com/fioletoven/b4n.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "a55d2b79d4ac3fa175dae7615c7159af1c187e3e04d461258f6d5cc77f75bd3f"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "58e40563aa6d51d6685dfcc96ab6b9e1bc9f35604e2d9056a0ded5c7951aed93"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "1fe18c10f4208313ddb26b04f7e9453dcd4badd7ef3228a93481f1bff0da58f7"
    sha256 cellar: :any,                 arm64_linux:   "edb1ecb448727c2138cb9c97d5c352a89764aff23580e6d9e672e96c32c3dcfa"
    sha256 cellar: :any,                 x86_64_linux:  "e8f45d410ec43b95eab6e900b448cd9e0373265f9d2ff8b491a5ec94f99ebeb5"
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
