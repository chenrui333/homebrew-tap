class Splitrail < Formula
  desc "Real-time token usage tracker and cost monitor for CLI coding agents"
  homepage "https://github.com/Piebald-AI/splitrail"
  url "https://github.com/Piebald-AI/splitrail/archive/refs/tags/v3.4.0.tar.gz"
  sha256 "98be592254bc1935d9e45b81fbf6e8d61bdde3b779717748e5977c59fa675a9f"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "b774ff9670a07740ac9bbe424f4ea222503f7e823d7842a973913b0aebefa891"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "93945d61e2435b0d279f8aaea20bd3acc98516175a7cbe9c39d0f9ecebf5fed4"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f025a23ec9301922415407767439b1c18768e6edc35e4d121f86500bae810187"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f5be87eca0f9e6156f3c2f8ba37b359dde01168375f1f404f1ee5cb6b92ad636"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "71d6b07411134f5b6f073c45ce4e95a5ff5e7dc14ce229eb9727f8839b4580c7"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/splitrail --version")
  end
end
