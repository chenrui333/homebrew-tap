class Vtcode < Formula
  desc "CLI Semantic Coding Agent"
  homepage "https://github.com/vinhnx/vtcode"
  url "https://static.crates.io/crates/vtcode/vtcode-0.34.0.crate"
  sha256 "609c9fd2a73a4c94fd05b458e83e7441de67cea9efe96adeb2e76527b16f4450"
  license "MIT"
  head "https://github.com/vinhnx/vtcode.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "b9a12993033f1cfdb38b935bae9c9c2c1d4eb231773b83e6a81a64d0ab024950"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f5b199c599ff9640df72af647300474c43beac57c8f4ddb37d5aa39b6dc341c4"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f1c3bc9e7d20d02a275086b1bcdd62e176d5a18741ad8bc94b64c85dad3d21bb"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c73282bd67ff98cb4d9f6a77d61da97458fb7e9625a88b250744317452c7f603"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6a907dda7476817a9417c5e1323a3eca15d8f227f5a59dbf8fc3b017c4650f96"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build

  on_linux do
    depends_on "openssl@3"
  end

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/vtcode --version")

    output = shell_output("#{bin}/vtcode init 2>&1", 1)
    assert_match "No API key found for OpenAI provider", output
  end
end
