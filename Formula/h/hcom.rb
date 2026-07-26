class Hcom < Formula
  desc "Let AI agents message, watch, and spawn each other across terminals"
  homepage "https://github.com/aannoo/hcom"
  url "https://github.com/aannoo/hcom/archive/refs/tags/v0.7.24.tar.gz"
  sha256 "9650301d4da1bcc1a55e79073c162d045457c9fb41d76eccda1f66280b7db932"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "bb883c5c3757af31bcb5ca00104043ba168c6266c9f19a69dec9ddc9b33205fb"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "88ecd6432e2a12e5d8f374461bfe4b8a770a61607255e7bb669ddc337f3608bd"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "eed65f66d363d8161c3d1c0f549e32205677ffd4af047b80883037b0625c376a"
    sha256 cellar: :any,                 arm64_linux:   "67e20d304a4cdc0d369b2b84e3b47da28ff1905d9bf8b6fdb25c93fb5b3c0096"
    sha256 cellar: :any,                 x86_64_linux:  "a03dac46eff1a6471da5bad4ee6737b2f28eb246feb94c11da42ae59e99ce42b"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/hcom --version")

    ENV["HCOM_DIR"] = testpath
    assert_match "Set:    hcom config terminal kitty", shell_output("#{bin}/hcom config terminal --info")
  end
end
