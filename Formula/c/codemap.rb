class Codemap < Formula
  desc "Generate a brain map of a codebase for LLM context"
  homepage "https://github.com/JordanCoin/codemap"
  url "https://github.com/JordanCoin/codemap/archive/refs/tags/v4.5.2.tar.gz"
  sha256 "6354f6d4f4a9357bd5881e8f884888dffbbc822c7c4d3593654aa831856084a4"
  license "MIT"
  head "https://github.com/JordanCoin/codemap.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "8e4000c3c2277531b08798e98db9078eaecf01c0c4b9fac44f1455d5e24df34f"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "8e4000c3c2277531b08798e98db9078eaecf01c0c4b9fac44f1455d5e24df34f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "03d4250adf3331f82ec2af45dd3ce666366b27499bf57c19535d63f46ed01703"
    sha256 cellar: :any,                 x86_64_linux:  "a4e7e99aa87952fa005f08013b58280bdbe493c5c29ea05463e58a78d67e519d"
  end

  depends_on "go" => :build

  deny_network_access!

  def fetch
    system "go", "mod", "download"
  end

  def install
    system "go", "build", *std_go_args
  end

  test do
    (testpath/"hello.go").write <<~EOS
      package main
      func main() {}
    EOS

    output = shell_output("#{bin}/codemap --json #{testpath}")
    assert_match "\"path\":\"hello.go\"", output
  end
end
