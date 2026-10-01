class Hcom < Formula
  desc "Let AI agents message, watch, and spawn each other across terminals"
  homepage "https://github.com/aannoo/hcom"
  url "https://github.com/aannoo/hcom/archive/refs/tags/v0.7.27.tar.gz"
  sha256 "bfc619bac91faa6efeb7d09ac9e2eac2f073b58a107c25c7018c6e19fb5f52e3"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "8ef0ced8fcac96d3344b9c6617067587d62ffd57ea1e08282f74d62ebe444b68"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "33335a26687286ee62f9bb9d5e4ad4093d1129c309f26190a6152498104a28f7"
    sha256 cellar: :any,                 arm64_linux:   "c925c4fb7575de1d8a37db58edda59d1ebab672916ccb4057c2b94d660690fb5"
    sha256 cellar: :any,                 x86_64_linux:  "1a974db5fb6ec30083ad145c29b4a24f970b84bf2e8860c7247a108662f9fe8f"
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
